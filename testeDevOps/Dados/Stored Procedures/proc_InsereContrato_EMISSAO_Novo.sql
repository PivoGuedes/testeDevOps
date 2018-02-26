
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
	Autor: Egler Vieira
	Data Criação: 22/11/2012

	Descrição: 
	
	Última alteração : 28/01/2013 - Egler
	                   03/07/2013 - Egler

*/

/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereContrato_EMISSAO
	Descrição: Procedimento que realiza a inserção das EMISSÕES (EMISSAO) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'ANTARES', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereContrato_EMISSAO_Novo] 
AS	
	
BEGIN TRY 
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMISSAO_ENDOSSO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EMISSAO_ENDOSSO_TEMP];

CREATE TABLE [dbo].[EMISSAO_ENDOSSO_TEMP](
	[Codigo] [int] NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[CPFCNPJ] [varchar](18) NULL,
	[Nome] [varchar](140) NOT NULL,
	[TipoPessoa] [varchar](15) NULL,
	[IDSeguradora] [int] NOT NULL,
	[NumeroContrato] [varchar](20) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[CodigoProduto] [varchar](6) NULL,
	[DataEmissao] [date] NOT NULL,
	[DataInicioVigencia] [date] NOT NULL,
	[DataFimVigencia] [date] NOT NULL,
	[Agencia] [varchar](20) NULL,
	[NumeroContratoAnterior] [varchar](20) NULL,
	[ValorPremioTotal] [numeric](15, 2) NOT NULL,
	[ValorPremioLiquido] [numeric](15, 2) NOT NULL,
	[QuantidadeParcelas] [smallint] NOT NULL,
	[NumeroEndosso] [bigint] NOT NULL,
	[TipoEndosso] [tinyint] NOT NULL,
	[DescricaoTipoEndosso] [varchar](39) NULL,
	[SituacaoEndosso] [tinyint] NOT NULL,
	[DescricaoSituacaoEndosso] [varchar](9) NULL,
	[Indicador] [varchar](20) NULL,
	[IndicadorGerente] [varchar](20) NULL,
	[IndicadorSuperintendenteRegional] [varchar](20) NULL,
	[CodigoMoedaSegurada] [varchar](30) NULL,
	[CodigoMoedaPremio] [varchar](30) NULL,
	[CodigoSubestipulante] [varchar](30) NULL,
	[CodigoFonteProdutora] [varchar](30) NULL,
	[NumeroPropostaSASSE] [varchar](20) NULL,
	[NumeroBilhete] [varchar](20) NULL,
	[NumeroSICOB] [varchar](20) NULL,
	[CodigoCliente] [varchar](20) NULL,
	[LayoutRisco] [varchar](50) NULL,
	[CodigoRamo] [varchar](20) NULL,
	[Endereco] [varchar](8000) NULL,
	[Bairro] [varchar](8000) NULL,
	[Cidade] [varchar](8000) NULL,
	[UF] [varchar](8000) NULL,
	[CEP] [varchar](8000) NULL,
	[DDD] [varchar](8000) NULL,
	[Telefone] [varchar](8000) NULL,
	--SinalLancamento [SMALLINT] NULL,
	NomeTomador VARCHAR(200),
	EnderecoLocalRisco VARCHAR(200),
	BairroLocalRisco VARCHAR(200),
	CidadeLocalRisco VARCHAR(200),
	UFLocalRisco VARCHAR(200),
	NomeEmpreendimento VARCHAR(200),
	CodigoCorretor1 VARCHAR(200),
	CNPJCorretor1 VARCHAR(200),
	RazaoSocialCorretor1 VARCHAR(200),
	CodigoCorretor2 VARCHAR(200),
	CnpjCorretor2 VARCHAR(200),
	RazaoSocialCorretor2 VARCHAR(200),
	[RankEndosso] [bigint] NULL,
	[RankContrato] [bigint] NULL,

) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_EMISSAO_ENDOSSO_TEMP ON [dbo].[EMISSAO_ENDOSSO_TEMP]
( 
  [NumeroContrato] ASC,
  [NumeroEndosso] ASC
)         

CREATE NONCLUSTERED INDEX idx_EMISSAO_ENDOSSO_NumeroContratoAnterior_TEMP
ON [dbo].[EMISSAO_ENDOSSO_TEMP] ([NumeroContratoAnterior])
INCLUDE ([NomeArquivo],[DataArquivo],[IDSeguradora])

CREATE NONCLUSTERED INDEX idx_EMISSAO_ENDOSSO_Indicador_TEMP
ON [dbo].[EMISSAO_ENDOSSO_TEMP] ([Indicador])


CREATE NONCLUSTERED INDEX idx_EMISSAO_ENDOSSO_IndicadorGerente_TEMP
ON [dbo].[EMISSAO_ENDOSSO_TEMP] ([IndicadorGerente])

CREATE NONCLUSTERED INDEX idx_EMISSAO_ENDOSSO_IndicadorSuperintendenteRegional_TEMP
ON [dbo].[EMISSAO_ENDOSSO_TEMP] ([IndicadorSuperintendenteRegional])

CREATE NONCLUSTERED INDEX idx_EMISSAO_ENDOSSO_RankEndosso_TEMP
ON [dbo].[EMISSAO_ENDOSSO_TEMP] ([RankEndosso])
INCLUDE ([NomeArquivo],[DataArquivo],[IDSeguradora],[NumeroContrato],[CodigoProduto],[DataEmissao],[DataInicioVigencia],[DataFimVigencia],[ValorPremioTotal],[ValorPremioLiquido],[QuantidadeParcelas],[NumeroEndosso],[TipoEndosso],[SituacaoEndosso],[CodigoSubestipulante]/*,[SinalLancamento]*/)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'EMISSAO'
               --select @PontoDeParada = 14771048

SET @PontoDeParada = 14777048

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[EMISSAO_ENDOSSO_TEMP]
                SELECT *
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaEmissaoEEndosso] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO) 

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[EMISSAO_ENDOSSO_TEMP] PRP
                  
