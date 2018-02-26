
--EXEC [Dados].[proc_InsereCorrespondente_LARMAIS] 
 
/*
	Autor: Sandrine Oliveira 
	Data Criação: 24/02/2017

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCorrespondente_LARMAIS
	Descrição: Procedimento que realiza a inserção de cadastro de Correspondente Bancário no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereCorrespondente_LARMAIS] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CORRESPONDENTE_TEMP_LARMAIS]') AND type in (N'U') /*ORDER BY NAME*/)
DROP TABLE [dbo].[CORRESPONDENTE_TEMP_LARMAIS];

CREATE TABLE [dbo].[CORRESPONDENTE_TEMP_LARMAIS](
    [Codigo] [bigint] NOT NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NumeroMatricula] [numeric](15, 0) NULL,
	[CPFCNPJ] [varchar](20) NULL,
	[Nome] [varchar](140) NULL,
	[CodigoBanco] [smallint] NULL,
	[CodigoAgencia] [smallint] NULL,
	[CodigoOperacao] [smallint] NULL,
	[NumeroConta] [varchar](22) NULL,
	[Cidade] [varchar](70) NULL,
	[UF] [varchar](2) NULL,
	IDTipoCorrespondente AS (CASE WHEN CHARINDEX('/', CPFCNPJ) > 1 THEN 1 ELSE 2 END) PERSISTED,
	IDTipoProduto tinyint not null default(2)
);

--SELECT * FROM [dbo].[CORRESPONDENTE_TEMP]  C WHERE NumeroMatricula = 000220299

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_CORRESPONDENTE_LARMAIS_TEMP_NumeroPropost ON [dbo].[CORRESPONDENTE_TEMP_LARMAIS]
( 
	NumeroMatricula ASC,
	[DataArquivo] DESC
)


