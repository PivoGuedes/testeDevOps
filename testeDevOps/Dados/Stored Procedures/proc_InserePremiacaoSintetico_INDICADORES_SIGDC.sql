
/*
	Autor: Egler Vieira
	Data Criação: 11/11/2013

	Descrição: 
	
	Última alteração : Egler Vieira -> 2015-08-11 - Transferência do controle de ponto de parada para a proc CORPORATIVO.Dados.proc_InserePremiacao e inclusão da validação do tipo de acordo.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacaoSintetico_INDICADORES
	Descrição: Procedimento que realiza a inserção da premiação sintética dos indicadores
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS


EXEC [Dados].[proc_InserePremiacaoSintetico_INDICADORES_SIGDC] @PontoDeParada='2016-02-05', @TipoAcordo='GI' 	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InserePremiacaoSintetico_INDICADORES_SIGDC] (@PontoDeParada AS DATE, @TipoAcordo VARCHAR(2) = 'I') as
BEGIN TRY	

 
--DECLARE @TipoAcordo VARCHAR(2) = 'I'
--DECLARE @PontoDeParada AS date = '2016-02-05'
--DECLARE @MaiorCodigo AS DATE
--DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max)
DECLARE @NomeEntidade VARCHAR(40)   
   
   	
IF (@TipoAcordo = 'GI')   
BEGIN
  SET @NomeEntidade = 'PremiacaoSintetico_GERENTE_INDICADORES' 

END
ELSE 
  IF (@TipoAcordo = 'I') 
  BEGIN
    SET @NomeEntidade ='PremiacaoSintetico_INDICADORES'
  END
  ELSE
    IF (@TipoAcordo = 'SR') 
	BEGIN
	 SET @NomeEntidade ='PremiacaoSintetico_SUPERINTENDENTE_INDICADORES'
	END
    ELSE
	  THROW 60000, N'Daily - Indicadores - Carga Corporativo. Tipo de premiação não permitida', 1;

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoSintetico_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP];

CREATE TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP](
	[Codigo] [int]  NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](300) NULL,
	[MatriculaIndicador] [varchar](8) NOT NULL,
	[CPF] [varchar](20)  NULL,
	[Nome] [varchar](100)  NULL,
	[CodigoAgencia] [smallint] NULL,
	[OperacaoConta] [varchar](10) NULL,
	[DigitoConta] [varchar](10) NULL,
	[NumeroConta] [varchar](12) NULL,
	[ValorBrutoComissao] [decimal](19, 2) NULL,
	[ValorINSS] [decimal](19, 2) NULL,
	[ValorIRF] [decimal](19, 2) NULL,
	[ValorISS] [decimal](19, 2) NULL,
	[ValorLiquido] [decimal](19, 2) NULL,
	[DataArquivo] [date] NULL,
	[TipoDado] AS (Cast(CASE WHEN CHARINDEX('CO3381B', NomeArquivo) > 1 THEN 'CO3381B' ELSE 'CO318B' END AS VARCHAR(30))) PERSISTED,
	TipoAcordo VARCHAR(2),
	Gerente AS (Cast( CASE WHEN TipoAcordo = 'I' THEN 0 ELSE 1 END as bit)) PERSISTED,
	MesReferencia [date]
)  

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PremiacaoSintetico_INDICADORES_TEMP ON [dbo].[PremiacaoSintetico_INDICADORES_TEMP]
( 
  [MatriculaIndicador],   
  [CPF] 	  
)	

---- CREATE NONCLUSTERED INDEX idx_PremiacaoSintetico_Apolice_INDICADORES_TEMP ON [dbo].[PremiacaoSintetico_INDICADORES_TEMP]
----( 
----  [NumeroApolice],
----  [NumeroEndosso],
----  [CodigoSubGrupo]
----)
---- INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroTitulo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

---- CREATE NONCLUSTERED INDEX idx_PremiacaoSintetico_Titulo_INDICADORES_TEMP ON [dbo].[PremiacaoSintetico_INDICADORES_TEMP]
----( 
----  [NumeroTitulo]
----)
---- INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroApolice], [CodigoSubGrupo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

   
--select @PontoDeParada = 20007037


                  
/*********************************************************************************************************************/


BEGIN 

