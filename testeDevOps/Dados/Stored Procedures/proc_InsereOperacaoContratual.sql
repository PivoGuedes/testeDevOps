
/*
	Autor: Egler Vieira
	Data Criação:18/07/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereOperacaoContratual
	Descrição: Procedimento que realiza a inserção das Situações Contratuais Possíveis no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereOperacaoContratual] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperacaoContratual_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[OperacaoContratual_TEMP];

CREATE TABLE [dbo].[OperacaoContratual_TEMP](
	[IDOPERACAO]               [varchar](6) NULL,
	[IDSUBOPERACAO]            [varchar](11) NULL,
	[NOM_OPERACAO_CONTRATO]    [varchar](200) NOT NULL,
	[NOM_SUB_OPERACAO]         [varchar](200) NOT NULL,
	[ORIGEM_OPERACAO]          [varchar](58) NOT NULL,
	[IND_ORIGEM_OPERACAO]      [smallint] NOT NULL
)


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_OperacaoContratual_TEMP ON [dbo].[OperacaoContratual_TEMP]
( 
  [IDSUBOPERACAO] ASC
)         


--SELECT @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'Produtor'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[OperacaoContratual_TEMP] 
                       (
                        [IDOPERACAO]           
                      , [IDSUBOPERACAO]        
                      , [NOM_OPERACAO_CONTRATO]
                      , [NOM_SUB_OPERACAO]     
                      , [ORIGEM_OPERACAO]      
                      , [IND_ORIGEM_OPERACAO]  
                       )
                SELECT DISTINCT
                      	  [IDOPERACAO]           
                        , [IDSUBOPERACAO]        
                        , [NOM_OPERACAO_CONTRATO]
                        , [NOM_SUB_OPERACAO]     
                        , [ORIGEM_OPERACAO]      
                        , [IND_ORIGEM_OPERACAO]  

                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaOperacaoContratual] '') PRP'

EXEC (@COMANDO)     

                
--SELECT @MaiorCodigo= MAX(PRP.Codigo)
--FROM [dbo].[Produtor_TEMP] PRP
                  
/*********************************************************************************************************************/

--WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as OperacaoContratual
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.OperacaoContratual AS T
		USING (

		  SELECT DISTINCT
              	          [IDOPERACAO]  ID  
                        , [NOM_OPERACAO_CONTRATO] Descricao
                        , [IND_ORIGEM_OPERACAO] IDOrigem

          FROM [OperacaoContratual_TEMP] ST
          WHERE [IND_ORIGEM_OPERACAO] > 0
          ) S
   ON   T.ID = S.[ID]
		WHEN MATCHED
			THEN UPDATE 
				SET T.Descricao = COALESCE(S.Descricao, T.Descricao)
				   ,T.IDOrigem = COALESCE(S.IDOrigem, T.IDOrigem)
		WHEN NOT MATCHED
			THEN INSERT (
			         
                     ID
                    ,Descricao
                    ,IDOrigem
                     )
				    VALUES (S.ID, S.Descricao, S.IDOrigem);
    -----------------------------------------------------------------------------------------------------------------------				
    

        -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as Sub OperacaoContratual
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.OperacaoContratual AS T
		USING (

		  SELECT DISTINCT 
              	          [IDOPERACAO]  IDOperacaoMae  
                        , [IDSUBOPERACAO] ID
                        , [NOM_SUB_OPERACAO] Descricao
                        , [IND_ORIGEM_OPERACAO] IDOrigem

          FROM [OperacaoContratual_TEMP] ST
          WHERE [IND_ORIGEM_OPERACAO] > 0
          ) S
   ON   T.ID = S.[ID]
		WHEN MATCHED
			THEN UPDATE 
				SET T.Descricao = COALESCE(S.Descricao, T.Descricao)
				   ,T.IDOrigem = COALESCE(S.IDOrigem, T.IDOrigem)
                   ,T.IDOperacaoMae = COALESCE(S.IDOperacaoMae, T.IDOperacaoMae)
		WHEN NOT MATCHED
			THEN INSERT (
			         
                     ID
                    ,IDOperacaoMae
                    ,Descricao
                    ,IDOrigem
                     )
				    VALUES (S.ID, IDOperacaoMae, S.Descricao, S.IDOrigem);
    -----------------------------------------------------------------------------------------------------------------------		


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  --SET @PontoDeParada = @MaiorCodigo
  
  --UPDATE ControleDados.PontoParada 
  --SET PontoParada = @MaiorCodigo
  --WHERE NomeEntidade = 'Produtor'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[OperacaoContratual_TEMP]   
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperacaoContratual_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[OperacaoContratual_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

/*



SELECT distinct *
FROM Dados.[OperacaoContratual]
*/

