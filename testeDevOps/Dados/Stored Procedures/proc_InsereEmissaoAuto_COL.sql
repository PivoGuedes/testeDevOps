 
/*
	Autor: André Anselmo
	Data Criação: 09/04/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCorrespondente_CBN
	Descrição: Procedimento que realiza a inserção de cadastro de Correspondente Bancário no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereEmissaoAuto_COL] 
AS

BEGIN TRY		

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmissaoAuto_COL_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EmissaoAuto_COL_TEMP];

CREATE TABLE [dbo].[EmissaoAuto_COL_TEMP](
	CODIGOSEGURADORA SMALLINT
	,CODIGOPRODUTO  SMALLINT
	,NOMEPRODUTO VARCHAR(50)
	,NUMEROAPOLICE VARCHAR(20)
	,NUMEROPROPOSTA INT
	,NUMEROENDOSSO VARCHAR(20)
	,APOLICEANTERIOR VARCHAR(20)
	,SITUACAOENDOSSO SMALLINT
	,DATAINICIOVIGENCIAENDOSSO DATE
	,DATAFIMVIGENCIAENDOSSO DATE
	,DATAEMISSAO DATE
	,DATAVENDA DATE
	,DATAPROPOSTA DATE
	,DATASITUACAO DATE
	,DIAVENCIMENTO SMALLINT
	,CODIGOCOBERTURA SMALLINT
	,NOMECOBERTURA VARCHAR(50)
	,VALORPREMIOLIQUIDO DECIMAL(19,2)
	,VALORPREMIOBRUTO DECIMAL(19,2)
	,VALORIOF DECIMAL(19,2)
	,PERIDICIDADEPAGAMENTO VARCHAR(10)
	,SITUACAOPAGAMENTO VARCHAR(10)
	,SITUACAOPROPOSTA SMALLINT
	,SITUACAOCOBRANCA VARCHAR(10)
	,MOTIVODASITUACAO VARCHAR(50)
	,TIPOSEGURO SMALLINT
	,QUANTIDADEPARCELAS SMALLINT
	,VALORPRIMEIRAPARCELA DECIMAL(19,2)
	,VALORDEMAISPARCELAS DECIMAL(19,2)
)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'EmissaoAutoCOL'
         

/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
  
    SET @COMANDO =
    'WITH CT AS 
	(
		SELECT  
			CODIGOSEGURADORA
			,CODIGOPRODUTO
			,NumeroProposta
			,NOMEPRODUTO
			,NUMEROAPOLICE
			,NUMEROENDOSSO 
			,APOLICEANTERIOR
			,SITUACAOENDOSSO 
			,DATAINICIOVIGENCIAENDOSSO 
			,DATAFIMVIGENCIAENDOSSO 
			,DATAEMISSAO 
			,DATAPROPOSTA 
			,DATASITUACAO 
			,DIAVENCIMENTO 
			,CODIGOCOBERTURA 
			,NOMECOBERTURA 
			,VALORPREMIOLIQUIDO 
			,VALORPREMIOBRUTO 
			,VALORIOF 
			,PERIDICIDADEPAGAMENTO 
			,SITUACAOPAGAMENTO 
			,SITUACAOPROPOSTA 
			,SITUACAOCOBRANCA 
			,MOTIVODASITUACAO 
			,TIPOSEGURO 
			,QUANTIDADEPARCELAS 
			,VALORPRIMEIRAPARCELA
			,VALORDEMAISPARCELAS 
		FROM [Dados].[fn_RecuperaEmissaoAuto_COL]('+ @PontoDeParada + ')	
	)
	INSERT INTO dbo.EmissaoAuto_COL_TEMP
    ( 
		CODIGOSEGURADORA
		,CODIGOPRODUTO
		,NumeroProposta
		,NOMEPRODUTO
		,NUMEROAPOLICE
		,NUMEROENDOSSO 
		,APOLICEANTERIOR
		,SITUACAOENDOSSO 
		,DATAINICIOVIGENCIAENDOSSO 
		,DATAFIMVIGENCIAENDOSSO 
		,DATAEMISSAO 
		,DATAPROPOSTA 
		,DATASITUACAO 
		,DIAVENCIMENTO 
		,CODIGOCOBERTURA 
		,NOMECOBERTURA 
		,VALORPREMIOLIQUIDO 
		,VALORPREMIOBRUTO 
		,VALORIOF 
		,PERIDICIDADEPAGAMENTO 
		,SITUACAOPAGAMENTO 
		,SITUACAOPROPOSTA 
		,SITUACAOCOBRANCA 
		,MOTIVODASITUACAO 
		,TIPOSEGURO 
		,QUANTIDADEPARCELAS 
		,VALORPRIMEIRAPARCELA
		,VALORDEMAISPARCELAS
	)
       SELECT  
			CODIGOSEGURADORA
			,CODIGOPRODUTO
			,NumeroProposta
			,NOMEPRODUTO
			,NUMEROAPOLICE
			,NUMEROENDOSSO 
			,APOLICEANTERIOR
			,SITUACAOENDOSSO 
			,DATAINICIOVIGENCIAENDOSSO 
			,DATAFIMVIGENCIAENDOSSO 
			,DATAEMISSAO 
			,DATAPROPOSTA 
			,DATASITUACAO 
			,DIAVENCIMENTO 
			,CODIGOCOBERTURA 
			,NOMECOBERTURA 
			,VALORPREMIOLIQUIDO 
			,VALORPREMIOBRUTO 
			,VALORIOF 
			,PERIDICIDADEPAGAMENTO 
			,SITUACAOPAGAMENTO 
			,SITUACAOPROPOSTA 
			,SITUACAOCOBRANCA 
			,MOTIVODASITUACAO 
			,TIPOSEGURO 
			,QUANTIDADEPARCELAS 
			,VALORPRIMEIRAPARCELA
			,VALORDEMAISPARCELAS 
      FROM	CT ORDER BY NumeroProposta'
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(CAST(NumeroProposta AS INT))
FROM dbo.EmissaoAuto_COL_TEMP


--PRINT @MaiorCodigo
/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN


	/***********************************************************************
		   Carregar as seguradoras desconhecidas 
	***********************************************************************/
	MERGE INTO Dados.Seguradora AS T
	USING ( 
		SELECT DISTINCT CodigoSeguradora AS Codigo, 'Dados Incompletos' AS Nome
		FROM dbo.EmissaoAuto_COL_TEMP AS T
		WHERE  CODIGOSEGURADORA IS NOT NULL 
	) AS O
	ON T.Codigo=O.Codigo
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 Codigo
			   , Nome
             )
          VALUES (O.Codigo
                 ,O.Nome
                 );  

	/***********************************************************************
		   Carregar os produtos desconhecidos
	***********************************************************************/
	MERGE INTO Dados.Seguradora AS T
	USING ( 
		SELECT DISTINCT CodigoSeguradora AS Codigo, 'Dados Incompletos' AS Nome
		FROM dbo.EmissaoAuto_COL_TEMP AS T
		WHERE  CODIGOSEGURADORA IS NOT NULL 
	) AS O
	ON T.Codigo=O.Codigo
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 Codigo
			   , Nome
             )
          VALUES (O.Codigo
                 ,O.Nome
                 );  


	--INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

	--SELECT DISTINCT U.ID, 
	--				'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
	--				-1 [CodigoNaFonte], 
	--				'CADASTRO_CBN' [TipoDado], 
	--				MAX(EM.DataArquivo) [DataArquivo], 
	--				'CADASTRO_CBN' [Arquivo]

	--FROM dbo.[CORRESPONDENTE_TEMP] EM
	--INNER JOIN Dados.Unidade U
	--ON EM.PontoVenda = U.Codigo
	--WHERE 
	--	NOT EXISTS (
	--				SELECT     *
	--				FROM Dados.UnidadeHistorico UH
	--				WHERE UH.IDUnidade = U.ID)    
	--GROUP BY U.ID 
        
		      
                     
	   /***********************************************************************
       Carrega os dados bancários do Correspondente
     ***********************************************************************/             
 --   ;MERGE INTO Dados.CorrespondenteDadosBancarios AS T
	--	USING (
	--			SELECT *
	--			FROM
	--			(
	--				SELECT  
	--					   CC.ID [IDCorrespondente],
	--					   [CodigoBanco],
	--					   [CodigoAgencia],
	--					   [CodigoOperacao],
	--					   [NumeroConta],
	--					   IDTipoProduto,		
	--					   CC.IDTipoCorrespondente,
	--					   C.DataArquivo,
	--					   C.NomeArquivo,
	--					   ROW_NUMBER() OVER(PARTITION BY C.NumeroMatricula, C.CPFCNPJ ORDER BY C.DataArquivo DESC) ORDEM            
	--				FROM dbo.CORRESPONDENTE_TEMP C
	--				    INNER JOIN Dados.Correspondente	CC
	--					ON 	C.[NumeroMatricula] = CC.[Matricula] 
	--			 		AND	C.[CPFCNPJ] = CC.[CPFCNPJ]
	--					AND C.IDTipoCorrespondente = CC.IDTipoCorrespondente
	--			 ) A 					
	--			 WHERE A.ORDEM = 1
 --         ) AS X
 --   ON X.[IDCorrespondente] = T.[IDCorrespondente] 
	--AND X.IDTipoProduto = T.IDTipoProduto
    
 --   WHEN MATCHED AND X.DataArquivo > T.DataArquivo
	--		    THEN UPDATE	SET				    
 --                Banco = COALESCE(X.[CodigoBanco], T.Banco)
 --              , Agencia = COALESCE(X.[CodigoAgencia], T.Agencia)
 --              , Operacao = COALESCE(X.[CodigoOperacao], T.Operacao)
	--		   , ContaCorrente = COALESCE(X.[NumeroConta], T.ContaCorrente)
	--		   , NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)              
 --              , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)   
 --   WHEN NOT MATCHED
	--		    THEN INSERT          
 --             (	 IDCorrespondente
	--		   , IDTipoProduto
 --              , Banco 
 --              , Agencia 
 --              , Operacao 
	--		   , ContaCorrente
	--		   , NomeArquivo              
 --              , DataArquivo              
 --            )
 --         VALUES (X.IDCorrespondente
 --                ,X.IDTipoProduto
 --                ,X.[CodigoBanco]
 --                ,X.[CodigoAgencia]
 --                ,X.[CodigoOperacao]
 --                ,X.[NumeroConta]
 --                ,X.NomeArquivo
 --                ,X.DataArquivo
 --                );  
				       
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  --SET @PontoDeParada = @MaiorCodigo
  
  --UPDATE ControleDados.PontoParada 
  --SET PontoParada = @MaiorCodigo
  --WHERE NomeEntidade = ''

  /*********************************************************************************************************************/
