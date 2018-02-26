
/*
	Autor: Egler Vieira
	Data Criação: 07/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_QuestionarioMultiRisco_TIPO6_SRG3
	Descrição: Procedimento que realiza a inserção de QUESTIONARIO DE RISCO (MULTIRISCO) SUBREGISTRO 3
	           das propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_QuestionarioMultiRisco_TIPO6_SRG3] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP];
	/*
		RAISERROR   (N'A tabela temporária [QuestionarioMultiRisco_TIPO6_SRG3_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END

CREATE TABLE [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[CodigoCobertura] [smallint] NULL,
	[CodigoPerguntaRisco] [smallint] NULL,
	[CodigoRespostaRisco] [smallint] NULL,
	[ComplementoResposta] [varchar](150) NULL
)                     

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_QuestionarioMultiRisco_TIPO6_SRG3_TEMP ON [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]
( 
  [NumeroPropostaTratado] ASC,
  [CodigoCobertura] ASC,
  [CodigoPerguntaRisco] ASC,
  [CodigoRespostaRisco]	ASC
)   
WITH(FILLFACTOR=100)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_QuestionarioMultiRisco_TIPO6_SRG3'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.QuestionarioMultiRisco_TIPO6_SRG3_TEMP
        ( 
          [Codigo],                            
	        [ControleVersao],                    
	        [NomeArquivo],                       
	        [DataArquivo],                       
	        [NumeroProposta],                    
	        [CodigoCobertura],
	        [CodigoPerguntaRisco] ,
	        [CodigoRespostaRisco],
	        [ComplementoResposta] 	          
	          )
     SELECT 
          [Codigo],                            
	        [ControleVersao],                    
	        [NomeArquivo],                       
	        [DataArquivo],                       
	        [NumeroProposta],                    
	        [CodigoCobertura],
	        [CodigoPerguntaRisco] ,
	        [CodigoRespostaRisco],
	        [ComplementoResposta]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_QuestionarioMultiRisco_TIPO6_SRG3] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.QuestionarioMultiRisco_TIPO6_SRG3_TEMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

  
   /***********************************************************************
     Carregar as COBERTURAS
   ***********************************************************************/
     ;MERGE INTO Dados.Cobertura AS T
      USING (SELECT DISTINCT Q.CodigoCobertura, '' [Nome] 
             FROM QuestionarioMultiRisco_TIPO6_SRG3_TEMP Q
             WHERE Q.CodigoCobertura IS NOT NULL
            ) X
       ON T.[Codigo] = X.CodigoCobertura 
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Nome)
	               VALUES (X.[CodigoCobertura], X.[Nome])
   /***********************************************************************/   
               
      
   
  /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.Proposta AS T
    USING (SELECT DISTINCT Q.[NumeroPropostaTratado], 1 [IDSeguradora], Q.[NomeArquivo], Q.[DataArquivo]
        FROM [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP] Q
        WHERE Q.NumeroPropostaTratado IS NOT NULL
          ) X
    ON T.NumeroProposta = X.NumeroPropostaTratado
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
           THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, -1, 0, -1, 'PRP-MULTIRSITO-TP6-SRG3', X.DataArquivo);               
               
               
    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(Q.[DataArquivo]) [DataArquivo]
          FROM [QuestionarioMultiRisco_TIPO6_SRG3_TEMP] Q
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = Q.NumeroPropostaTratado
          AND PRP.IDSeguradora = 1
          WHERE Q.NumeroPropostaTratado IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, 'PRP-MULTIRSITO-TP6-SRG3', X.[NomeCliente], X.[DataArquivo]);   
                                
		               
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaQuestionarioMultiRisco AS T
		USING (       
            SELECT *                                                                          
            FROM                                                                              
            (                                                                                
            SELECT                                                                           
              Q.[Codigo],                                                     
              Q.[ControleVersao],                                             
              Q.[NomeArquivo] [Arquivo],                                                
              Q.[DataArquivo],                           
              PRP.ID [IDProposta],                     
              C.[IDCobertura],
              Q.CodigoPerguntaRisco [IDPerguntaRisco],   
              Q.[CodigoRespostaRisco] [IDRespostaRisco],                                             
              Q.[ComplementoResposta],              
              ROW_NUMBER() OVER(PARTITION BY PRP.[ID], Q.[CodigoCobertura], Q.[CodigoPerguntaRisco], Q.[CodigoRespostaRisco] ORDER BY Q.DataArquivo DESC, Q.[Codigo] DESC)  [ORDER]
            FROM [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]  Q
              LEFT JOIN Dados.Proposta PRP
              ON PRP.NumeroProposta = Q.NumeroPropostaTratado
              OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
                           FROM Dados.Cobertura C
                           WHERE C.Codigo = Q.CodigoCobertura
                           ORDER BY ID ASC) C
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  T.[IDProposta] = X.[IDProposta]
    AND T.[IDCobertura] = X.[IDCobertura]
    AND T.[IDPerguntaRisco] = X.[IDPerguntaRisco]
	  AND T.[IDRespostaRisco] = X.[IDRespostaRisco]
    WHEN MATCHED
			    THEN UPDATE
				     SET
				         [ComplementoResposta] = COALESCE(X.[ComplementoResposta], T.[ComplementoResposta])
				        ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo]) 
				        ,[Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo]) 

    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDCobertura]  
                , [IDPerguntaRisco]
                , [IDRespostaRisco]
                , [ComplementoResposta] 
                , [DataArquivo]    
                , [Arquivo]
                )
          VALUES (   
                  X.[IDProposta]                      
                , X.[IDCobertura]  
                , X.[IDPerguntaRisco]
                , X.[IDRespostaRisco]
                , X.[ComplementoResposta] 
                , X.[DataArquivo]    
                , X.[Arquivo]
                ); 
  /*************************************************************************************/ 


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_QuestionarioMultiRisco_TIPO6_SRG3'
  /*************************************************************************************/
  
    
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]        
  /*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.QuestionarioMultiRisco_TIPO6_SRG3_TEMP
        ( 
          [Codigo],                            
	        [ControleVersao],                    
	        [NomeArquivo],                       
	        [DataArquivo],                       
	        [NumeroProposta],                    
	        [CodigoCobertura],
	        [CodigoPerguntaRisco] ,
	        [CodigoRespostaRisco],
	        [ComplementoResposta] 	          
	          )
     SELECT 
          [Codigo],                            
	        [ControleVersao],                    
	        [NomeArquivo],                       
	        [DataArquivo],                       
	        [NumeroProposta],                    
	        [CodigoCobertura],
	        [CodigoPerguntaRisco] ,
	        [CodigoRespostaRisco],
	        [ComplementoResposta]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_QuestionarioMultiRisco_TIPO6_SRG3] ''''' + @PontoDeParada + ''''''') PRP
         '
  exec (@COMANDO) 

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.QuestionarioMultiRisco_TIPO6_SRG3_TEMP PRP    

  
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[QuestionarioMultiRisco_TIPO6_SRG3_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_QuestionarioMultiRisco_TIPO6_SRG3] 


