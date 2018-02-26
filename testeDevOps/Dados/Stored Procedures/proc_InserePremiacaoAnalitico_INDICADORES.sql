/*
	Autor: Egler Vieira
	Data Criação: 11/11/2013

	Descrição: 
	
	Última alteração : Egler Vieira -> 31/03/2015 - Inclusão da coluna para identificação de premiação Gerente Geral
	                   Egler Vieira -> 2015-08-11 - Transferência do controle de ponto de parada para a proc CORPORATIVO.Dados.proc_InserePremiacao e inclusão da validação do tipo de acordo.
	                   

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
CREATE PROCEDURE [Dados].[proc_InserePremiacaoAnalitico_INDICADORES] (@PontoDeParada AS DATE, @TipoAcordo VARCHAR(2) = 'I') as
BEGIN TRY		
--select @@trancount
 
-- DECLARE @TipoAcordo VARCHAR(2) = 'SR'
--DECLARE @PontoDeParada AS DATE	   = '2015-08-24' 


DECLARE @COMANDO AS NVARCHAR(max) 
DECLARE @NomeEntidade VARCHAR(40)   
    

--IF (@TipoAcordo = 'GI')   
--BEGIN
--  SET @NomeEntidade = 'PremiacaoAnalitico_GERENTE_INDICADORES_Odonto' 

--END
--ELSE 
--  IF (@TipoAcordo = 'I') 
--  BEGIN
--    SET @NomeEntidade ='Premiacao_INDICADORES_Odonto'
--  END
--  ELSE
--    IF (@TipoAcordo = 'SR') 
--	BEGIN
--	 SET @NomeEntidade ='PremiacaoAnalitic_SUPERINTENDENTE_INDICADORES'
--	END
--	ELSE
--	  THROW 60000, N'Daily - Indicadores - Carga Corporativo. Tipo de premiação não permitida', 1;

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
					  		 WHEN 'CAPPM60'	THEN 3
							 WHEN 'BILHAP'	THEN 1
							 WHEN 'COPACAP'	THEN 5
							 WHEN 'VIDAAZUL' THEN 1
							 WHEN 'FENAE_ODONTO_GG' THEN 286
							 WHEN 'FENAE_ODONTO' THEN 286
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
								   WHEN Cast(CodigoProduto as int) =-1 THEN 1 
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
	[NumeroEndosso] [int] NOT NULL,
	[NumeroParcela] [int] NULL,
	[NumeroTitulo] [varchar](20) NULL,
	--NumeroProposta AS (dbo.fn_TrataNumeroPropostaZeroExtra([NumeroTitulo]))PERSISTED,
	[CodigoSubGrupo] [varchar](20) NOT NULL,
	[Ocorrencia] [int] NOT NULL,
	[NomeSegurado] [varchar](200) NULL,
	TipoAcordo VARCHAR(2),
	Gerente AS (Cast( CASE WHEN TipoAcordo = 'I' THEN 0 ELSE 1 END as bit)) PERSISTED,
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
							TipoAcordo)  
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
							TipoAcordo
                FROM OPENQUERY ([OBERON], 
                ''SET NOCOUNT ON;
                  set fmtonly off; EXEC [Fenae].[Corporativo].[proc_RecuperaPremiacaoAnalitico_INDICADORES] ''''' + Cast(@COMANDO  as varchar(14)) + ''''''') PRM'
               
EXEC (@COMANDO)     

				--SET FMTONLY OFF;

--SELECT *
--FROM [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] PRM
--        --   print @MaiorCodigo       
--/*********************************************************************************************************************/



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

	  

	-----------------------------------------------------------------------------------------------------------------------
	--Comando para inserir EVENTUAIS Produtos que não existirem na tabela de Produto e SeguradoraProduto e estiverem em registros da emissão
	-----------------------------------------------------------------------------------------------------------------------
	  ------DECLARE @ProdutosInseridos table(IDProduto int);
 
	  ------INSERT INTO Dados.Produto (CodigoComercializado, IDSeguradora, DataInicioComercializacao) 
	  ------OUTPUT INSERTED.ID INTO @ProdutosInseridos
	  ------SELECT DISTINCT PRM.CodigoProduto, PRM.[IDSeguradora], MIN(PRM.DataArquivo)
	  ------FROM [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	  ------WHERE 
		 ------ not exists (
			------			SELECT     *
			------			FROM         Dados.Produto TE
			------			WHERE TE.CodigoComercializado = PRM.CodigoProduto
			------		  )
	  ------GROUP BY PRM.CodigoProduto, PRM.[IDSeguradora]

	  -- AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DO PRODUTO E SE HÁ CORRELAÇÃO COM O CÓDIGO SIAS

	  --------INSERT INTO Dados.ProdutoHistorico (IDProduto, Descricao, DataInicio, DataInicioComercializacao) 
	  --------SELECT DISTINCT PRD.ID, PRD.Descricao, MIN(PRM.DataArquivo), MIN(PRM.DataArquivo)
	  --------FROM [dbo].[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	  --------INNER JOIN Dados.Produto PRD
	  --------ON PRD.CodigoComercializado = PRM.CodigoProduto
	  --------WHERE 
		 -------- not exists (
			--------		  SELECT     *
			--------		  FROM         Dados.ProdutoHistorico PH
			--------		  WHERE PH.IDProduto = PRD.ID)
	  --------GROUP BY PRD.ID, PRD.Descricao
	-----------------------------------------------------------------------------------------------------------------------
	  --select *
	  --from dados.Proposta 
	  --where idproduto = 81 or idprodutosigpf = 15


	-------------------------------------------------------------------------------------------------------------------------------
	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM
	
	----------Comando para inserir PROPOSTAS que não existirem na tabela de Proposta e estiverem em registros de pagamento de premiação para indicadores
	-------------------------------------------------------------------------------------------------------------------------------
	--------INSERT INTO Dados.Proposta (NumeroProposta, IDSeguradora, IDFuncionario, IDProduto, IDProdutoSIGPF, IDAgenciaVenda, TipoDado, DataArquivo)
	--------SELECT PRM.NumeroTitulo [NumeroProposta],  PRM.[IDSeguradora], F.ID [IDFuncionario], PRD.ID [IDProduto], PRD.IDProdutoSIGPF, U.[ID] [IDUnidade], TipoDado, MAX(PRM.DataArquivo) DataArquivo
	--------FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	--------INNER JOIN Dados.Produto PRD
	--------ON PRM.CodigoProduto = CodigoComercializado
	--------INNER JOIN Dados.Unidade U
	--------ON PRM.CodigoPV = U.Codigo
	--------INNER JOIN Dados.Funcionario F
	--------ON F.Matricula = PRM.[MatriculaIndicador]
	--------AND F.IDEmpresa = 1
	--------WHERE NOT EXISTS (SELECT * FROM Dados.Proposta PRP
	--------					WHERE PRP.NumeroProposta = PRM.NumeroTitulo
	--------					AND PRP.IDSeguradora = PRM.IDSeguradora)
	--------					--and Numerotitulo = '304476'
	--------GROUP BY  PRM.NumeroTitulo, PRM.[IDSeguradora], F.ID, PRD.ID, PRD.IDProdutoSIGPF, U.[ID], TipoDado
		
		
			
	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM
	--------;MERGE INTO Dados.PropostaCliente T
	--------USING
	--------(
	--------	SELECT DISTINCT PRP.ID [IDProposta], PRM.NomeSegurado, MAX(PRM.TipoDado) TipoDado, MAX(PRM.DataArquivo) DataArquivo--, PC.Nome                                        
	--------	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	--------		INNER JOIN Dados.Proposta PRP
	--------		ON      PRP.NumeroProposta = PRM.NumeroTitulo
	--------			AND PRP.IDSeguradora = PRM.IDSeguradora	 
	----------		INNER JOIN Dados.PropostaCliente PC
	----------		ON PC.IDProposta = PRP.ID
	----------	WHERE NOT EXISTS (SELECT *
	----------					  FROM Dados.PropostaCliente PC
	----------					  WHERE PC.IDProposta = PRP.ID)
	--------	GROUP BY PRP.ID, PRM.NomeSegurado
	--------) X
	--------ON X.IDProposta = T.IDProposta
	--------WHEN NOT MATCHED THEN
	--------   INSERT (IDProposta, Nome, DataArquivo, TipoDado) VALUES (X.IDProposta, X.NomeSegurado, X.DataArquivo, X.TipoDado)
	--------WHEN MATCHED THEN
	--------   UPDATE SET Nome = NomeSegurado; 
	-----------------------------------------------------------------------------------------------------------------------

		
	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM
 ------------   ---------------------------------------------------------------------------------------------------------------------
 ------------   InserirContrato
	---------------------------------------------------------------------------------------------------------------------------------
 ------------   INSERT INTO Dados.Contrato (NumeroContrato, IDSeguradora, Arquivo, DataArquivo)
 ------------    SELECT NumeroApolice, [IDSeguradora], NomeArquivo, DataArquivo
 ------------   FROM            
 ------------   (     
 ------------        SELECT
 ------------                 PRM.NumeroApolice, PRM.[IDSeguradora], PRM.Codigo, PRM.DataArquivo, PRM.[NomeArquivo], ROW_NUMBER() OVER(PARTITION BY PRM.NumeroApolice, PRM.[IDSeguradora] ORDER BY PRM.DataArquivo DESC, PRM.Codigo DESC) ORDEM	                                        
 ------------        FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
 ------------        LEFT JOIN Dados.Proposta PRP
 ------------         ON  PRP.NumeroProposta = PRM.NumeroTitulo
 ------------         AND PRP.IDSeguradora = PRM.IDSeguradora
	------------	 WHERE NOT EXISTS (SELECT *
	------------	                   FROM Dados.Contrato CNT
	------------					   WHERE CNT.NumeroContrato = PRM.NumeroApolice
	------------					       AND CNT.IDSeguradora = PRM.IDSeguradora)
 ------------   -----------------------------------------------------------------------------------------------------------------
 ------------   ) A
	------------WHERE A.ORDEM = 1		


   	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM  
 --------------   -----------------------------------------------------------------------------------------------------------------------
 --------------   --Comando para inserir um ENDOSSO (1º Endosso) de emissão na marra 
 --------------   --das propostas cujo Premiação foram recebidos nos arquivos que juntos se denominão FUNDÃO
 --------------   -----------------------------------------------------------------------------------------------------------------------     
 --------------   INSERT INTO Dados.Endosso (IDContrato, IDProposta, IDProduto, NumeroEndosso, CodigoSubestipulante, Arquivo, DataArquivo)    
	--------------SELECT IDContrato, [IDProposta], [IDProduto], NumeroEndosso, [CodigoSubGrupo], NomeArquivo, DataArquivo
	--------------FROM            
	--------------(     
	--------------	SELECT CNT.ID [IDContrato], PRP.ID [IDProposta], PRD.ID [IDProduto], NumeroEndosso, [CodigoSubGrupo], PRM.DataArquivo, PRM.[NomeArquivo], ROW_NUMBER() OVER(PARTITION BY PRM.NumeroApolice, PRM.[IDSeguradora], PRP.ID, PRM.NumeroEndosso ORDER BY PRM.DataArquivo DESC, PRM.Codigo DESC) ORDEM	                                        
	--------------	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	--------------	INNER JOIN Dados.Proposta PRP
	--------------	ON  PRP.NumeroProposta = PRM.NumeroTitulo
	--------------	AND PRP.IDSeguradora = PRM.IDSeguradora
	--------------	INNER JOIN Dados.Contrato CNT
	--------------	ON  CNT.NumeroContrato = PRM.NumeroApolice
	--------------	AND CNT.IDSeguradora = PRM.IDSeguradora
	--------------	INNER JOIN Dados.Produto PRD
	--------------	ON PRM.CodigoProduto = CodigoComercializado
	--------------	WHERE NOT EXISTS (SELECT *
	--------------	                  FROM Dados.Endosso EN
	--------------					  WHERE EN.IDContrato = CNT.ID
	--------------					    AND EN.NumeroEndosso = PRM.NumeroEndosso
	--------------						AND EN.IDProposta = PRP.ID)
	--------------	-------------------------------------------------------------------------------------------------------------------
	--------------) A
	--------------WHERE A.ORDEM = 1
	--AND A.IDContrato = 7439489
    -----------------------------------------------------------------------------------------------------------------------
		
		
	----------AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM	   
	--------;MERGE INTO [Dados].[PremiacaoIndicadores] T
	--------USING (
	--------    SELECT *
	--------	FROM
	--------	(
	--------	SELECT CNT.ID [IDContrato], PRP.ID [IDProposta], PRD.ID [IDProduto], F.ID [IDFuncionario], UA.ID [IDUnidade]
	--------	      , UE.ID [IDEscritorioNegocio], PRM.NumeroEndosso, PRM.NumeroParcela, PRM.TipoPagamento, PRM.[ValorCalculado], PRM.Ocorrencia [NumeroOcorrencia], PRM.DataArquivo, PRM.[NomeArquivo]
	--------		  , ROW_NUMBER() OVER(PARTITION BY CNT.ID, PRP.ID, PRD.ID, PRM.NumeroEndosso, PRM.NumeroParcela, PRM.Ocorrencia ORDER BY PRM.DataArquivo DESC, PRM.Codigo DESC) ORDEM	                                        
	--------	FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
	--------	INNER JOIN Dados.Proposta PRP
	--------	ON  PRP.NumeroProposta = PRM.NumeroTitulo
	--------	AND PRP.IDSeguradora = PRM.IDSeguradora
	--------	INNER JOIN Dados.Contrato CNT
	--------	ON  CNT.NumeroContrato = PRM.NumeroApolice
	--------	AND CNT.IDSeguradora = PRM.IDSeguradora
	--------	INNER JOIN Dados.Produto PRD
	--------	ON PRM.CodigoProduto = CodigoComercializado 
	--------	INNER JOIN Dados.Unidade UA
	--------	ON PRM.CodigoPV = UA.Codigo
	--------	INNER JOIN Dados.Unidade UE
	--------	ON PRM.CodigoEN= UE.Codigo
	--------	INNER JOIN Dados.Funcionario F
	--------	ON F.Matricula = PRM.[MatriculaIndicador]
	--------	AND F.IDEmpresa = 1
	--------	) A
	--------	WHERE A.ORDEM = 1
	--------) X
	--------ON 	X.[IDContrato] = T.IDContrato
	--------AND X.[IDProposta] = T.IDProposta
	--------AND X.[NumeroEndosso] = T.NumeroEndosso
	--------AND ISNULL(X.[NumeroParcela],-1) = ISNULL(T.NumeroParcela,-1)
	--------AND X.[IDFuncionario] = T.IDFuncionario
	--------AND X.TipoPagamento = T.TipoPagamento
	--------AND X.NumeroOcorrencia = T.NumeroOcorrencia
	--------WHEN NOT MATCHED
	--------THEN INSERT ([IDContrato], [IDProposta], [NumeroEndosso], [NumeroParcela], [IDFuncionario], NumeroOcorrencia
	--------			 ,TipoPagamento, [IDProduto], [IDEscritorioNegocio], [IDUnidade], [ValorBruto], NomeArquivo, DataArquivo)
	--------VALUES (X.[IDContrato], X.[IDProposta], X.[NumeroEndosso], X.[NumeroParcela], X.[IDFuncionario], X.NumeroOcorrencia
	--------	   ,X.TipoPagamento, X.[IDProduto], X.[IDEscritorioNegocio], X.[IDUnidade], X.[ValorCalculado], X.NomeArquivo, X.DataArquivo);

	--SELECT * FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP]

	--AGUARDANDO IDENTIFICAÇÃO DO NÚMERO DA PROPOSTA CORRETO NO ARQUIVO DE ORIGEM	   
	;MERGE INTO [Dados].[PremiacaoIndicadores] T
	USING (
	------INICIO TRATA 1 - 29/01/2015---
	SELECT A.NumeroApolice, A.NumeroTitulo, A.NomeSegurado, A.[IDProdutoPremiacao], A.[IDFuncionario], A.[IDUnidade], CodigoSubGrupo
		      , A.IDEscritorioNegocio, A.NumeroEndosso, A.NumeroParcela, A.TipoPagamento, SUM(A.[ValorCalculado]) [ValorCalculado], A.[NumeroOcorrencia], A.DataArquivo, A.[NomeArquivo], Gerente
			  FROM
			  (
     ------FIM TRATA 1 - 29/01/2015---
	    SELECT *
		FROM
		(
		SELECT PRM.NumeroApolice, PRM.NumeroTitulo, PRM.NomeSegurado, PRD.ID [IDProdutoPremiacao], F.ID [IDFuncionario], UA.[IDUnidade], CodigoSubGrupo
		     , COALESCE(UE.ID, UA.[IDUnidadeEscritorioNegocio]) [IDEscritorioNegocio], PRM.NumeroEndosso, PRM.NumeroParcela, PRM.TipoPagamento, PRM.[ValorCalculado], PRM.Ocorrencia [NumeroOcorrencia], PRM.DataArquivo, PRM.[NomeArquivo], PRM.Gerente
			  , ROW_NUMBER() OVER(PARTITION BY PRM.NumeroApolice, PRM.NumeroTitulo, PRD.ID, PRM.NumeroEndosso, PRM.NumeroParcela, PRM.Ocorrencia ORDER BY PRM.DataArquivo DESC, PRM.Codigo DESC) ORDEM	                                        
		--SELECT *
		FROM dbo.[PremiacaoAnalitico_INDICADORES_TEMP] PRM
		--INNER JOIN Dados.Proposta PRP
		--ON  PRP.NumeroProposta = PRM.NumeroTitulo
		--AND PRP.IDSeguradora = PRM.IDSeguradora
		--INNER JOIN Dados.Contrato CNT
		--ON  CNT.NumeroContrato = PRM.NumeroApolice
		--AND CNT.IDSeguradora = PRM.IDSeguradora
		INNER JOIN Dados.ProdutoPremiacao PRD
		ON PRM.CodigoProduto = CodigoComercializado 
		AND PRM.IDSeguradora = PRD.IDSeguradora
		LEFT OUTER JOIN Dados.vw_Unidade UA
		ON PRM.CodigoPV = UA.Codigo
		INNER JOIN Dados.Funcionario F
		ON F.Matricula = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		LEFT JOIN Dados.Unidade UE
		ON PRM.CodigoEN= UE.Codigo
		--and PRM.NumeroApolice LIKE '%109300002142%'
		--and prm.numerotitulo = '000000013074153'
		) A
		--WHERE A.ORDEM = 1
		------INICIO TRATA 1 - 29/01/2015---
		) A
		GROUP BY A.NumeroApolice, A.NumeroTitulo, A.NomeSegurado, A.[IDProdutoPremiacao], A.[IDFuncionario], A.[IDUnidade], CodigoSubGrupo
		      , A.IDEscritorioNegocio, A.NumeroEndosso, A.NumeroParcela, A.TipoPagamento, A.[NumeroOcorrencia], A.DataArquivo, A.[NomeArquivo], A.Gerente
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
				 ,TipoPagamento, [IDProdutoPremiacao], [IDEscritorioNegocio], [IDUnidade], [ValorBruto], NomeArquivo, DataArquivo, Gerente)
	VALUES (X.[NumeroApolice], X.[NumeroTitulo], X.[NumeroEndosso], X.NomeSegurado, X.[NumeroParcela], X.[IDFuncionario], X.NumeroOcorrencia, X.CodigoSubGrupo
		   ,X.TipoPagamento, X.[IDProdutoPremiacao], X.[IDEscritorioNegocio], X.[IDUnidade], X.[ValorCalculado], X.NomeArquivo, X.DataArquivo, X.Gerente)
	--REMOVER INICIO
	--##WHEN MATCHED Removido para evitar sobreposição de valores (Egler Vieira: 2015-04-16)
	--##THEN UPDATE SET [ValorBruto] = [ValorBruto] + X.[ValorCalculado]
   --REMOVER FIM
    OPTION (MAXDOP 7);			   

		   --SELECT *
		   --FROM [Dados].[PremiacaoIndicadores]  
		   --WHERE NumeroApolice = '109300002142'
		   --and DataArquivo > '20140101'
		   --and (NumeroTitulo is null	  OR NumeroTitulo = '' )

		   --SELECT *
		   --FROM [Dados].[PremiacaoIndicadores] 
		   --WHERE NumeroTitulo IS NULL
  --TODO - InserirContratoCliente (OU NÃO)

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