--  TRUNCATE TABLE [dbo].[CORRESPONDENTE_TEMP]	   
  /*********************************************************************************************************************/                  
    
--    SET @COMANDO =
--    '  INSERT INTO dbo.CORRESPONDENTE_TEMP
--       ( 
--	   [Codigo],
--	   [NomeArquivo],
--	   [DataArquivo],
--	   [ControleVersao],
--	   [NumeroMatricula],
--	   [CPFCNPJ],
--	   [Nome],
--	   [CodigoBanco],
--	   [CodigoAgencia],
--	   [CodigoOperacao],
--	   [NumeroConta],
--	   [Cidade],
--	   [UF],
--	   [PontoVenda] 
--		)
--       SELECT   [Codigo],
--			   [NomeArquivo],
--			   [DataArquivo],
--			   [ControleVersao],
--			   [NumeroMatricula],
--			   [CPFCNPJ],
--			   [Nome],
--			   [CodigoBanco],
--			   [CodigoAgencia],
--			   [CodigoOperacao],
--			   [NumeroConta],
--			   [Cidade],
--			   [UF],
--			   [PontoVenda] 
--       FROM OPENQUERY ([OBERON], 
--       ''EXEC [Fenae].[Corporativo].[proc_recuperaCadastro_CBN]''''' + @PontoDeParada + ''''''') PRP
--         '
--exec (@COMANDO) 
                  
--  SELECT @MaiorCodigo= MAX(PRP.Codigo)
--  FROM dbo.CORRESPONDENTE_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
-- IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CORRESPONDENTE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
--	DROP TABLE [dbo].[CORRESPONDENTE_TEMP];

END TRY                
BEGIN CATCH
	
--  EXEC CleansingKit.dbo.proc_RethrowError	

END CATCH     

				


--EXEC [Dados].[proc_InsereCorrespondente_CBN] 








--	 EXEC [Dados].[proc_RecuperaEmissaoAuto_COL] 0