CREATE NONCLUSTERED INDEX IDX_CORRESPONDENTE_LARMAIS_TEMP_PontoVenda ON [dbo].[CORRESPONDENTE_TEMP_LARMAIS]
(
	[CodigoAgencia]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'CADASTRO_LARMAIS'

			   

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
  
    SET @COMANDO =
    '  INSERT INTO [dbo].CORRESPONDENTE_TEMP_LARMAIS
       ( 
	   [Codigo],
	   [NomeArquivo],
	   [DataArquivo],
	   [ControleVersao],
	   [NumeroMatricula],
	   [CPFCNPJ],
	   [Nome],
	   [CodigoBanco],
	   [CodigoAgencia],
	   [CodigoOperacao],
	   [NumeroConta],
	   [Cidade],
	   [UF]
		)
       SELECT   [Codigo],
			   [NomeArquivo],
			   [DataArquivo],
			   [ControleVersao],
			   [NumeroMatricula],
			   [CPFCNPJ],
			   [Nome],
			   [CodigoBanco],
			   [CodigoAgencia],
			   [CodigoOperacao],
			   [NumeroConta],
			   [Cidade],
			   [UF]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaCadastro_LARMAIS]''''' + @PontoDeParada + ''''''') PRP 
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM CORRESPONDENTE_TEMP_LARMAIS PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

--SELECT DISTINCT TipoCorrespondente FROM Dados.Correspondente
       					  
     /***********************************************************************
       Carrega os dados do Correspondente
     ***********************************************************************/             
    ;MERGE INTO Dados.Correspondente AS T
		USING (
				SELECT *
				FROM
				(
					SELECT  
						   C.[Codigo],
						   [NomeArquivo],
						   [DataArquivo],
						   [ControleVersao],
						   [NumeroMatricula],
						   [CPFCNPJ],
						   [Nome],
						   [Cidade],
						   [UF],
						   --[PontoVenda],
						   IDTipoCorrespondente,
						   ROW_NUMBER() OVER(PARTITION BY NumeroMatricula, CPFCNPJ ORDER BY DataArquivo DESC) ORDEM            
					FROM CORRESPONDENTE_TEMP_LARMAIS C
				 ) A 
				 WHERE A.ORDEM = 1
          ) AS X
    ON X.[NumeroMatricula] = T.[Matricula]  
   --AND X.[CPFCNPJ] = T.[CPFCNPJ]
   AND X.IDTipoCorrespondente = T.IDTipoCorrespondente
    WHEN MATCHED --AND X.DataArquivo > T.DataArquivo
			    THEN UPDATE
			 SET [Nome] = COALESCE(X.[Nome], T.[Nome])
			   , IDTipoCorrespondente = COALESCE(X.IDTipoCorrespondente, T.IDTipoCorrespondente)  
			   , UF = COALESCE(X.UF, T.UF)  
			   , Cidade = COALESCE(X.Cidade, T.Cidade)
			   , NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)              
               , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)   
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 Matricula
			   , CPFCNPJ
			   , Nome
			   , IDTipoCorrespondente   
			   , UF
			   , Cidade 
			   , NomeArquivo              
               , DataArquivo              
             )
          VALUES (X.[NumeroMatricula]
                 ,X.CPFCNPJ
                 ,X.[Nome]
                 ,X.IDTipoCorrespondente
				 ,X.UF
				 ,X.Cidade
                 ,X.NomeArquivo
                 ,X.DataArquivo
                 );    
                            
                     
	/***********************************************************************
       Carrega os dados bancários do Correspondente
     ***********************************************************************/             
    ;MERGE INTO Dados.CorrespondenteDadosBancarios AS T
		USING (
				SELECT *
				FROM
				(
					SELECT  
						   CC.ID [IDCorrespondente],
						   [CodigoBanco],
						   [CodigoAgencia],
						   [CodigoOperacao],
						   [NumeroConta],
						   IDTipoProduto,		
						   CC.IDTipoCorrespondente,
						   C.DataArquivo,
						   C.NomeArquivo,
						   ROW_NUMBER() OVER(PARTITION BY C.NumeroMatricula, C.CPFCNPJ ORDER BY C.DataArquivo DESC) ORDEM            
					FROM CORRESPONDENTE_TEMP_LARMAIS C
					    INNER JOIN Dados.Correspondente	CC
						ON 	C.[NumeroMatricula] = CC.[Matricula]   						
				 		AND	C.[CPFCNPJ] = CC.[CPFCNPJ]
						AND C.IDTipoCorrespondente = CC.IDTipoCorrespondente
												--and numeromatricula = 220299
												--AND C.Contrato IN ('655996','656013')
				 ) A 					
				 WHERE A.ORDEM = 1					 
          ) AS X
    ON  X.[IDCorrespondente] = T.[IDCorrespondente] 
	AND X.IDTipoProduto = T.IDTipoProduto
    
    WHEN MATCHED-- AND X.DataArquivo > T.DataArquivo
			    THEN UPDATE	SET				    
                 Banco = COALESCE(X.[CodigoBanco], T.Banco)
               , Agencia = COALESCE(X.[CodigoAgencia], T.Agencia)
               , Operacao = COALESCE(X.[CodigoOperacao], T.Operacao)
			   , ContaCorrente = COALESCE(X.[NumeroConta], T.ContaCorrente)
			   , NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)              
               , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)   
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 IDCorrespondente
			   , IDTipoProduto
               , Banco 
               , Agencia 
               , Operacao 
			   , ContaCorrente
			   , NomeArquivo              
               , DataArquivo              
             )
          VALUES (X.IDCorrespondente
                 ,X.IDTipoProduto
                 ,X.[CodigoBanco]
                 ,X.[CodigoAgencia]
                 ,X.[CodigoOperacao]
                 ,X.[NumeroConta]
                 ,X.NomeArquivo
                 ,X.DataArquivo
                 );  

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'CADASTRO_LARMAIS'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[CORRESPONDENTE_TEMP_LARMAIS]	   
  /*********************************************************************************************************************/                  
    
    SET @COMANDO =
    '  INSERT INTO CORRESPONDENTE_TEMP_LARMAIS
       ( 
	   [Codigo],
	   [NomeArquivo],
	   [DataArquivo],
	   [ControleVersao],
	   [NumeroMatricula],
	   [CPFCNPJ],
	   [Nome],
	   [CodigoBanco],
	   [CodigoAgencia],
	   [CodigoOperacao],
	   [NumeroConta],
	   [Cidade],
	   [UF]
		)
       SELECT   [Codigo],
			   [NomeArquivo],
			   [DataArquivo],
			   [ControleVersao],
			   [NumeroMatricula],
			   [CPFCNPJ],
			   [Nome],
			   [CodigoBanco],
			   [CodigoAgencia],
			   [CodigoOperacao],
			   [NumeroConta],
			   [Cidade],
			   [UF]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaCADASTRO_LARMAIS]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM CORRESPONDENTE_TEMP_LARMAIS PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CORRESPONDENTE_TEMP_LARMAIS]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CORRESPONDENTE_TEMP_LARMAIS];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

				


--EXEC [Dados].[proc_InsereCorrespondente_LARMAIS] 