/*********************************************************************************************************************/


WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo

----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Agências que não existirem na tabela de Unidades e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------
                      
    
  INSERT INTO Dados.Unidade(Codigo)
  SELECT EM.Agencia
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  WHERE 
      not exists (
    SELECT     *
    FROM         Dados.Unidade U
    WHERE U.Codigo = EM.Agencia)
  GROUP BY EM.Agencia   

  
  INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
  SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], MAX(EM.Codigo) [CodigoNaFonte], 'EMISSAO' [TipoDado], MAX(EM.DataArquivo) [DataArquivo], MAX(NomeArquivo) [Arquivo]
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  INNER JOIN Dados.Unidade U
  ON EM.Agencia = U.Codigo
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.UnidadeHistorico UH
                  WHERE UH.IDUnidade = U.ID)
  GROUP BY U.ID 
   
-----------------------------------------------------------------------------------------------------------------------     

-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Produtos que não existirem na tabela de Produto e SeguradoraProduto e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------
      
  DECLARE @ProdutosInseridos table(IDProduto int);
    
  INSERT INTO Dados.Produto (CodigoComercializado, IDSeguradora, DataInicioComercializacao) 
  OUTPUT INSERTED.ID INTO @ProdutosInseridos
  SELECT DISTINCT EM.CodigoProduto, 1 [IDSeguradora], MIN(EM.DataArquivo)
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  WHERE 
      not exists (
    SELECT     *
    FROM         Dados.Produto TE
    WHERE TE.CodigoComercializado = EM.CodigoProduto)
  GROUP BY EM.CodigoProduto


  INSERT INTO Dados.ProdutoHistorico (IDProduto, Descricao, DataInicio, DataInicioComercializacao) 
  SELECT DISTINCT PRD.ID, PRD.Descricao, MIN(EM.DataArquivo), MIN(EM.DataArquivo)
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  INNER JOIN Dados.Produto PRD
  ON PRD.CodigoComercializado = EM.CodigoProduto
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.ProdutoHistorico PH
                  WHERE PH.IDProduto = PRD.ID)
  GROUP BY PRD.ID, PRD.Descricao
  
-----------------------------------------------------------------------------------------------------------------------     


-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Situações de Endosso que não existirem na tabela de SituacaoEndosso e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------

  INSERT INTO Dados.SituacaoEndosso (Codigo)
  SELECT DISTINCT EM.SituacaoEndosso 
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  WHERE 
      not exists (
    SELECT     *
    FROM         Dados.SituacaoEndosso TE
    WHERE TE.Codigo = EM.SituacaoEndosso)                      

----------------------------------------------------------------------------------------------------------------------- 
  

               
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS ramos que não existirem na tabela de ramo e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------
  
  INSERT INTO Dados.Ramo (Codigo)
  SELECT DISTINCT CodigoRamo
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
  WHERE  not exists (
  SELECT     ID, Codigo, Nome, TipoRamo
  FROM         Dados.Ramo r
  WHERE r.Codigo = EM.CodigoRamo)
  
-----------------------------------------------------------------------------------------------------------------------          


  
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Tipos de Endosso que não existirem na tabela de TipoEndosso e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------

  INSERT INTO Dados.TipoEndosso (Codigo)
	 SELECT DISTINCT EM.TipoEndosso 
     FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
	 WHERE
      not exists (
    SELECT     *
    FROM         Dados.TipoEndosso TE
    WHERE TE.Codigo = EM.TipoEndosso)    
