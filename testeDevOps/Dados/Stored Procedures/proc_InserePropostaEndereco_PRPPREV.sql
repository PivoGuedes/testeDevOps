 
/*
	Autor: Egler Vieira
	Data Criação: 19/11/2012

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePropostaEndereco_PRPPREV
	Descrição: Procedimento que realiza a inserção de endereços de PRPPREV no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePropostaEndereco_PRPPREV] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPPREV_Endereco_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPPREV_Endereco_TEMP];


CREATE TABLE [dbo].[PRPPREV_Endereco_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL, 	
	[IDSeguradora] [int] DEFAULT(4), --4 = PREVIDENCIA
    [NumeroPropostaTratado] as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[NumeroProposta] [numeric](14, 0) NULL,	 
	[IDTipoEndereco] [smallint] NULL,
	[TipoEndereco] [varchar](16) NULL,
	[Endereco] [varchar](80) NULL,
	[Bairro]   [varchar](80) NULL,
	[Cidade]   [varchar](80) NULL,
	[SiglaUF]  [varchar](16) NULL,
	[CEP]      [varchar](9) NULL
);

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PRPPREV_Endereco_TEMP_NumeroPropost ON [dbo].[PRPPREV_Endereco_TEMP]
( 
	NumeroProposta ASC,
	[DataArquivo] DESC
)

CREATE CLUSTERED INDEX idx_PRPPREV_Endereco_TEMP_NumeroPropost_TipoEndereco ON [dbo].[PRPPREV_Endereco_TEMP]
( 
	NumeroProposta ASC,
	TipoEndereco ASC,
	Endereco ASC
 )

		--SELECT   *
		--FROM OPENQUERY ([OBERON], 
		--'EXEC [Fenae].[Corporativo].[proc_RecuperaPRPPREV_Endereco]	''0''') PRP


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PropostaEndereco_PRPPREV'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.PRPPREV_Endereco_TEMP
       ( [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[IDTipoEndereco]
		,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
		)
       SELECT   [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[IDTipoEndereco]
		       ,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPRPPREV_Endereco] ''''' + @PontoDeParada + ''''''') PRP
         '
EXEC (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRPPREV_Endereco_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo
   

    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
	/*Egler - Data: 23/09/2013 */
    UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.PRPPREV_Endereco_TEMP PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroPropostaTratado] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = PRP_T.[IDSeguradora]
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
		  -- AND PS.IDProposta = 12585836

		   --TODO --ARRUMAR PARA GARANTIR QUE SEMPRE HAVERÁ UM REGISTRO COM LASTVALUE = 1 
    

	--SET NOCOUNT ON ;                       
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaEndereco AS T
		USING (
				SELECT 
					 A. [IDProposta]
					,A.[IDTipoEndereco]
					,A.Endereco        
					,A.Bairro              
					,A.Cidade       
					,A.[UF]      
					,A.CEP    
					--,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco ORDER BY A.DataArquivo DESC) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
					--						ELSE 0
					--	END) LastValue
					, 0 LastValue
					, A.[TipoDado]           
					, A.DataArquivo	
					,ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco, Endereco ORDER BY A.DataArquivo DESC) NUMERADOR

				FROM
				(
					SELECT   
						 PRP.ID [IDProposta]
						,[IDTipoEndereco]
						,PRP_T.Endereco        
						,MAX(PRP_T.Bairro) Bairro             
						,MAX(PRP_T.Cidade) Cidade       
						,MAX(PRP_T.SiglaUF)  [UF]      
						,MAX(PRP_T.CEP) CEP   
						--CASE WHEN  
						,'TIPO - 2' [TipoDado]           
						,MAX(PRP_T.DataArquivo) DataArquivo	   								
					FROM dbo.PRPPREV_Endereco_TEMP PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroPropostaTratado] = PRP.NumeroProposta
						AND PRP.IDSeguradora = PRP_T.[IDSeguradora]
					WHERE PRP_T.Endereco IS NOT NULL
					  and PRP_T.IDTIPOENDERECO <> 0
					-- AND PRP.ID = 12585836
					GROUP BY PRP.ID 
							,PRP_T.IDTipoEndereco 
							,PRP_T.Endereco        
	
				) A 				

          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
	AND NUMERADOR = 1 --Garante uma única ocorrência do mesmo endereço.
       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
		      UPDATE
				SET 
                 Endereco = COALESCE(X.[Endereco], T.[Endereco])
               , Bairro = COALESCE(X.[Bairro], T.[Bairro])
               , Cidade = COALESCE(X.[Cidade], T.[Cidade])
               , UF = COALESCE(X.[UF], T.[UF])
               , CEP = COALESCE(X.[CEP], T.[CEP])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
			   , DataArquivo = X.DataArquivo
			   , LastValue = X.LastValue
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, IDTipoEndereco, Endereco, Bairro                                                                
              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                            
          VALUES (
                  X.[IDProposta]   
                 ,X.[IDTipoEndereco]                                                
                 ,X.[Endereco]  
                 ,X.[Bairro]   
                 ,X.[Cidade]      
                 ,X.[UF] 
                 ,X.[CEP]            
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]
				 ,X.LastValue   
                 );
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 23/09/2013 */		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM dbo.PRPPREV_Endereco_TEMP PRP_T
										  INNER JOIN Dados.Proposta PRP
										  ON PRP_T.[NumeroPropostaTratado] = PRP.NumeroProposta
										 AND PRP.IDSeguradora = PRP_T.[IDSeguradora]
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1		  


   
                         
  /*TODO: Neste ponto, inserir os dados de PropostaSeguro*/
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'PropostaEndereco_PRPPREV'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRPPREV_Endereco_TEMP]
  
  /*********************************************************************************************************************/
                
  SET @COMANDO =
    '  INSERT INTO dbo.PRPPREV_Endereco_TEMP
       ( [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[IDTipoEndereco]
		,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
		)
       SELECT   [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[IDTipoEndereco]
		,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPRPPREV_Endereco] ''''' + @PontoDeParada + ''''''') PRP
         '
  exec (@COMANDO)    

  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PRPPREV_Endereco_TEMP PRP    
                    
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPPREV_Endereco_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPPREV_Endereco_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereProposta_PRPPREV_Endereco] 