--select @PontoDeParada = 20007037

	SET @COMANDO = Cast(@PontoDeParada  as varchar(10)) + ';' + @TipoAcordo


	SET @COMANDO = 'INSERT INTO [dbo].[PremiacaoSintetico_INDICADORES_TEMP] (
							[Codigo] ,
							[ControleVersao] ,
							[NomeArquivo] ,
							[MatriculaIndicador] ,
							[CPF],
							[Nome],
							[CodigoAgencia] ,
							[OperacaoConta] ,
							[DigitoConta] ,
							[NumeroConta] ,
							[ValorBrutoComissao] ,
							[ValorINSS] ,
							[ValorIRF] ,
							[ValorISS] ,
							[ValorLiquido] ,
							[DataArquivo],
							MesReferencia,
							TipoAcordo							
							)  
					SELECT  
                      		[Codigo] ,
							[ControleVersao] ,
							[NomeArquivo] ,
							[MatriculaIndicador] ,
							[CPF],
							[Nome],
							[CodigoAgencia] ,
							[OperacaoConta] ,
							[DigitoConta] ,
							[NumeroConta] ,
							[ValorBrutoComissao] ,
							[ValorINSS] ,
							[ValorIRF] ,
							[ValorISS] ,
							[ValorLiquido] ,
							[DataArquivo],
							MesReferencia,
							TipoAcordo
					FROM OPENQUERY ([OBERON], 
				  ''SET NOCOUNT ON;
                    set fmtonly off; EXEC [Fenae].[Corporativo].proc_RecuperaPremiacaoSintetico_INDICADORES_SIGDC ''''' + Cast(@COMANDO  as varchar(14)) + ''''''') PRM'

	EXEC (@COMANDO)     


    /***********************************************************************
       Carregar as agencias desconhecidas - PV (Agências/Posto de venda)
	***********************************************************************/
	;INSERT INTO Dados.Unidade(Codigo)	 
	SELECT DISTINCT PRM.CodigoAgencia
	FROM dbo.[PremiacaoSintetico_INDICADORES_TEMP] PRM
	WHERE  PRM.CodigoAgencia IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = PRM.CodigoAgencia)          


	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					PRM.[TipoDado], 
					MAX(PRM.DataArquivo) [DataArquivo], 
					'FUNDAO' [Arquivo]

	FROM dbo.[PremiacaoSintetico_INDICADORES_TEMP] PRM
	INNER JOIN Dados.Unidade U
	ON PRM.CodigoAgencia = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID, PRM.[TipoDado] 

    --InserirFuncionario (INDICADOR)

	/***********************************************************************
	Carregar os FUNCIONARIOS de proposta não carregados do SRH
	***********************************************************************/
	;MERGE INTO Dados.Funcionario AS T
		USING (           
			SELECT DISTINCT PRM.[MatriculaIndicador] [Matricula], 1 [IDEmpresa], Nome, CPF, PRM.TipoDado, PRM.DataArquivo -- Caixa Econômica                
			FROM dbo.[PremiacaoSintetico_INDICADORES_TEMP] PRM
			WHERE PRM.[MatriculaIndicador] IS NOT NULL
			) X
	ON T.[Matricula] = X.[Matricula] 
	AND T.IDEmpresa = X.IDEmpresa
	WHEN NOT MATCHED
				THEN INSERT ([Matricula], IDEmpresa, Nome, CPF, NomeArquivo, DataArquivo)
					VALUES (X.[Matricula], X.IDEmpresa, X.Nome, X.CPF, X.TipoDado, X.DataArquivo)  
	--WHEN MATCHED 
	-- THEN UPDATE SET Nome = COALESCE(T.Nome, X.Nome),
	--                 CPF = COALESCE(T.CPF, X.CPF);
	
	--	   truncate table dados.[RePremiacaoIndicadores]
	;


	MERGE INTO [Dados].[RePremiacaoIndicadores] T
	USING (
	    SELECT *
		FROM
		(
		SELECT F.ID [IDFuncionario], UA.ID [IDUnidade], PRM.[CPF], PRM.[Nome] [NomeIndicador], '104' Banco
		     , 0 AS [ContaCorrente], 0 AS [OperacaoConta]  
			 , [ValorBrutoComissao] [ValorBruto], ISNULL([ValorINSS],0) [ValorINSS], ISNULL([ValorIRF], 0) [ValorIRF], ISNULL([ValorISS], 0) [ValorISS], [ValorLiquido]
			 , PRM.DataArquivo, PRM.[NomeArquivo], MesReferencia [DataReferencia], [Gerente]	
			 , ROW_NUMBER() OVER(PARTITION BY PRM.[MatriculaIndicador], PRM.MesReferencia ORDER BY PRM.Codigo DESC) ORDEM	                                        
		FROM dbo.[PremiacaoSintetico_INDICADORES_TEMP] PRM
		--INNER JOIN Dados.Proposta PRP
		--ON  PRP.NumeroProposta = PRM.NumeroTitulo
		--AND PRP.IDSeguradora = PRM.IDSeguradora
		--INNER JOIN Dados.Contrato CNT
		--ON  CNT.NumeroContrato = PRM.NumeroApolice
		--AND CNT.IDSeguradora = PRM.IDSeguradora
		LEFT OUTER JOIN Dados.Unidade UA
		ON PRM.CodigoAgencia = UA.Codigo
		INNER JOIN Dados.Funcionario F
		ON F.Matricula = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		) A
		WHERE A.ORDEM = 1
		--and idfuncionario = 9536
	) X
	ON 	X.[IDFuncionario] = T.IDFuncionario
	AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[Gerente] = T.[Gerente]
	WHEN NOT MATCHED
	THEN INSERT ([IDFuncionario], [IDUnidade], [CPF], [NomeIndicador], Banco
		     ,  [ContaCorrente], [Operacao], [ValorBruto], [ValorINSS], [ValorIRF], [ValorISS], [ValorLiquido]
			 , DataArquivo, [NomeArquivo], DataReferencia, DataCompetencia, [Gerente])
	VALUES (X.[IDFuncionario], X.[IDUnidade], X.[CPF], X.[NomeIndicador],  X.Banco
		     ,  X.[ContaCorrente], X.[OperacaoConta], X.[ValorBruto], X.[ValorINSS], X.[ValorIRF], X.[ValorISS], X.[ValorLiquido]
			 , X.DataArquivo, X.[NomeArquivo], [DataReferencia], DATEADD(MM,-1,[DataReferencia]), X.[Gerente]);			   
						
/*
	MERGE INTO [Dados].[RePremiacaoIndicadores] T
	USING (
	    SELECT 
		IDFuncionario 
		,IDUnidade 
		,CPF                  
		,NomeIndicador                                                                                        
		,Banco 
		,ContaCorrente 
		,OperacaoConta 
		,SUM(ValorBruto) AS ValorBruto                              
		,SUM(ValorINSS) AS ValorINSS                               
		,SUM(ValorIRF) AS ValorIRF                                
		,SUM(ValorISS) AS ValorISS                             
		,SUM(ValorLiquido) AS ValorLiquido                            
		,DataArquivo 
		,MAX(NomeArquivo) AS NomeArquivo                                                                                                                                                                                                                                                      
		,DataReferencia 
		,Gerente 
		FROM
		(
		SELECT F.ID [IDFuncionario], UA.ID [IDUnidade], PRM.[CPF], PRM.[Nome] [NomeIndicador], '104' Banco
		     , 0 AS [ContaCorrente], 0 AS [OperacaoConta]  
			 , [ValorBrutoComissao] [ValorBruto], ISNULL([ValorINSS],0) [ValorINSS], ISNULL([ValorIRF], 0) [ValorIRF], ISNULL([ValorISS], 0) [ValorISS], [ValorLiquido]
			 , PRM.DataArquivo, PRM.[NomeArquivo], MesReferencia [DataReferencia], [Gerente]	
			 , ROW_NUMBER() OVER(PARTITION BY PRM.[MatriculaIndicador], PRM.MesReferencia ORDER BY PRM.Codigo DESC) ORDEM	                                        
		                                        

		FROM dbo.[PremiacaoSintetico_INDICADORES_TEMP] PRM
		--INNER JOIN Dados.Proposta PRP
		--ON  PRP.NumeroProposta = PRM.NumeroTitulo
		--AND PRP.IDSeguradora = PRM.IDSeguradora
		--INNER JOIN Dados.Contrato CNT
		--ON  CNT.NumeroContrato = PRM.NumeroApolice
		--AND CNT.IDSeguradora = PRM.IDSeguradora
		LEFT OUTER JOIN Dados.Unidade UA
		ON PRM.CodigoAgencia = UA.Codigo
		INNER JOIN Dados.Funcionario F
		ON F.Matricula = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		) A

		GROUP BY
		IDFuncionario 
		,IDUnidade 
		,CPF                  
		,NomeIndicador                                                                                        
		,Banco 
		,ContaCorrente 
		,OperacaoConta 
		,DataArquivo 
		--,NomeArquivo                                                                                                                                                                                                                                                      
		,DataReferencia 
		,Gerente 
		--,ORDEM

--		WHERE A.ORDEM = 1
		--and idfuncionario = 9536
	) X
	ON 	X.[IDFuncionario] = T.IDFuncionario
	AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[Gerente] = T.[Gerente]
	WHEN NOT MATCHED
	THEN INSERT ([IDFuncionario], [IDUnidade], [CPF], [NomeIndicador], Banco
		     ,  [ContaCorrente], [Operacao], [ValorBruto], [ValorINSS], [ValorIRF], [ValorISS], [ValorLiquido]
			 , DataArquivo, [NomeArquivo], DataReferencia, DataCompetencia, [Gerente])
	VALUES (X.[IDFuncionario], X.[IDUnidade], X.[CPF], X.[NomeIndicador],  X.Banco
		     ,  X.[ContaCorrente], X.[OperacaoConta], X.[ValorBruto], X.[ValorINSS], X.[ValorIRF], X.[ValorISS], X.[ValorLiquido]
			 , X.DataArquivo, X.[NomeArquivo], [DataReferencia], DATEADD(MM,-1,[DataReferencia]), X.[Gerente]);			   
				
*/
						
  EXEC [Dados].[proc_InserePremiacaoINSS_INDICADORES] @PontoDeParada;
  --TODO - InserirContratoCliente (OU NÃO)
  						     

  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP] 

  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoSintetico_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

--EXEC [Dados].[proc_InserePremiacaoSintetico_INDICADORES] 1