-----------------------------------------------------------------------------------------------------------------------          

 
     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
    
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT EM.[NumeroContrato], EM.[NumeroProposta], EM.[IDSeguradora], MAX(EM.[NomeArquivo]) [NomeArquivo], MAX(EM.[DataArquivo]) [DataArquivo]
            FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
            WHERE EM.NumeroProposta IS NOT NULL
            GROUP BY EM.[NumeroContrato], EM.[NumeroProposta], EM.[IDSeguradora]
              ) X
        ON T.NumeroProposta = X.NumeroProposta
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.[NomeArquivo], X.DataArquivo);		               
   
   
      /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.PropostaCliente AS T
	      USING (SELECT PRP.ID [IDProposta], CASE WHEN EM.Nome IS NULL OR EM.Nome = '' THEN 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' ELSE EM.[Nome] END [NomeCliente], 'EMISSAO' [NomeArquivo], MAX(EM.[DataArquivo]) [DataArquivo]
            FROM [EMISSAO_ENDOSSO_TEMP] EM
            INNER JOIN Dados.Proposta PRP
            ON PRP.NumeroProposta = EM.NumeroProposta
            AND PRP.IDSeguradora = 1
            WHERE EM.NumeroProposta IS NOT NULL
            GROUP BY PRP.ID, EM.[Nome] 
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, [NomeArquivo], X.[NomeCliente], X.[DataArquivo])
	   WHEN MATCHED --ADICIONADO EM 2013-12-10 para atualizar os dados dos clientes quando for bilhete
	              THEN UPDATE 
				    SET T.[Nome] = CASE WHEN T.[Nome] IS NOT NULL AND X.[NomeCliente] = 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' THEN T.Nome ELSE X.[NomeCliente] END; 
		                  
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Apólices "Anteriores - Que referenciam apólices anteriores" não recebidas nos arquivos de EMISSAO
    -----------------------------------------------------------------------------------------------------------------------
	    
      ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT 
               EM.[IDSeguradora] /*Caixa Seguros*/               
             , EM.[NumeroContratoAnterior]
             --, 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' [NomeCliente]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
        WHERE EM.NumeroContratoAnterior IS NOT NULL
        GROUP BY EM.[NumeroContratoAnterior], EM.[IDSeguradora] 
       ) X
      ON T.[NumeroContrato] = X.[NumeroContratoAnterior]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], /*[NomeCliente],*/ [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContratoAnterior], X.[IDSeguradora], /*X.[NomeCliente],*/ X.[Arquivo], X.[DataArquivo]);    
                     
    -----------------------------------------------------------------------------------------------------------------------
           

     /***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
     ***********************************************************************/
     ;MERGE INTO Dados.Funcionario AS T
	     USING (           
              SELECT DISTINCT PRP.[Indicador] [Matricula]                
              FROM dbo.[EMISSAO_ENDOSSO_TEMP] PRP 
              WHERE PRP.[Indicador] IS NOT NULL
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.IDEmpresa = 1
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], 1);          
	
	 /***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
     ***********************************************************************/
     ;MERGE INTO Dados.Funcionario AS T
	     USING (           
              SELECT DISTINCT PRP.[IndicadorGerente] [Matricula]                
              FROM dbo.[EMISSAO_ENDOSSO_TEMP] PRP 
              WHERE PRP.[IndicadorGerente] IS NOT NULL
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.IDEmpresa = 1
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], 1);          
		           
				   
	 /***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
     ***********************************************************************/
     ;MERGE INTO Dados.Funcionario AS T
	     USING (           
              SELECT DISTINCT PRP.[IndicadorSuperintendenteRegional] [Matricula]                
              FROM dbo.[EMISSAO_ENDOSSO_TEMP] PRP 
              WHERE PRP.[IndicadorSuperintendenteRegional] IS NOT NULL
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.IDEmpresa = 1
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], 1);          
		           	           
		
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Contratos recebidos no arquivo EMISSAO (EMISSÃO INICIAL - ENDOSSO ZERO)
        
    ;MERGE INTO Dados.Contrato AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], EM.[IDSeguradora] /*Caixa Seguros*/, R.ID [IDRamo]--, EM.Nome [NomeCliente], EM.[CPFCNPJ]               
             , EM.[NumeroContrato],  EM.[CodigoFonteProdutora], EM.[NumeroBilhete]
             , EM.[NumeroSICOB], CNT_ANT.[IDContratoAnterior], EM.[DataEmissao], EM.[DataInicioVigencia], EM.[DataFimVigencia]
             , EM.[ValorPremioTotal], EM.[ValorPremioLiquido], EM.[QuantidadeParcelas], UA.ID [IDAgencia] 
             , I.ID [IDIndicador], IG.ID [IDIndicadorGerente], IGSR.ID [IDIndicadorSuperintendenteRegional]
             , EM.[CodigoMoedaSegurada], EM.[CodigoMoedaPremio], EM.[LayoutRisco],  EM.[DataArquivo], EM.NomeArquivo [Arquivo]
			 , EM.NomeTomador, EM.EnderecoLocalRisco, EM.BairroLocalRisco, EM.CidadeLocalRisco, EM.UFLocalRisco, EM.NomeEmpreendimento
			 , EM.CodigoCorretor1, EM.CNPJCorretor1, EM.RazaoSocialCorretor1, EM.CodigoCorretor2, EM.CnpjCorretor2, EM.RazaoSocialCorretor2
        FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
          INNER JOIN Dados.Ramo R
          ON R.Codigo = EM.CodigoRamo
          INNER JOIN Dados.Unidade UA
          ON UA.Codigo = EM.Agencia 
          OUTER APPLY (SELECT TOP 1 ID [IDContratoAnterior] FROM Dados.Contrato CNT_ANT 
                       WHERE CNT_ANT.NumeroContrato = EM.NumeroContratoAnterior
                         AND CNT_ANT.IDSeguradora = EM.IDSeguradora) CNT_ANT/*
          LEFT JOIN Dados.Contrato CNT_ANT
          ON CNT_ANT.NumeroContrato = EM.NumeroContratoAnterior  
          AND CNT_ANT.IDSeguradora = EM.IDSeguradora */
          LEFT JOIN Dados.Proposta PRP
          ON EM.NumeroProposta = PRP.NumeroProposta          
          AND EM.IDSeguradora = PRP.IDSeguradora
	      LEFT OUTER JOIN Dados.Funcionario I
          ON I.[Matricula] = EM.[Indicador]
		  AND I.IDEmpresa = 1
		  LEFT OUTER JOIN Dados.Funcionario IG
          ON IG.[Matricula] = EM.[IndicadorGerente]
		  AND IG.IDEmpresa = 1
		  LEFT OUTER JOIN Dados.Funcionario IGSR
          ON IGSR.[Matricula] = EM.[IndicadorSuperintendenteRegional]
		  AND IGSR.IDEmpresa = 1
         WHERE [RankContrato] = 1  
         AND NumeroContrato IS NOT NULL
		 AND [NumeroEndosso] = (SELECT MAX(NumeroEndosso) FROM [EMISSAO_ENDOSSO_TEMP] EM1 WHERE EM1.NumeroContrato = EM.NumeroContrato) /* Garante os dados mais atuais na tabela endosso dentro do recordset trabalhado
		                                                                                                                                   Egler - 2013/09/19 */
          ) AS X
    ON  X.[NumeroContrato] = T.[NumeroContrato]
    AND X.[IDSeguradora] = T.[IDSeguradora]  
    WHEN MATCHED
			    THEN UPDATE
				     SET
				/*  [CPFCNPJ] = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
			   ,    [NomeCliente] = COALESCE(X.[NomeCliente],T.[NomeCliente])
				,*/[IDRamo] = COALESCE(X.[IDRamo],T.[IDRamo])
				, [CodigoFonteProdutora] = COALESCE(X.[CodigoFonteProdutora],T.[CodigoFonteProdutora])
				       
				, [NumeroBilhete] = COALESCE(X.[NumeroBilhete],T.[NumeroBilhete])
				, [NumeroSICOB] = COALESCE(X.[NumeroSICOB], T.[NumeroSICOB])
				, [IDContratoAnterior] = COALESCE(X.[IDContratoAnterior], T.[IDContratoAnterior])

				, [DataEmissao] = COALESCE(T.[DataEmissao], X.[DataEmissao])
				, [DataInicioVigencia] = COALESCE(T.[DataInicioVigencia], X.[DataInicioVigencia])
				, [DataFimVigencia] = COALESCE(T.[DataFimVigencia], X.[DataFimVigencia])
				, [ValorPremioTotal] = COALESCE(T.[ValorPremioTotal], X.[ValorPremioTotal])
				, [ValorPremioLiquido] = COALESCE(T.[ValorPremioLiquido], X.[ValorPremioLiquido])               
				, [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas])
				, [IDAgencia] = COALESCE(X.[IDAgencia], T.[IDAgencia])
				, [IDIndicador] = COALESCE(X.[IDIndicador], T.[IDIndicador])
				, [IDIndicadorGerente] = COALESCE(X.[IDIndicadorGerente], T.[IDIndicadorGerente])
				, [IDIndicadorSuperintendenteRegional] = COALESCE(X.[IDIndicadorSuperintendenteRegional], T.[IDIndicadorSuperintendenteRegional])
				, [CodigoMoedaSegurada] = COALESCE(X.[CodigoMoedaSegurada], T.[CodigoMoedaSegurada])
				, [CodigoMoedaPremio] = COALESCE(X.[CodigoMoedaPremio], T.[CodigoMoedaPremio])
				, [LayoutRisco] = COALESCE(X.[LayoutRisco], T.[LayoutRisco])
				, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
				, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
				, NomeTomador = COALESCE(X.NomeTomador, T.NomeTomador)
				, EnderecoLocalRisco = COALESCE(X.EnderecoLocalRisco, T.EnderecoLocalRisco)
				, BairroLocalRisco = COALESCE(X.BairroLocalRisco, T.BairroLocalRisco)
				, CidadeLocalRisco = COALESCE(X.CidadeLocalRisco, T.CidadeLocalRisco)
				, UFLocalRisco = COALESCE(X.UFLocalRisco, T.UFLocalRisco)
				, NomeEmpreendimento = COALESCE(X.NomeEmpreendimento, T.NomeEmpreendimento)
				, CodigoCorretor1 = COALESCE(X.CodigoCorretor1, T.CodigoCorretor1)
				, CNPJCorretor1 = COALESCE(X.CNPJCorretor1, T.CNPJCorretor1)
				, RazaoSocialCorretor1 = COALESCE(X.RazaoSocialCorretor1, T.RazaoSocialCorretor1)
				, CodigoCorretor2 = COALESCE(X.CodigoCorretor2, T.CodigoCorretor2)
				, CnpjCorretor2 = COALESCE(X.CnpjCorretor2, T.CnpjCorretor2)
				, RazaoSocialCorretor2 = COALESCE(X.RazaoSocialCorretor2, T.RazaoSocialCorretor2)
    WHEN NOT MATCHED
			    THEN INSERT          
              (  /* [CPFCNPJ]
                , [NomeCliente]
                , */[IDProposta]
                , [IDSeguradora] /*Caixa Seguros*/
                , [IDRamo]
                , [NumeroContrato]
                , [CodigoFonteProdutora]
                , [NumeroBilhete]
                , [NumeroSICOB]
                , [IDContratoAnterior]
                , [DataEmissao]
                , [DataInicioVigencia]
                , [DataFimVigencia]
                , [ValorPremioTotal]
                , [ValorPremioLiquido]
                , [QuantidadeParcelas]
                , [IDAgencia] 
                , [IDIndicador]
                , [IDIndicadorGerente]
                , [IDIndicadorSuperintendenteRegional]
                , [CodigoMoedaSegurada]
                , [CodigoMoedaPremio]
                , [LayoutRisco]
                , [DataArquivo]
                , [Arquivo]  
				, NomeTomador
				, EnderecoLocalRisco
				, BairroLocalRisco
				, CidadeLocalRisco
				, UFLocalRisco
				, NomeEmpreendimento
				, CodigoCorretor1
				, CNPJCorretor1
				, RazaoSocialCorretor1
				, CodigoCorretor2
				, CnpjCorretor2
				, RazaoSocialCorretor2
				)
          VALUES (/*X.[CPFCNPJ]
                , X.[NomeCliente]
                ,*/ X.[IDProposta]
                , X.[IDSeguradora] /*Caixa Seguros*/
                , X.[IDRamo]
                , X.[NumeroContrato]
                , X.[CodigoFonteProdutora]
                , X.[NumeroBilhete]
                , X.[NumeroSICOB]
                , X.[IDContratoAnterior]
       , X.[DataEmissao]
                , X.[DataInicioVigencia]
                , X.[DataFimVigencia]
                , X.[ValorPremioTotal]
                , X.[ValorPremioLiquido]
                , X.[QuantidadeParcelas]
                , X.[IDAgencia] 
                , X.[IDIndicador]
                , X.[IDIndicadorGerente]
                , X.[IDIndicadorSuperintendenteRegional]
                , X.[CodigoMoedaSegurada]
                , X.[CodigoMoedaPremio]
                , X.[LayoutRisco]
                , X.[DataArquivo]
                , X.[Arquivo]               
				, X.NomeTomador
				, X.EnderecoLocalRisco
				, X.BairroLocalRisco
				, X.CidadeLocalRisco
				, X.UFLocalRisco
				, X.NomeEmpreendimento
				, X.CodigoCorretor1
				, X.CNPJCorretor1
				, X.RazaoSocialCorretor1
				, X.CodigoCorretor2
				, X.CnpjCorretor2
				, X.RazaoSocialCorretor2
                 );

    -----------------------------------------------------------------------------------------------------------------------      
      					     


    

