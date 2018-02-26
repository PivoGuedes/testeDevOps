
/*
	Autor: Egler Vieira
	Data Criação: 11/11/2013

	Descrição: 


*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacaoAnalitico_INDICADORES
	Descrição: Procedimento que realiza a inserção da premiação analítica dos indicadores
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePremiacaoAnalitico_INDICADORES_SIGDC] (@PontoDeParada AS DATE, @TipoAcordo VARCHAR(2) = 'I') as
BEGIN TRY		
--select @@trancount
 
-- DECLARE @TipoAcordo VARCHAR(2) = 'SR'
--DECLARE @PontoDeParada AS DATE	   = '2015-08-24' 


DECLARE @COMANDO AS NVARCHAR(max) 
DECLARE @NomeEntidade VARCHAR(40)   
    

IF (@TipoAcordo = 'GI')   
BEGIN
  SET @NomeEntidade = 'PremiacaoAnalitico_GERENTE_INDICADORES' 

END
ELSE 
  IF (@TipoAcordo = 'I') 
  BEGIN
    SET @NomeEntidade ='PremiacaoAnalitico_INDICADORES'
  END
  ELSE
    IF (@TipoAcordo = 'SR') 
	BEGIN
	 SET @NomeEntidade ='PremiacaoAnalitic_SUPERINTENDENTE_INDICADORES'
	END
	ELSE
	  THROW 60000, N'Daily - Indicadores - Carga Corporativo. Tipo de premiação não permitida', 1;

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoAnalitico_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoAnalitico_INDICADORES_TEMP];

CREATE TABLE [dbo].[PremiacaoAnalitico_INDICADORES_TEMP](
	[Codigo] [int] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](150) NULL,
	[DataArquivo] [date] NULL,
	[TipoDado] [varchar] (100) NOT NULL, 
	[CodigoProduto] [varchar](5) NOT NULL,
	[IDSeguradora] AS (Cast(CASE [TipoDado]
							 WHEN 'AZULCAR' THEN 1
							 WHEN 'FEDPREV'	THEN 4
							 WHEN 'BILHRD'	THEN 1
					  		 WHEN 'CAPPM60'	THEN 5
							 WHEN 'BILHAP'	THEN 1
							 WHEN 'COPACAP'	THEN 3
							 WHEN 'VIDAAZUL' THEN 1
							 ELSE 
							  CASE WHEN Cast(CodigoProduto as int) > 9400 THEN 4
							       WHEN Cast(CodigoProduto as int) BETWEEN 9201 AND 9250 THEN 4 
							       WHEN Cast(CodigoProduto as int) BETWEEN 5501 AND 5627 THEN 4 
								   WHEN Cast(CodigoProduto as int) = 60 THEN 5
								   WHEN Cast(CodigoProduto as int) BETWEEN 222 AND 413 THEN 3  
								   WHEN Cast(CodigoProduto as int) BETWEEN 1403 AND 3180 THEN 1 
								   WHEN Cast(CodigoProduto as int) IN (3709, 5302, 7701, 7709, 8105,8203, 8205, 8209) THEN 0  
								   WHEN Cast(CodigoProduto as int) BETWEEN 9311 AND 9361 THEN 0 
								   WHEN Cast(CodigoProduto as int) IN (6814,7114, 8112, 8113, 8201) THEN 1 
							  ELSE
							   0
							  END
						 END as smallint)) PERSISTED,
	[CodigoEN] [smallint] NULL,
	[CodigoPV] [smallint] NULL,
	[MatriculaIndicador] [varchar](20) NOT NULL,

	[ValorBruto] [decimal](19, 5) NOT NULL,
	[TipoPagamento] [varchar] (2) NULL,
    [ValorCalculado]  AS (CASE WHEN TipoPagamento = 'D' THEN ValorBruto * -1 WHEN TipoPagamento IN ('C','0') THEN ValorBruto ELSE NULL END) PERSISTED,
	[NumeroApolice] [varchar](20) NULL,
	[NumeroEndosso] [bigint] NOT NULL,
	[NumeroParcela] [int] NULL,
	[NumeroTitulo] [varchar](20) NULL,
	[CodigoSubGrupo] [varchar](20) NOT NULL,
	[Ocorrencia] [int] NOT NULL,
	[NomeSegurado] [varchar](200) NULL,
	TipoAcordo VARCHAR(2),
	Gerente AS (Cast( CASE WHEN TipoAcordo = 'I' THEN 0 ELSE 1 END as bit)) PERSISTED,
	DataEmissao DATE NULL,
) 
 
 --SELECT * FROM [PremiacaoAnalitico_INDICADORES_TEMP]

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PremiacaoAnalitico_INDICADORES_TEMP ON [dbo].[PremiacaoAnalitico_INDICADORES_TEMP]
( 
  [MatriculaIndicador],   
  [CodigoProduto] ,	  
  CodigoEN,
  CodigoPV
)	

 CREATE NONCLUSTERED INDEX idx_PremiacaoAnalitico_Apolice_INDICADORES_TEMP ON [dbo].[PremiacaoAnalitico_INDICADORES_TEMP]
( 
  [NumeroApolice],
  [NumeroEndosso],
  [CodigoSubGrupo]
)
 INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroTitulo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

 CREATE NONCLUSTERED INDEX idx_PremiacaoAnalitico_Titulo_INDICADORES_TEMP ON [dbo].[PremiacaoAnalitico_INDICADORES_TEMP]
( 
  [NumeroTitulo]
)
 INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroApolice], [CodigoSubGrupo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

  
CREATE NONCLUSTERED INDEX idx_PremiacaoAnalitico_CodigoEN_INDICADORES_TEMP
ON [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] ([CodigoEN])		  


CREATE NONCLUSTERED INDEX idx_PremiacaoAnalitico_All_INDICADORES_TEMP
ON [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] ([IDSeguradora],[CodigoProduto])
INCLUDE ([Codigo],[NomeArquivo],[DataArquivo],[CodigoEN],[CodigoPV],[MatriculaIndicador],[TipoPagamento],[ValorCalculado],[NumeroApolice],[NumeroEndosso],[NumeroParcela],[NumeroTitulo],[CodigoSubGrupo],[Ocorrencia],[NomeSegurado])   
    
	

               --select @PontoDeParada = 20007037
   


BEGIN
  
--select @PontoDeParada = 20007037
 
    
SET @COMANDO = Cast(@PontoDeParada  as varchar(10)) + ';' + @TipoAcordo


SET @COMANDO = 'INSERT INTO [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] (
	                      	[Codigo],
							[ControleVersao] ,
							[NomeArquivo],
							[DataArquivo] ,
							[TipoDado],
							[CodigoEN] ,
							[CodigoPV] ,
							[MatriculaIndicador] ,
							[CodigoProduto] ,
							[ValorBruto] ,
							[TipoPagamento] ,
							[NumeroApolice] ,
							[NumeroEndosso] ,
							[NumeroParcela] ,
							[NumeroTitulo] ,
							[CodigoSubGrupo] ,
							[Ocorrencia] ,
							[NomeSegurado], 
							TipoAcordo,
							DataEmissao)  
                SELECT  
                      	[Codigo],
							[ControleVersao] ,
							[NomeArquivo],
							[DataArquivo] ,
							[TipoDado],
							[CodigoEN] ,
							[CodigoPV] ,
							[MatriculaIndicador] ,
							[CodigoProduto] ,
							[ValorBruto] ,
							[TipoPagamento] ,
							[NumeroApolice] ,
							[NumeroEndosso] ,
							[NumeroParcela] ,
							[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroTitulo]) [NumeroTitulo],
							[CodigoSubGrupo] ,
							[Ocorrencia] ,
							[NomeSegurado],
							TipoAcordo,
							DataEmissao
                FROM OPENQUERY ([OBERON], 
                ''SET NOCOUNT ON;
                  set fmtonly off; EXEC [Fenae].[Corporativo].[proc_RecuperaPremiacaoAnalitico_INDICADORES_SIGDC] ''''' + Cast(@COMANDO  as varchar(14)) + ''''''') PRM'
               
EXEC (@COMANDO)     

    /***********************************************************************
       Carregar as agencias desconhecidas - EN (Escritório de Negócio)
	***********************************************************************/
	;INSERT INTO Dados.Unidade(Codigo)

	SELECT DISTINCT PRM.CodigoEN
	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	WHERE  PRM.CodigoEN IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = PRM.CodigoEN)                                                                        

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)	  
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'INDICADORES_ANALITICO' [TipoDado], 
					MAX(PRM.DataArquivo) [DataArquivo], 
					'FUNDAO' [Arquivo]

	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	INNER JOIN Dados.Unidade U
	ON PRM.CodigoEN = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID         


    /***********************************************************************
       Carregar as agencias desconhecidas - PV (Agências/Posto de venda)
	***********************************************************************/
	;INSERT INTO Dados.Unidade(Codigo)	 
	SELECT DISTINCT PRM.CodigoPV
	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	WHERE  PRM.CodigoPV IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = PRM.CodigoPV)     
					                                                                

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'INDICADORES_ANALITICO' [TipoDado], 
					MAX(PRM.DataArquivo) [DataArquivo], 
					'FUNDAO' [Arquivo]

	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	INNER JOIN Dados.Unidade U
	ON PRM.CodigoPV = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 

    --InserirFuncionario (INDICADOR)

	/***********************************************************************
	Carregar os FUNCIONARIOS de proposta não carregados do SRH
	***********************************************************************/

	;MERGE INTO Dados.Funcionario AS T
		USING (           
			SELECT DISTINCT PRM.[MatriculaIndicador] [Matricula], 1 [IDEmpresa], PRM.TipoDado, PRM.DataArquivo -- Caixa Econômica                
			FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
			WHERE PRM.[MatriculaIndicador] IS NOT NULL
			) X
	ON T.[Matricula] = X.[Matricula] 
	AND T.IDEmpresa = X.IDEmpresa
	WHEN NOT MATCHED
				THEN INSERT ([Matricula], IDEmpresa,  NomeArquivo, DataArquivo)
					VALUES (X.[Matricula], X.IDEmpresa, X.TipoDado, X.DataArquivo);  


	 ;MERGE INTO Dados.ProdutoPremiacao T
	  USING 
	  (
	  		SELECT PRM.CodigoProduto, PRM.[IDSeguradora], MIN(PRM.DataArquivo) DataInicioComercializacao
			FROM [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] PRM
			GROUP BY PRM.CodigoProduto, PRM.[IDSeguradora]
	  ) X
	  ON  T.CodigoComercializado = X.CodigoProduto
	  AND T.IDSeguradora = X.IDSeguradora
	  --WHEN MATCHED AND T.IDSeguradora IS NULL
	  --  THEN UPDATE SET IDSeguradora = X.IDSeguradora
	  WHEN NOT MATCHED
	    THEN INSERT (CodigoComercializado, IDSeguradora, DataInicioComercializacao) 
		VALUES (CodigoProduto, IDSeguradora, DataInicioComercializacao) ;

	  


	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM	   
	;MERGE INTO [Dados].[PremiacaoIndicadores] T
	USING (
	------INICIO TRATA 1 - 29/01/2015---
	SELECT A.NumeroApolice, A.NumeroTitulo, A.NomeSegurado, A.[IDProdutoPremiacao], A.[IDFuncionario], A.[IDUnidade], CodigoSubGrupo
		      , A.IDEscritorioNegocio, A.NumeroEndosso, A.NumeroParcela, A.TipoPagamento, SUM(A.[ValorCalculado]) [ValorCalculado], A.[NumeroOcorrencia], A.DataArquivo, A.[NomeArquivo], Gerente, DataEmissao
			  FROM
			  (
     ------FIM TRATA 1 - 29/01/2015---
	    SELECT *
		FROM
		(
		SELECT PRM.NumeroApolice, PRM.NumeroTitulo, PRM.NomeSegurado, PRD.ID [IDProdutoPremiacao], F.ID [IDFuncionario], UA.[IDUnidade], CodigoSubGrupo
		     , COALESCE(UE.ID, UA.[IDUnidadeEscritorioNegocio]) [IDEscritorioNegocio], PRM.NumeroEndosso, PRM.NumeroParcela, PRM.TipoPagamento, PRM.[ValorCalculado], PRM.Ocorrencia [NumeroOcorrencia], PRM.DataArquivo, PRM.[NomeArquivo], PRM.Gerente, PRM.DataEmissao
			  , ROW_NUMBER() OVER(PARTITION BY PRM.NumeroApolice, PRM.NumeroTitulo, PRD.ID, PRM.NumeroEndosso, PRM.NumeroParcela, PRM.Ocorrencia ORDER BY PRM.DataArquivo DESC, PRM.Codigo DESC) ORDEM	                                        
		--SELECT *
		FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
		INNER JOIN Dados.ProdutoPremiacao PRD
		ON PRM.CodigoProduto = CodigoComercializado 
		AND PRM.IDSeguradora = PRD.IDSeguradora
		INNER JOIN Dados.vw_Unidade UA
		ON PRM.CodigoPV = UA.Codigo
		INNER JOIN Dados.Funcionario F
		ON F.Matricula = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		LEFT JOIN Dados.Unidade UE
		ON PRM.CodigoEN= UE.Codigo
		) A
		------INICIO TRATA 1 - 29/01/2015---
		) A
		GROUP BY A.NumeroApolice, A.NumeroTitulo, A.NomeSegurado, A.[IDProdutoPremiacao], A.[IDFuncionario], A.[IDUnidade], CodigoSubGrupo
		      , A.IDEscritorioNegocio, A.NumeroEndosso, A.NumeroParcela, A.TipoPagamento, A.[NumeroOcorrencia], A.DataArquivo, A.[NomeArquivo], A.Gerente, A.DataEmissao
	    ------FIM TRATA 1 - 29/01/2015---
	) X
	ON 	ISNULL(X.[NumeroApolice], '#') = ISNULL(T.[NumeroApolice], '#')
	AND ISNULL(X.[NumeroTitulo],'') = ISNULL(T.[NumeroTitulo],'')
	AND X.[IDProdutoPremiacao] = T.[IDProdutoPremiacao]
	AND X.[NumeroEndosso] = T.[NumeroEndosso]
	AND ISNULL(X.[NumeroParcela],-1) = ISNULL(T.[NumeroParcela],-1)
	AND X.[NumeroOcorrencia] = T.[NumeroOcorrencia]
	AND X.[IDFuncionario] = T.[IDFuncionario]
	AND X.[TipoPagamento] = T.[TipoPagamento]
	--
	AND X.NomeArquivo = T.NomeArquivo--Adicionado em 29/01/2015 para suportar o pagamento de ajuste (set/2014 - dez/2014) - mudança de acordo operacional
	AND X.Gerente = T.Gerente
	WHEN NOT MATCHED
	THEN INSERT ([NumeroApolice], [NumeroTitulo], [NumeroEndosso], [NomeSegurado], [NumeroParcela], [IDFuncionario], NumeroOcorrencia, CodigoSubGrupo
				 ,TipoPagamento, [IDProdutoPremiacao], [IDEscritorioNegocio], [IDUnidade], [ValorBruto], NomeArquivo, DataArquivo, Gerente, DataEmissao)
	VALUES (X.[NumeroApolice], X.[NumeroTitulo], X.[NumeroEndosso], X.NomeSegurado, X.[NumeroParcela], X.[IDFuncionario], X.NumeroOcorrencia, X.CodigoSubGrupo
		   ,X.TipoPagamento, X.[IDProdutoPremiacao], X.[IDEscritorioNegocio], X.[IDUnidade], X.[ValorCalculado], X.NomeArquivo, X.DataArquivo, X.Gerente, X.DataEmissao)
	--REMOVER INICIO
   --REMOVER FIM
    OPTION (MAXDOP 7);			   

 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] 
    
                    
  /*********************************************************************************************************************/
   print '1'
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoAnalitico_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoAnalitico_INDICADORES_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

--EXEC [Dados].[proc_InserePremiacaoAnalitico_INDICADORES] 1

