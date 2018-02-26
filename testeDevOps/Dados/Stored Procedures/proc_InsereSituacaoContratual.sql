
/*
	Autor: Egler Vieira
	Data Criação:20/07/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereSituacaoContratual
	Descrição: Procedimento que realiza a inserção das Situações Contratuais Possíveis no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereSituacaoContratual] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoContratual_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoContratual_TEMP];

CREATE TABLE [dbo].[SituacaoContratual_TEMP](
	[IDSITUACAO]               [varchar](6) NULL,
	[IDSUBSITUACAO]            [varchar](11) NULL,
	[NOM_SITUACAO_CONTRATO]    [varchar](200) NOT NULL,
	[NOM_SUB_SITUACAO]         [varchar](200) NOT NULL,
	[ORIGEM_SITUACAO]          [varchar](58) NOT NULL,
	[IND_ORIGEM_SITUACAO]      [smallint] NOT NULL
)


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_SituacaoContratual_TEMP ON [dbo].[SituacaoContratual_TEMP]
( 
  [IDSUBSITUACAO] ASC
)         


--SELECT @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'Produtor'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[SituacaoContratual_TEMP] 
                       (
                        [IDSITUACAO]           
                      , [IDSUBSITUACAO]        
                      , [NOM_SITUACAO_CONTRATO]
                      , [NOM_SUB_SITUACAO]     
                      , [ORIGEM_SITUACAO]      
                      , [IND_ORIGEM_SITUACAO]  
                       )
                SELECT DISTINCT
                      	  [IDSITUACAO]           
                        , [IDSUBSITUACAO]        
                        , [NOM_SITUACAO_CONTRATO]
                        , [NOM_SUB_SITUACAO]     
                        , [ORIGEM_SITUACAO]      
                        , [IND_ORIGEM_SITUACAO]  

                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaSituacaoContratual] '') PRP'

EXEC (@COMANDO)     

                
--SELECT @MaiorCodigo= MAX(PRP.Codigo)
--FROM [dbo].[Produtor_TEMP] PRP
                  
/*********************************************************************************************************************/

--WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as SituacaoContratual
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.SituacaoContratual AS T
		USING (

		  SELECT DISTINCT
              	          [IDSITUACAO]  ID  
                        , [NOM_SITUACAO_CONTRATO] Descricao
                        , [IND_ORIGEM_SITUACAO] IDOrigem

          FROM [SituacaoContratual_TEMP] ST
          WHERE [IND_ORIGEM_SITUACAO] > 0
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
    --Comando para inserir as Sub SituacaoContratual
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.SituacaoContratual AS T
		USING (

		  SELECT DISTINCT 
              	          [IDSITUACAO]  IDSituacaoMae  
                        , [IDSUBSITUACAO] ID
                        , [NOM_SUB_SITUACAO] Descricao
                        , [IND_ORIGEM_SITUACAO] IDOrigem

          FROM [SituacaoContratual_TEMP] ST
          WHERE [IND_ORIGEM_SITUACAO] > 0
          ) S
   ON   T.ID = S.[ID]
		WHEN MATCHED
			THEN UPDATE 
				SET T.Descricao = COALESCE(S.Descricao, T.Descricao)
				   ,T.IDOrigem = COALESCE(S.IDOrigem, T.IDOrigem)
                   ,T.IDSituacaoMae = COALESCE(S.IDSituacaoMae, T.IDSituacaoMae)
		WHEN NOT MATCHED
			THEN INSERT (
			         
                     ID
                    ,IDSituacaoMae
                    ,Descricao
                    ,IDOrigem
                     )
				    VALUES (S.ID, IDSituacaoMae, S.Descricao, S.IDOrigem);
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
  TRUNCATE TABLE [dbo].[SituacaoContratual_TEMP]   
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoContratual_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoContratual_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

/*



SELECT distinct *
FROM Dados.[SituacaoContratual]
*/