/*
---------------------------------------------------------------------------------------
Bloco removido depois de alterar o MERGE ANTERIOR PARA GARANTIR A INSERÇÃO DO CONTRATO ATRAVÉS DO MENOR NÚMERO DE ENDOSSO
---------------------------------------------------------------------------------------      
		
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Contratos recebidos no arquivo EMISSAO (EMISSÃO INICIAL - ENDOSSO ZERO)
        
    ;MERGE INTO Dados.Contrato AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], EM.[IDSeguradora] /*Caixa Seguros*/, MIN(EM.[NumeroEndosso]) [NumeroEndosso], R.ID [IDRamo]--, EM.Nome [NomeCliente], EM.[CPFCNPJ]               
             , EM.[NumeroContrato],  EM.[CodigoFonteProdutora], EM.[NumeroBilhete]
             , EM.[NumeroSICOB], CNT_ANT.[IDContratoAnterior], EM.[DataEmissao], EM.[DataInicioVigencia], EM.[DataFimVigencia]
             , EM.[ValorPremioTotal], EM.[ValorPremioLiquido], EM.[QuantidadeParcelas], UA.ID [IDAgencia] 
             , NULL [IDIndicador], NULL [IDIndicadorGerente], NULL [IDIndicadorSuperintendenteRegional]
             , EM.[CodigoMoedaSegurada], EM.[CodigoMoedaPremio], EM.[LayoutRisco],  EM.[DataArquivo], EM.NomeArquivo [Arquivo]
        FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
          INNER JOIN Dados.Ramo R
          ON R.Codigo = EM.CodigoRamo
          INNER JOIN Dados.Unidade UA
          ON UA.Codigo = EM.Agencia 
          OUTER APPLY (SELECT TOP 1 ID [IDContratoAnterior] FROM Dados.Contrato CNT_ANT 
                       WHERE CNT_ANT.NumeroContrato = EM.NumeroContratoAnterior
                         AND CNT_ANT.IDSeguradora = EM.IDSeguradora) CNT_ANT/*
          LEFT JOIN Dados.Contrato CNT_ANT
          ON CNT_ANT.NumeroContrato = EM.NumeroContratoAnterior  
          AND CNT_ANT.IDSeguradora = EM.IDSeguradora */
          LEFT JOIN Dados.Proposta PRP
          ON EM.NumeroProposta = PRP.NumeroProposta          
         AND EM.IDSeguradora = PRP.IDSeguradora
         WHERE [RankContrato] = 1  
         AND NumeroContrato IS NOT NULL
           --AND [NumeroEndosso] = 0  /*Garante a inserção da EMISSÃO INICIAL*/  --Comentado em:03/04/2013 -> Egler 
                                                                                 --O GROUP BY Foi adicionado para pegar o menor número de endosso   
           
         GROUP BY  PRP.ID , EM.[IDSeguradora] /*Caixa Seguros*/, R.ID --, EM.Nome , EM.[CPFCNPJ]               
             , EM.[NumeroContrato],  EM.[CodigoFonteProdutora], EM.[NumeroBilhete]
             , EM.[NumeroSICOB], CNT_ANT.IDContratoAnterior, EM.[DataEmissao], EM.[DataInicioVigencia], EM.[DataFimVigencia]
             , EM.[ValorPremioTotal], EM.[ValorPremioLiquido], EM.[QuantidadeParcelas], UA.ID  
     --, NULL [IDIndicador], NULL [IDIndicadorGerente], NULL [IDIndicadorSuperintendenteRegional]
             , EM.[CodigoMoedaSegurada], EM.[CodigoMoedaPremio], EM.[LayoutRisco],  EM.[DataArquivo], EM.NomeArquivo           
          ) AS X
    ON  X.[NumeroContrato] = T.[NumeroContrato]
    AND X.[IDSeguradora] = T.[IDSeguradora]  
    WHEN MATCHED
			    THEN UPDATE
				     SET
				       /*  [CPFCNPJ] = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
				       , [NomeCliente] = COALESCE(X.[NomeCliente],T.[NomeCliente])
				       ,*/ [IDRamo] = COALESCE(X.[IDRamo],T.[IDRamo])
				       , [CodigoFonteProdutora] = COALESCE(X.[CodigoFonteProdutora],T.[CodigoFonteProdutora])
				       
				       , [NumeroBilhete] = COALESCE(X.[NumeroBilhete],T.[NumeroBilhete])
				       , [NumeroSICOB] = COALESCE(X.[NumeroSICOB], T.[NumeroSICOB])
               , [IDContratoAnterior] = COALESCE(X.[IDContratoAnterior], T.[IDContratoAnterior])

               , [DataEmissao] = COALESCE(T.[DataEmissao], X.[DataEmissao])
               , [DataInicioVigencia] = COALESCE(T.[DataInicioVigencia], X.[DataInicioVigencia])
               , [DataFimVigencia] = COALESCE(T.[DataFimVigencia], X.[DataFimVigencia])
               , [ValorPremioTotal] = COALESCE(T.[ValorPremioTotal], X.[ValorPremioTotal])
               , [ValorPremioLiquido] = COALESCE(T.[ValorPremioLiquido], X.[ValorPremioLiquido])               
               , [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas])
               , [IDAgencia] = COALESCE(X.[IDAgencia], T.[IDAgencia])
               , [IDIndicador] = COALESCE(X.[IDIndicador], T.[IDIndicador])
               , [IDIndicadorGerente] = COALESCE(X.[IDIndicadorGerente], T.[IDIndicadorGerente])
               , [IDIndicadorSuperintendenteRegional] = COALESCE(X.[IDIndicadorSuperintendenteRegional], T.[IDIndicadorSuperintendenteRegional])
               , [CodigoMoedaSegurada] = COALESCE(X.[CodigoMoedaSegurada], T.[CodigoMoedaSegurada])
               , [CodigoMoedaPremio] = COALESCE(X.[CodigoMoedaPremio], T.[CodigoMoedaPremio])
               , [LayoutRisco] = COALESCE(X.[LayoutRisco], T.[LayoutRisco])
               , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED
			    THEN INSERT          
              ( /*  [CPFCNPJ]                                   
                , [NomeCliente]
                ,*/ [IDProposta]
                , [IDSeguradora] /*Caixa Seguros*/
                , [IDRamo]
                , [NumeroContrato]
                , [CodigoFonteProdutora]
                , [NumeroBilhete]
                , [NumeroSICOB]
                , [IDContratoAnterior]
                , [DataEmissao]
                , [DataInicioVigencia]
                , [DataFimVigencia]
                , [ValorPremioTotal]
                , [ValorPremioLiquido]
                , [QuantidadeParcelas]
                , [IDAgencia] 
                , [IDIndicador]
                , [IDIndicadorGerente]
                , [IDIndicadorSuperintendenteRegional]
                , [CodigoMoedaSegurada]
                , [CodigoMoedaPremio]
                , [LayoutRisco]
                , [DataArquivo]
                , [Arquivo]  )
          VALUES (/*X.[CPFCNPJ]
                , X.[NomeCliente]
                ,*/ X.[IDProposta]
                , X.[IDSeguradora] /*Caixa Seguros*/
                , X.[IDRamo]
                , X.[NumeroContrato]
                , X.[CodigoFonteProdutora]
                , X.[NumeroBilhete]
                , X.[NumeroSICOB]
                , X.[IDContratoAnterior]
                , X.[DataEmissao]
                , X.[DataInicioVigencia]
                , X.[DataFimVigencia]
                , X.[ValorPremioTotal]
                , X.[ValorPremioLiquido]
                , X.[QuantidadeParcelas]
                , X.[IDAgencia] 
                , X.[IDIndicador]
                , X.[IDIndicadorGerente]
                , X.[IDIndicadorSuperintendenteRegional]
                , X.[CodigoMoedaSegurada]
                , X.[CodigoMoedaPremio]
                , X.[LayoutRisco]
                , X.[DataArquivo]
                , X.[Arquivo]               
                 );
  */
    -----------------------------------------------------------------------------------------------------------------------          



	


    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.ContratoCliente SET LastValue = 0
   -- SELECT *
    FROM Dados.ContratoCliente PS
    WHERE PS.IDContrato IN (SELECT C.ID
                            FROM dbo.[EMISSAO_ENDOSSO_TEMP] EM_T
							  INNER JOIN Dados.Contrato C
							  ON C.[NumeroContrato] = EM_T.NumeroContrato
							 AND C.IDSeguradora = 1    
                            )
           AND PS.LastValue = 1	

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para apagar os Clientes dos Contratos recebidos no mesmo dia do arquivo de EMISSÃO. 
	--Inserido em: 2013-10-09 por Egler.
	--Razão: Eliminar os registros fake.
    -----------------------------------------------------------------------------------------------------------------------    
    DELETE 
    FROM Dados.ContratoCliente 
    WHERE EXISTS (SELECT C.ID
					FROM dbo.[EMISSAO_ENDOSSO_TEMP] EM_T
						INNER JOIN Dados.Contrato C
						ON C.[NumeroContrato] = EM_T.NumeroContrato
						AND C.IDSeguradora = 1   
					WHERE Dados.ContratoCliente.IDContrato = C.ID
					AND Dados.ContratoCliente.DataArquivo = EM_T.DataArquivo 
					AND EM_T.NumeroContrato IS NOT NULL
					AND EM_T.NumeroEndosso = (SELECT MAX(NumeroEndosso) FROM [EMISSAO_ENDOSSO_TEMP] EM1 WHERE EM1.NumeroContrato = EM_T.NumeroContrato)
					)
  	-----------------------------------------------------------------------------------------------------------------------

 
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Clientes dos Contratos recebidos no arquivo EMISSAO
        
    ;MERGE INTO Dados.ContratoCliente AS T
		USING (
            SELECT 	
                   C.ID [IDContrato], EM.Nome [NomeCliente], EM.[CPFCNPJ], EM.CodigoCliente
                 , EM.Endereco, EM.Bairro, EM.Cidade, EM.UF, EM.CEP, EM.DDD, EM.Telefone
                 , EM.TipoPessoa, EM.[DataArquivo], EM.NomeArquivo [Arquivo]
            FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
              LEFT JOIN Dados.Contrato C
              ON  EM.[NumeroContrato] = C.[NumeroContrato]
              AND EM.[IDSeguradora] = C.[IDSeguradora]	               
             WHERE /*[RankContrato] = 1  
               AND */EM.NumeroContrato IS NOT NULL
                 AND EM.NumeroEndosso = (SELECT MAX(NumeroEndosso) FROM [EMISSAO_ENDOSSO_TEMP] EM1 WHERE EM1.NumeroContrato = EM.NumeroContrato)
                 AND EM.[RankContrato] = 1 
				 --AND c.id = 5252726

				--and c.numeroContrato = (5252726, 2013-03-07)
             GROUP BY C.ID, EM.Nome, EM.[CPFCNPJ], EM.CodigoCliente, EM.[DataArquivo], EM.NomeArquivo
                    , EM.Endereco, EM.Bairro, EM.Cidade, EM.UF, EM.CEP, EM.DDD, EM.Telefone, EM.TipoPessoa
          ) AS X
    ON  X.[IDContrato] = T.[IDContrato]
    AND ISNULL(X.Endereco, '') = ISNULL(T.Endereco, '')
	AND ISNULL(X.Telefone,'') = ISNULL(T.Telefone,'') 
	AND X.NomeCliente = T.[NomeCliente] 
	--
    WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] 
		THEN UPDATE
				SET
				 [TipoPessoa] = COALESCE(X.[TipoPessoa], T.[TipoPessoa])
			   , [CPFCNPJ] = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
			   , [NomeCliente] = COALESCE(X.[NomeCliente],T.[NomeCliente])
               , [CodigoCliente] = COALESCE(X.[CodigoCliente],T.[CodigoCliente])
               , [Endereco] = COALESCE(X.[Endereco],T.[Endereco])
               , [Bairro] = COALESCE(X.[Bairro],T.[Bairro])
               , [Cidade] = COALESCE(X.[Cidade],T.[Cidade])
               , [UF] = COALESCE(X.[UF],T.[UF])
               , [CEP] = COALESCE(X.[CEP],T.[CEP])
               , [DDD] =  COALESCE(X.[DDD],T.[DDD])
               , [Telefone] =  COALESCE(X.[Telefone],T.[Telefone])
               , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
			   , LastValue = 1
    WHEN NOT MATCHED
			    THEN INSERT          
              (   IDContrato
                , TipoPessoa
                , [CPFCNPJ]
                , [NomeCliente]
                , [CodigoCliente]

                , [Endereco]  
                , [Bairro] 
                , [Cidade] 
                , [UF] 
                , [CEP] 
                , [DDD] 
                , [Telefone] 

                , [DataArquivo]
                , [Arquivo]  
				, LastValue)
          VALUES (
                  X.IDContrato
                , X.TipoPessoa
                , X.[CPFCNPJ]
                , X.[NomeCliente]
                , X.[CodigoCliente]

                , X.[Endereco]  
                , X.[Bairro] 
                , X.[Cidade] 
                , X.[UF] 
                , X.[CEP] 
                , X.[DDD] 
                , X.[Telefone] 

                , X.[DataArquivo]
                , X.[Arquivo] 
				, 1              
                 );



    -----------------------------------------------------------------------------------------------------------------------      
    
	----------------------------------------------------------------------------------------------------------------------- 
	/*APAGAR ENDOSSOS FAKE DOS CONSTRATOS QUE ESTÃO INSERINDO ENDOSSOS*/
	----------------------------------------------------------------------------------------------------------------------- 
	DELETE FROM Dados.Endosso 
	WHERE IDContrato in ( 
						 SELECT C.ID
						 FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
								  LEFT JOIN Dados.Contrato C
								  ON  EM.[NumeroContrato] = C.[NumeroContrato]
								  AND EM.[IDSeguradora] = C.[IDSeguradora]
                          )
    AND NumeroEndosso = -1
	AND IDProduto = -1
    ----------------------------------------------------------------------------------------------------------------------- 
  /*
	UPDATE Dados.Endosso SET LastValue = 0
	FROM  Dados.Endosso EN
	WHERE  EXISTS (
	               SELECT *
	               FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
						INNER JOIN Dados.Contrato C
						ON  C.NumeroContrato = EM.NumeroContrato
						AND C.IDSeguradora = EM.IDSeguradora
						--INNER JOIN Dados.Produto P 
						--ON P.CodigoComercializado = EM.CodigoProduto
						--AND P.IDSeguradora = EM.IDSeguradora
					WHERE EN.IDContrato = C.ID
					 --AND EN.IDProduto = P.ID
				--	 AND EN.NumeroEndosso = EM.NumeroEndosso
				  )			
   */
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Endossos dos contratos recebidos no arquivo EMISSAO
    -----------------------------------------------------------------------------------------------------------------------		                

     ;MERGE INTO Dados.Endosso AS T
		  USING (
          SELECT 
                 C.ID [IDContrato], EM.[CodigoSubestipulante], EM.[NumeroEndosso], P.ID [IDProduto], EM.[DataEmissao]
               , EM.[DataInicioVigencia], EM.[DataFimVigencia]               
               , (EM.[ValorPremioTotal] ) ValorPremioTotal, (EM.[ValorPremioLiquido] ) ValorPremioLiquido, TE.[ID] [IDTipoEndosso], SE.ID [IDSituacaoEndosso]
               , /*EM.IDSeguradora,*/  EM.[QuantidadeParcelas],  EM.[DataArquivo], EM.[NomeArquivo] [Arquivo]--, SinalLancamento

          FROM [dbo].[EMISSAO_ENDOSSO_TEMP] EM
            INNER JOIN Dados.Contrato C
            ON  C.NumeroContrato = EM.NumeroContrato
            AND C.IDSeguradora = EM.IDSeguradora
            INNER JOIN Dados.Produto P 
            ON P.CodigoComercializado = EM.CodigoProduto
            AND P.IDSeguradora = EM.IDSeguradora
            INNER JOIN Dados.TipoEndosso TE
            ON TE.Codigo = EM.TipoEndosso
            INNER JOIN Dados.SituacaoEndosso SE
            ON SE.Codigo = EM.SituacaoEndosso
          WHERE EM.[RankEndosso] = 1
		  --and c.id = 2548295
        ) AS X
      ON X.[IDContrato] = T.[IDContrato]
      AND X.[NumeroEndosso] = T.[NumeroEndosso]   
      WHEN MATCHED
			      THEN UPDATE
				       SET [CodigoSubestipulante] = COALESCE(X.[CodigoSubestipulante], T.[CodigoSubestipulante])
				         , [DataEmissao] = COALESCE(X.[DataEmissao], T.[DataEmissao])
				         , [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia],T.[DataInicioVigencia])
				         , [DataFimVigencia] = COALESCE(X.[DataFimVigencia],T.[DataFimVigencia])
				         , [ValorPremioTotal] = COALESCE(X.[ValorPremioTotal],T.[ValorPremioTotal])
				         , [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido],T.[ValorPremioLiquido])  				       
				         , [IDTipoEndosso] = COALESCE(X.[IDTipoEndosso],T.[IDTipoEndosso])
				         , [IDSituacaoEndosso] = COALESCE(X.[IDSituacaoEndosso], T.[IDSituacaoEndosso])
                 , [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas])
				 --, SinalLancamento = X.SinalLancamento
                 , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
                 , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
      WHEN NOT MATCHED
			      THEN INSERT          
                (   [IDContrato]
                  , [IDProduto]
                  --, [IDSeguradora]
                  , [CodigoSubestipulante] 
                  , [NumeroEndosso]
                  , [DataEmissao]
                  , [DataInicioVigencia]
                  , [DataFimVigencia]
                  , [ValorPremioTotal]
                  , [ValorPremioLiquido]
                  , [IDTipoEndosso]
                  , [IDSituacaoEndosso]
                  , [QuantidadeParcelas]
                  , [DataArquivo]
                  , [Arquivo] 
				  --, SinalLancamento
				  )
            VALUES (X.[IDContrato]
                  , X.[IDProduto]
                  --, X.[IDSeguradora] 
                  , X.[CodigoSubestipulante]
                  , X.[NumeroEndosso]
                  , X.[DataEmissao]
                  , X.[DataInicioVigencia]
                  , X.[DataFimVigencia]
                  , X.[ValorPremioTotal]
                  , X.[ValorPremioLiquido]
                  , X.[IDTipoEndosso]
                  , X.[IDSituacaoEndosso]
                  , X.[QuantidadeParcelas]
                  , X.[DataArquivo]
                  , X.[Arquivo]
				  --, X.SinalLancamento
				  );
 
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*Egler Vieira- Atualiza o saldo do prêmio assim como a data de cancelamento e data de fim de vigência com a última posição disponível*/
	/*Data: 25/10/2013*/
	------------------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE Dados.Contrato SET DataFimVigenciaAtual = EN.DataFimVigenciaAtual
	                        , ValorPremioLiquidoAtual = EN.ValorPremiLiquidoAtual
							, ValorPremioTotalAtual = EN.ValorPremioTotalAtual
							, DataCancelamento = EN.DataCancelamento
	/*
	SELECT CNT.NumeroContrato, CNT.DataInicioVigencia, CNT.DataFimVigencia
	     , CNT.DataFimVigenciaAtual, EN.ValorPremiLiquidoAtual
		 , EN.ValorPremioTotalAtual, EN.DataFimVigenciaAtual, EN.DataCancelamento
	*/
	FROM Dados.Contrato CNT
	INNER JOIN [dbo].[EMISSAO_ENDOSSO_TEMP] EM
    ON  CNT.NumeroContrato = EM.NumeroContrato
	CROSS APPLY (SELECT  SUM(EN.ValorPremioLiquido * TE.SinalLancamento) OVER (PARTITION BY EN.IDContrato ORDER BY EN.DataArquivo ASC, EN.NumeroEndosso ASC) ValorPremiLiquidoAtual
	                    ,SUM(EN.ValorPremioTotal * TE.SinalLancamento) OVER (PARTITION BY EN.IDContrato ORDER BY EN.DataArquivo ASC, EN.NumeroEndosso ASC) ValorPremioTotalAtual--OVER(PARTITION BY EN.IDContrato ORDER BY DataArquivo DESC, EN.NumeroEndosso) ]


						,MIN(EN.DataFimVigencia) OVER (PARTITION BY EN.IDContrato ORDER BY EN.DataArquivo DESC, EN.NumeroEndosso DESC) DataFimVigenciaAtual
						,MAX(CASE WHEN TE.Cancelamento = 1 THEN EN.DataEmissao ELSE NULL END) DataCancelamento
						,EN.DataArquivo
						,ROW_NUMBER() OVER (PARTITION BY EN.IDContrato ORDER BY EN.DataArquivo DESC, EN.NumeroEndosso DESC) [ORDEM]
	             FROM Dados.Endosso EN
				 INNER JOIN Dados.TipoEndosso TE
				 ON TE.ID = EN.IDTipoEndosso
				 INNER JOIN Dados.Produto PRD
				 ON PRD.ID = EN.IDProduto
				 INNER JOIN Dados.ProdutoSIGPF SIGPF
				 ON SIGPF.ID = PRD.IDProdutoSIGPF 				 
				 WHERE EN.IDContrato = CNT.ID
				 --AND TE.SinalLancamento <> 0
				 AND SIGPF.ProdutoPatrimonial = 1
				 GROUP BY EN.IDContrato,EN.DataFimVigencia, EN.ValorPremioLiquido, EN.ValorPremioTotal, TE.SinalLancamento, EN.DataArquivo, EN.NumeroEndosso, TE.Cancelamento) EN
	WHERE  EN.ORDEM = 1	   
	--AND CNT.ID = 2846253
	------------------------------------------------------------------------------------------------------------------------------------------------------------


    -----------------------------------------------------------------------------------------------------------------------        
    /*
	UPDATE Dados.Endosso SET LastValue = 1
	FROM  Dados.Endosso EN

	CROSS APPLY(
				SELECT *
				FROM
				(
	               SELECT E.ID, ROW_NUMBER() OVER (PARTITION BY E.IDContrato, E.IDProduto ORDER BY E.DataArquivo DESC, E.NumeroEndosso DESC) [ORDEM]
	               FROM	[dbo].[EMISSAO_ENDOSSO_TEMP] EM
					INNER JOIN Dados.Contrato C
					ON  C.NumeroContrato = EM.NumeroContrato
					AND C.IDSeguradora = EM.IDSeguradora 
					INNER JOIN Dados.Endosso E
					ON C.ID = E.IDContrato 
				    INNER JOIN	Dados.Produto P 
					ON E.IDProduto = P.ID
					INNER JOIN Dados.ProdutoSIGPF SIGPF
					ON P.IDProdutoSIGPF = SIGPF.ID
					WHERE (SIGPF.ProdutoComCertificado = 0 
						OR SIGPF.ProdutoComCertificado IS NULL)   --Só teremos LastValue = 1 para os contratos onde os produtos são de contratos "INDIVIDUAIS"						         
					                                              --, isto é, não temos LastValue para Contratos de Vida Em Grupo e assemelhadosado
                    --AND EM.CodigoProduto = P.CodigoComercializado
					--AND EN.NumeroEndosso = E.NumeroEndosso
				) A
	            WHERE A.ORDEM = 1
				AND EN.ID = A.ID
				) CA
	 --SELECT * 			        
	 --FROM Dados.Contrato C
	 --WHERE IDIndicador IS NOT NULL

	  */
	
       
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'EMISSAO'
  /*************************************************************************************/
  
  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[EMISSAO_ENDOSSO_TEMP] 
  
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[EMISSAO_ENDOSSO_TEMP]
                  SELECT *
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaEmissaoEEndosso] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)     

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[EMISSAO_ENDOSSO_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMISSAO_ENDOSSO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	--DROP TABLE [dbo].[EMISSAO_ENDOSSO_TEMP];


END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      


