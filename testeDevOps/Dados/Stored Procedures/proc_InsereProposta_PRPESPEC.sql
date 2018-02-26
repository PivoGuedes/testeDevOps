
/*
	Autor: Diego Lima
	Data Criação: 24/10/2013

	Descrição: 
	
	Última alteração : Gustavo 27/11/2013 -> Inclusão de MERGE para validar as faixas renda
	individual e familiar existentes.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_PRPESPEC
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereProposta_PRPESPEC] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPESPEC_TEMP];

CREATE TABLE [dbo].[PRPESPEC_TEMP](
									[Codigo] [bigint] NOT NULL,
									[ControleVersao] [numeric](16, 8) NULL,
									[NomeArquivo] [varchar](100) NOT NULL,
									[DataArquivo] [date] NOT NULL,
									[CPFCNPJ] [varchar](18) NULL,
									[Nome] [varchar](8000) NULL,
									[TipoPessoa] [varchar](15) NULL,
									[NumeroProposta] [varchar](20) NULL,
									[NumeroProduto] [varchar](5) NULL,
									[AgenciaVenda] [varchar](5) NULL,
									[DataProposta] [date] NULL,
									[FormaPagamento] [varchar](45) NULL,
									[TipoPagamento] [tinyint] null,
									[AgenciaDebitoConta] [varchar](20) NULL,
									[OperacaoDebitoConta] [varchar](20) NULL,
									[ContaCorrenteDebitoConta] [varchar](20) NULL,
									[MatriculaVendedor] [varchar](20) NULL,
									[ValorPremioTotal] [numeric](16, 2) NULL,
									[DeclaracaoSaudeTitular] [varchar](20) NULL,
									[DeclaracaoSaudeConjuge] [varchar](20) NULL,
									[AposentadoriaInvalidez] [varchar](1) NULL,
									[RenovacaoAutomatica] [varchar](1) NULL,
									[DiaPagamento] [varchar](2) NULL,
									[PercentualDesconto] [numeric](16, 2) NULL,
									[EmpresaConvenente] [varchar](40) NULL,
									[MatriculaConvenente] [varchar](8) NULL,
									[CNPJEmpresaConvenente] [varchar](18) NULL,
									[SituacaoProposta] [varchar](3) NULL,
									[SituacaoCobranca] [varchar](3) NULL, 
									[MotivoSituacao] [varchar](3) NULL, 
									[OpcaoCobertura] [varchar](1) NULL,
									[CodigoPlano] [varchar](4) NULL,
									[DataAutenticacaoSICOB] [date] NULL,
									[ValorPagamento] [numeric](16, 2) NULL,
									[AgenciaPagamentoSICOB] [varchar](4) NULL,
									[TarifaCobrancaSICOB] [numeric](16, 2) NULL,
									[DataCreditoGCSSICOB] [date] NULL,
									[ValorComissaoSICOB] [numeric](16, 2) NULL,
									[PeriodicidadePagamento] [varchar](2) NULL,
									[OpcaoConjuge] [varchar](1) NULL,
									[OrigemProposta] [varchar](2) NULL,
									[SequencialArquivo] [varchar](6) NULL,
									[SequencialRegistro] [varchar](6) NULL,
									[TipoResidencia] [varchar](20) NULL,
									[ValorIOF] [numeric](16, 2) NULL,
									[CustoApolice] [numeric](16, 2) NULL, 
									[NumeroSICOB] [varchar](20) null,
									[TipoEndereco] [smallint] NULL,
									[Endereco] [varchar](80) NULL,
									[Bairro]   [varchar](80) NULL,
									[Cidade]   [varchar](80) NULL,
									[SiglaUF]  [varchar](16) NULL,
									[CEP]      [varchar](9) NULL,
									[DDDComercial] [varchar](3) NULL,
									[TelefoneComercial] [varchar](9) NULL,
									[DDDFax] [varchar](3) NULL,
									[TelefoneFax] [varchar](9) NULL,
									[DDD] [varchar](3) NULL,
									[Telefone] [varchar](9) NULL,
									[Email] [varchar](50) NULL,
									[CodigoSegmento] [varchar](4) NULL,
									[RendaIndividual] [varchar](2),
									[RendaFamiliar][varchar](2),
									[RANK] [bigint] NULL
								);

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PRPESPEC_TEMP ON [dbo].PRPESPEC_TEMP
( 
  Codigo ASC
)       

/* SELECIONA O ÚLTIMO PONTO DE PARADA */

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_PRPESPEC'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--    DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[PRPESPEC_TEMP]
           ([Codigo], [ControleVersao], [NomeArquivo], [DataArquivo], [CPFCNPJ], [Nome], [TipoPessoa]
			,[NumeroProposta], [NumeroProduto], [AgenciaVenda], [DataProposta], [FormaPagamento],[TipoPagamento]
			,[AgenciaDebitoConta], [OperacaoDebitoConta], [ContaCorrenteDebitoConta], [MatriculaVendedor]
			,[ValorPremioTotal], [DeclaracaoSaudeTitular], [DeclaracaoSaudeConjuge], [AposentadoriaInvalidez]
			,[RenovacaoAutomatica], [DiaPagamento], [PercentualDesconto], [EmpresaConvenente], [MatriculaConvenente]
			,[CNPJEmpresaConvenente], [SituacaoProposta], [SituacaoCobranca], [MotivoSituacao], [OpcaoCobertura]
			,[CodigoPlano], [DataAutenticacaoSICOB], [ValorPagamento], [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB]
			,[DataCreditoGCSSICOB], [ValorComissaoSICOB], [PeriodicidadePagamento], [OpcaoConjuge], [OrigemProposta]
			,[SequencialArquivo], [SequencialRegistro], [TipoResidencia], [ValorIOF], [CustoApolice], [NumeroSICOB]
			,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP], [DDDComercial], [TelefoneComercial]
			,[DDDFax], [TelefoneFax], [DDD], [Telefone], [Email], [CodigoSegmento], [RendaIndividual], [RendaFamiliar], [RANK])

		   SELECT  [Codigo], [ControleVersao], [NomeArquivo], [DataArquivo], [CPFCNPJ], [Nome], [TipoPessoa]
			,[NumeroProposta], [NumeroProduto], [AgenciaVenda], [DataProposta], [FormaPagamento],[TipoPagamento]
			,[AgenciaDebitoConta], [OperacaoDebitoConta], [ContaCorrenteDebitoConta], [MatriculaVendedor]
			,[ValorPremioTotal], [DeclaracaoSaudeTitular], [DeclaracaoSaudeConjuge], [AposentadoriaInvalidez]
			,[RenovacaoAutomatica], [DiaPagamento], [PercentualDesconto], [EmpresaConvenente], [MatriculaConvenente]
			,[CNPJEmpresaConvenente], [SituacaoProposta], [SituacaoCobranca], [MotivoSituacao], [OpcaoCobertura]
			,[CodigoPlano], [DataAutenticacaoSICOB], [ValorPagamento], [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB]
			,[DataCreditoGCSSICOB], [ValorComissaoSICOB], [PeriodicidadePagamento], [OpcaoConjuge], [OrigemProposta]
			,[SequencialArquivo], [SequencialRegistro], [TipoResidencia], [ValorIOF], [CustoApolice], [NumeroSICOB]
			,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP], [DDDComercial], [TelefoneComercial]
			,[DDDFax], [TelefoneFax], [DDD], [Telefone], [Email], [CodigoSegmento], [RendaIndividual], [RendaFamiliar], [RANK]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRPESPEC_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/***********************************************************************
       Carregar as SITUAÇÕES de cobrança desconhecidas
 ***********************************************************************/

 ;MERGE INTO [Dados].[PeriodoPagamento] AS T
	  USING (
			   SELECT DISTINCT PRP.[PeriodicidadePagamento], '' [Descricao]
               FROM dbo.[PRPESPEC_TEMP] PRP
               WHERE PRP.[PeriodicidadePagamento] IS NOT NULL
              ) X
         ON T.Codigo = X.[PeriodicidadePagamento] 
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, Descricao)
		               VALUES (X.[PeriodicidadePagamento], X.[Descricao]);

/**********************************************************************
       Carrega os PRODUTOS desconhecidos
***********************************************************************/
             
;MERGE INTO Dados.Produto AS T
	USING (
			SELECT DISTINCT PRP.[NumeroProduto] [CodigoComercializado], '' [Descricao]
            FROM dbo.[PRPESPEC_TEMP] PRP
			WHERE PRP.[NumeroProduto] IS NOT NULL
          ) X
         ON T.[CodigoComercializado] = X.[CodigoComercializado] 
       WHEN NOT MATCHED
		          THEN INSERT ([CodigoComercializado], Descricao)
		               VALUES (X.[CodigoComercializado], X.[Descricao]);

 /***********************************************************************
       Carregar as SITUAÇÕES de proposta desconhecidas
 ***********************************************************************/

 ;MERGE INTO Dados.SituacaoProposta AS T
	  USING (
			   SELECT DISTINCT PRP.SituacaoProposta [Sigla], '' [Descricao]
               FROM dbo.[PRPESPEC_TEMP] PRP
               WHERE PRP.SituacaoProposta IS NOT NULL
              ) X
         ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.[Descricao]);

 /***********************************************************************
       Carregar as SITUAÇÕES de cobrança desconhecidas
 ***********************************************************************/

 ;MERGE INTO [Dados].[SituacaoCobranca] AS T
	  USING (
			   SELECT DISTINCT PRP.SituacaoCobranca [Sigla], '' [Descricao]
               FROM dbo.[PRPESPEC_TEMP] PRP
               WHERE PRP.SituacaoCobranca IS NOT NULL
              ) X
         ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.[Descricao]);

/***********************************************************************
       Carregar os tipos motivos desconhecidos
 ***********************************************************************/

 ;MERGE INTO [Dados].[TipoMotivo] AS T
	  USING (
			   SELECT DISTINCT PRP.MotivoSituacao [Codigo], '' [Nome]
               FROM dbo.[PRPESPEC_TEMP] PRP
               WHERE PRP.MotivoSituacao IS NOT NULL
              ) X
         ON T.[Codigo] = X.[Codigo] 
       WHEN NOT MATCHED
		          THEN INSERT ([Codigo], [Nome])
		               VALUES (X.[Codigo], X.[Nome]);

/***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
***********************************************************************/

;MERGE INTO Dados.Funcionario AS T
	 USING (           
              SELECT DISTINCT PRP.[MatriculaVendedor] [Matricula], 1 [IDEmpresa] -- Caixa Econômica                
              FROM dbo.[PRPESPEC_TEMP] PRP 
              WHERE PRP.[MatriculaVendedor] IS NOT NULL
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.[IDEmpresa] = 1
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], IDEmpresa);   



/***********************************************************************
       Carrega tabela FaixaRenda não inseridas (RendaIndividual)
***********************************************************************/
  ;MERGE INTO Dados.FaixaRenda AS T
	     USING (           
              SELECT DISTINCT PRP.[RendaIndividual]                
              FROM dbo.PRPESPEC_TEMP PRP 
              WHERE PRP.[RendaIndividual] IS NOT NULL
              ) X
       ON T.[ID] = X.[RendaIndividual] 
       WHEN NOT MATCHED
		          THEN INSERT ([ID])
		               VALUES (X.[RendaIndividual]);  


/***********************************************************************
       Carrega tabela FaixaRenda não inseridas (RendaFamiliar)
***********************************************************************/
  ;MERGE INTO Dados.FaixaRenda AS T
	     USING (           
              SELECT DISTINCT PRP.[RendaFamiliar]                
              FROM dbo.PRPESPEC_TEMP PRP 
              WHERE PRP.[RendaFamiliar] IS NOT NULL
              ) X
       ON T.[ID] = X.[RendaFamiliar] 
       WHEN NOT MATCHED
		          THEN INSERT ([ID])
		               VALUES (X.[RendaFamiliar]); 


/***********************************************************************
       Carregar as agencias desconhecidas
***********************************************************************/

/*INSERE PVs NÃO LOCALIZADOS*/
;INSERT INTO Dados.Unidade(Codigo)

SELECT DISTINCT CAD.AgenciaVenda
FROM dbo.[PRPESPEC_TEMP] CAD
WHERE  CAD.AgenciaVenda IS NOT NULL 
  AND not exists (
                  SELECT     *
                  FROM  Dados.Unidade U
                  WHERE U.Codigo = CAD.AgenciaVenda)                  
                                                        

INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

SELECT DISTINCT U.ID, 
				'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
				-1 [CodigoNaFonte], 
				'PRPESPEC' [TipoDado], 
				MAX(EM.DataArquivo) [DataArquivo], 
				'PRPESPEC' [Arquivo]

FROM dbo.[PRPESPEC_TEMP] EM
INNER JOIN Dados.Unidade U
ON EM.AgenciaVenda = U.Codigo
WHERE 
    not exists (
                SELECT     *
                FROM Dados.UnidadeHistorico UH
                WHERE UH.IDUnidade = U.ID)    
GROUP BY U.ID 

/***********************************************************************
       Carrega os dados da Proposta
***********************************************************************/ 
 
 ;MERGE INTO Dados.Proposta AS T
		USING (SELECT  --null AS [IDContrato],
					   1 AS IDSeguradora, 
						PRP_TMP.NumeroProposta AS NumeroProposta,
						--null AS [NumeroPropostaEMISSAO],
						p.ID AS [IDProduto],
						--null AS [IDProdutoAnterior],
						ISNULL(prd.ID,0) AS [IDProdutoSIGPF],
						pp.ID AS [IDPeriodicidadePagamento],
						--null AS [IDCanalVendaPAR],
						PRP_TMP.DataProposta AS DataProposta,
						--null AS [DataInicioVigencia],
						--null AS [DataFimVigencia]
						f.ID AS [IDFuncionario],--** APARECE NULL
						PRP_TMP.ValorPremioTotal AS [Valor],
						PRP_TMP.RendaIndividual AS [RendaIndividual] ,
						PRP_TMP.RendaFamiliar AS [RendaFamiliar],
						U.ID AS [IDAgenciaVenda],
						PRP_TMP.DataArquivo AS [DataSituacao],
						SP.ID AS [IDSituacaoProposta],
						SC.ID AS [IDSituacaoCobranca],
						TM.ID AS [IDTipoMotivo], --*** APARECE NULL
						PRP_TMP.NomeArquivo AS [TipoDado],
						PRP_TMP.DataArquivo,
						--NULL AS [IDCanalVenda],
						-- NULL AS [ValorPremioBrutoEmissao],
						--NULL AS [ValorPremioLiquidoEmissao],
						--NULL AS [ValorPremioBrutoCalculado],
						--NULL AS [ValorPremioLiquidoCalculado],
						--NULL AS [ValorPagoAcumulado],
						PRP_TMP.ValorPremioTotal,
						PRP_TMP.RenovacaoAutomatica,
						PRP_TMP.PercentualDesconto,
						PRP_TMP.EmpresaConvenente,
						PRP_TMP.MatriculaConvenente,
						PRP_TMP.OpcaoCobertura,
						PRP_TMP.CodigoPlano,
						PRP_TMP.DataAutenticacaoSICOB,
						PRP_TMP.AgenciaPagamentoSICOB,
						PRP_TMP.TarifaCobrancaSICOB,
						PRP_TMP.DataCreditoGCSSICOB AS [DataCreditoSASSESICOB],--** verificar
						PRP_TMP.ValorComissaoSICOB,
						PRP_TMP.PeriodicidadePagamento,
						PRP_TMP.OpcaoConjuge,
						PRP_TMP.OrigemProposta,
						PRP_TMP.DeclaracaoSaudeTitular,
						PRP_TMP.DeclaracaoSaudeConjuge,
						PRP_TMP.AposentadoriaInvalidez,
						PRP_TMP.CodigoSegmento

					  FROM [dbo].[PRPESPEC_TEMP] PRP_TMP
					    INNER JOIN Dados.Unidade U
							ON U.Codigo = PRP_TMP.AgenciaVenda

						INNER JOIN Dados.SituacaoProposta SP
							ON SP.Sigla = PRP_TMP.SituacaoProposta

						INNER JOIN Dados.SituacaoCobranca SC
							ON SC.Sigla = PRP_TMP.SituacaoCobranca
  
					    INNER JOIN Dados.TipoMotivo TM
							ON TM.Codigo = ISNULL(PRP_TMP.MotivoSituacao,-1)

						INNER JOIN Dados.Produto p
							ON (PRP_TMP.NumeroProduto = p.CodigoComercializado)

						LEFT JOIN dados.ProdutoSIGPF prd
							ON prd.ID = p.IDProdutoSIGPF

						LEFT JOIN dados.PeriodoPagamento PP
							ON pp.Codigo = ISNULL(PRP_TMP.PeriodicidadePagamento,0)

					    LEFT JOIN Dados.Funcionario F
							ON F.[Matricula] = PRP_TMP.[MatriculaVendedor]
							 AND F.IDEmpresa = 1
						
				WHERE [RANK] = 1
				)X
		ON X.NumeroProposta = T.NumeroProposta  
			AND X.IDSeguradora = T.IDSeguradora
			WHEN MATCHED
			    THEN UPDATE
							SET
							   --[IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato])
							  [IDSeguradora] = COALESCE(X.[IDSeguradora], T.[IDSeguradora])
							  ,[NumeroProposta] = COALESCE(X.[NumeroProposta], T.[NumeroProposta])
							  --,[NumeroPropostaEMISSAO] = COALESCE(X.[NumeroPropostaEMISSAO], T.[NumeroPropostaEMISSAO])
							  ,[IDProduto] = COALESCE(X.[IDProduto], T.[IDProduto], -1)
							  --,[IDProdutoAnterior]= COALESCE(X.[IDProdutoAnterior], T.[IDProdutoAnterior])
							  ,[IDProdutoSIGPF]= COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF], 0)
							  ,[IDPeriodicidadePagamento]= COALESCE(X.[IDPeriodicidadePagamento], T.[IDPeriodicidadePagamento],0)
							  --,[IDCanalVendaPAR] = COALESCE(X.[IDCanalVendaPAR], T.[IDCanalVendaPAR])
							  ,[DataProposta] = COALESCE(X.[DataProposta], T.[DataProposta])
							 -- ,[DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
							  --,[DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
							  ,[IDFuncionario] = COALESCE(X.[IDFuncionario], T.[IDFuncionario])
							  ,[Valor] = COALESCE(X.[Valor], T.[Valor])
							  ,[RendaIndividual] = COALESCE(X.[RendaIndividual], T.[RendaIndividual])
							  ,[RendaFamiliar] = COALESCE(X.[RendaFamiliar], T.[RendaFamiliar])
							  ,[IDAgenciaVenda] = COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda])
							  ,[DataSituacao] = COALESCE(X.[DataSituacao], T.[DataSituacao])
							  ,[IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
							  ,[IDSituacaoCobranca] = COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
							  ,[IDTipoMotivo] = COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo])
							  ,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
							  ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
							  --,[IDCanalVenda] = COALESCE(X.[IDCanalVenda], T.[IDCanalVenda])
							  --,[ValorPremioBrutoEmissao] = COALESCE(X.[ValorPremioBrutoEmissao], T.[ValorPremioBrutoEmissao])
							  --,[ValorPremioLiquidoEmissao] = COALESCE(X.[ValorPremioLiquidoEmissao], T.[ValorPremioLiquidoEmissao])
							  --,[ValorPremioBrutoCalculado] = COALESCE(X.[ValorPremioBrutoCalculado], T.[ValorPremioBrutoCalculado])
							  --,[ValorPremioLiquidoCalculado] = COALESCE(X.[ValorPremioLiquidoCalculado], T.[ValorPremioLiquidoCalculado])
							  --,[ValorPagoAcumulado] = COALESCE(X.[ValorPagoAcumulado], T.[ValorPagoAcumulado])
							  ,[ValorPremioTotal] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
							  ,[RenovacaoAutomatica] = COALESCE(X.[RenovacaoAutomatica], T.[RenovacaoAutomatica])
							  ,[PercentualDesconto] = COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
							  ,[EmpresaConvenente] = COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente])
							  ,[MatriculaConvenente] = COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente])
							  ,[OpcaoCobertura] = COALESCE(X.[OpcaoCobertura], T.[OpcaoCobertura])
							  ,[CodigoPlano] = COALESCE(X.[CodigoPlano], T.[CodigoPlano])
							  ,[DataAutenticacaoSICOB] = COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB])
							  ,[AgenciaPagamentoSICOB] = COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB])
							  ,[TarifaCobrancaSICOB] = COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB])
							  ,[DataCreditoSASSESICOB] = COALESCE(X.[DataCreditoSASSESICOB], T.[DataCreditoSASSESICOB])
							  ,[ValorComissaoSICOB] = COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB])
							  ,[PeriodicidadePagamento] = COALESCE(X.[PeriodicidadePagamento], T.[PeriodicidadePagamento])
							  ,[OpcaoConjuge] = COALESCE(X.[OpcaoConjuge], T.[OpcaoConjuge])
							  ,[OrigemProposta] = COALESCE(X.[OrigemProposta], T.[OrigemProposta])
							  ,[DeclaracaoSaudeTitular] = COALESCE(X.[DeclaracaoSaudeTitular], T.[DeclaracaoSaudeTitular])
							  ,[DeclaracaoSaudeConjuge] = COALESCE(X.[DeclaracaoSaudeConjuge], T.[DeclaracaoSaudeConjuge])
							  ,[AposentadoriaInvalidez] = COALESCE(X.[AposentadoriaInvalidez], T.[AposentadoriaInvalidez])
							  ,[CodigoSegmento] = COALESCE(X.[CodigoSegmento], T.[CodigoSegmento])
			WHEN NOT MATCHED
			    THEN INSERT (--[IDContrato]
							  [IDSeguradora]
							  ,[NumeroProposta]
							  --,[NumeroPropostaEMISSAO]
							  ,[IDProduto]
							  --,[IDProdutoAnterior]
							  ,[IDProdutoSIGPF]
							  ,[IDPeriodicidadePagamento]
							  --,[IDCanalVendaPAR]
							  ,[DataProposta]
							  --,[DataInicioVigencia]
							  --,[DataFimVigencia]
							  ,[IDFuncionario]--**
							  ,[Valor]
							  ,[RendaIndividual]
							  ,[RendaFamiliar]
							  ,[IDAgenciaVenda]
							  ,[DataSituacao]--**
							  ,[IDSituacaoProposta]
							  ,[IDSituacaoCobranca]
							  ,[IDTipoMotivo]--**
							  ,[TipoDado]
							  ,[DataArquivo]
							  --,[IDCanalVenda]
							  --,[ValorPremioBrutoEmissao]
							  --,[ValorPremioLiquidoEmissao]
							  --,[ValorPremioBrutoCalculado]
							  --,[ValorPremioLiquidoCalculado]
							  --,[ValorPagoAcumulado]
							  ,[ValorPremioTotal]
							  ,[RenovacaoAutomatica]
							  ,[PercentualDesconto]
							  ,[EmpresaConvenente]
							  ,[MatriculaConvenente]
							  ,[OpcaoCobertura]
							  ,[CodigoPlano]
							  ,[DataAutenticacaoSICOB]
							  ,[AgenciaPagamentoSICOB]
							  ,[TarifaCobrancaSICOB]
							  ,[DataCreditoSASSESICOB]
							  ,[ValorComissaoSICOB]
							  ,[PeriodicidadePagamento]
							  ,[OpcaoConjuge]
							  ,[OrigemProposta]
							  ,[DeclaracaoSaudeTitular]
							  ,[DeclaracaoSaudeConjuge]
							  ,[AposentadoriaInvalidez]
							  ,[CodigoSegmento]  )
				VALUES(X.[IDSeguradora], X.[NumeroProposta], ISNULL(X.[IDProduto],-1), ISNULL(X.[IDProdutoSIGPF],0), 
						ISNULL(X.[IDPeriodicidadePagamento],0), X.[DataProposta],X.[IDFuncionario], X.[Valor], 
						X.[RendaIndividual], X.[RendaFamiliar], X.[IDAgenciaVenda], X.[DataSituacao], 
						X.[IDSituacaoProposta], X.[IDSituacaoCobranca], X.[IDTipoMotivo], X.[TipoDado], 
						X.[DataArquivo], X.[ValorPremioTotal], X.[RenovacaoAutomatica], X.[PercentualDesconto],
						X.[EmpresaConvenente], X.[MatriculaConvenente], X.[OpcaoCobertura], 
						X.[CodigoPlano],X.[DataAutenticacaoSICOB], X.[AgenciaPagamentoSICOB], X.[TarifaCobrancaSICOB], 
						X.[DataCreditoSASSESICOB], X.[ValorComissaoSICOB], X.[PeriodicidadePagamento], X.[OpcaoConjuge],
						X.[OrigemProposta], X.[DeclaracaoSaudeTitular], X.[DeclaracaoSaudeConjuge], X.[AposentadoriaInvalidez],
						X.[CodigoSegmento]);

 /***********************************************************************
      Carrega os dados do Cliente da proposta
 ***********************************************************************/  

 ;MERGE INTO Dados.PropostaCliente AS T
		USING (
				SELECT DISTINCT 
								PRP.ID AS [IDProposta],
								PRP_TMP.CPFCNPJ,
								PRP_TMP.Nome,
								--null AS [DataNascimento],
								PRP_TMP.TipoPessoa,
								--null AS [IDSexo],
								--null AS [IDEstadoCivil],
								--null AS [Identidade],
								--null AS [OrgaoExpedidor],
								--null AS [UFOrgaoExpedidor],
								--null AS [DataExpedicaoRG],
								PRP_TMP.DDDComercial,
								PRP_TMP.TelefoneComercial,
								PRP_TMP.DDDFax,
								PRP_TMP.TelefoneFax,
								PRP_TMP.DDD AS [DDDResidencial],
								PRP_TMP.Telefone AS [TelefoneResidencial],
								PRP_TMP.Email,
								--null AS [CodigoProfissao],
								--null AS [Profissao],
								--null AS [NomeConjuge],
								--null AS [ProfissaoConjuge],
								PRP_TMP.nomeArquivo AS [TipoDado],
								PRP_TMP.DataArquivo
								--null AS [Emailcomercial],
								--null AS [DDDCelular],
								--null AS [TelefoneCelular],
								--null AS [CPFConjuge],
								--null AS [IDSexoConjuge],
								--null AS [DataNascimentoConjuge],
								--null AS [CodigoProfissaoConjuge],
								--null AS [Matricula]

					FROM [dbo].[PRPESPEC_TEMP] PRP_TMP
					INNER JOIN Dados.Proposta PRP
						ON PRP_TMP.NumeroProposta = PRP.NumeroProposta
					   AND PRP.IDSeguradora = 1
					WHERE [RANK] = 1
			) AS X
		ON X.IDProposta = T.IDProposta

		WHEN MATCHED
			    THEN UPDATE
				     SET 
						  [CPFCNPJ] = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
						  ,[Nome] = COALESCE(X.[Nome], T.[Nome])
						  --,[DataNascimento]
						  ,[TipoPessoa] = COALESCE(X.[TipoPessoa], T.[TipoPessoa])
						  --,[IDSexo]
						  --,[IDEstadoCivil]
						  --,[Identidade]
						  --,[OrgaoExpedidor]
						  --,[UFOrgaoExpedidor]
						  --,[DataExpedicaoRG]
						  ,[DDDComercial] = COALESCE(X.[DDDComercial], T.[DDDComercial])
						  ,[TelefoneComercial] = COALESCE(X.[TelefoneComercial], T.[TelefoneComercial])
						  ,[DDDFax] = COALESCE(X.[DDDFax], T.[DDDFax])
						  ,[TelefoneFax] = COALESCE(X.[TelefoneFax], T.[TelefoneFax])
						  ,[DDDResidencial] = COALESCE(X.[DDDResidencial], T.[DDDResidencial])
						  ,[TelefoneResidencial] = COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial])
						  ,[Email] = COALESCE(X.[Email], T.[Email])
						  --,[CodigoProfissao]
						  --,[Profissao]
						  --,[NomeConjuge]
						  --,[ProfissaoConjuge]
						  ,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
						  ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
						  --,[Emailcomercial]
						  --,[DDDCelular]
						  --,[TelefoneCelular]
						  --,[CPFConjuge]
						  --,[IDSexoConjuge]
						  --,[DataNascimentoConjuge]
						  --,[CodigoProfissaoConjuge]
						  --,[Matricula]

		WHEN NOT MATCHED
			    THEN INSERT 
							( IDProposta, 
								CPFCNPJ, 
								Nome, 
								TipoPessoa, 
								DDDComercial, 
								TelefoneComercial,
								DDDFax, 
								TelefoneFax, 
								DDDResidencial, 
								TelefoneResidencial, 
								Email,
								TipoDado, 
								DataArquivo)
					
					VALUES (X.IDProposta,
							X.[CPFCNPJ],
							X.[Nome],
							X.[TipoPessoa],
							X.[DDDComercial],
							X.[TelefoneComercial],
							X.[DDDFax],
							X.[TelefoneFax],
							X.[DDDResidencial],
							X.[TelefoneResidencial],
							X.[Email],
							X.[TipoDado],
							X.[DataArquivo]
					
					);

/***********************************************************************/

/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> 
logo depois da inserção das Situações (abaixo)*/
	/*Diego Lima - Data: 25/10/2013 */

 UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP1.ID
                            FROM [dbo].[PRPESPEC_TEMP] PRP
								INNER JOIN Dados.Proposta PRP1
									ON PRP.NumeroProposta = PRP1.NumeroProposta
										AND PRP1.IDSeguradora = 1
							WHERE [Rank] = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1

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

				FROM(
						SELECT  
								P.ID AS IDProposta
								,prp.TipoEndereco AS [IDTipoEndereco]
								,prp.Endereco
								,MAX(PRP.Bairro) Bairro             
								,MAX(PRP.Cidade) Cidade       
								,MAX(PRP.SiglaUF)  [UF]      
								,MAX(PRP.CEP) CEP
								,0 AS LastValue
								,prp.NomeArquivo AS TipoDado
								,MAX(PRP.DataArquivo) DataArquivo
			
						FROM [dbo].[PRPESPEC_TEMP] PRP
							INNER JOIN Dados.Proposta P
								ON P.[NumeroProposta] = PRP.NumeroProposta
									AND P.IDSeguradora = 1

						WHERE  [RANK] = 1--PRP_T.NumeroProposta = 012984710001812
							and PRP.Endereco IS NOT NULL
							and PRP.TIPOENDERECO <> 0

						GROUP BY P.ID 
								,PRP.TipoEndereco 
								,PRP.Endereco
								,prp.NomeArquivo 
					) A
					
				) AS X

				ON  X.IDProposta = T.IDProposta
					AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
					--AND X.[DataArquivo] >= T.[DataArquivo]
					AND X.[Endereco] = T.[Endereco]
					AND NUMERADOR = 1  
	WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] 
		THEN  UPDATE
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
/*Diego Lima - Data: 25/10/2013 */	
		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT P.ID
										FROM [dbo].[PRPESPEC_TEMP] Prp
										  INNER JOIN Dados.Proposta P
										  ON PRP.[NumeroProposta] = P.NumeroProposta
										 AND P.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1
	 
-----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Formas de pagamento não existentes
-----------------------------------------------------------------------------------------------------------------------
     
 ;MERGE INTO Dados.FormaPagamento AS T
	   USING (SELECT DISTINCT PRP.TipoPagamento [IDFormaPagamento], '' Descricao, prp.FormaPagamento
            FROM [dbo].[PRPESPEC_TEMP] PRP
            WHERE PRP.TipoPagamento IS NOT NULL
              ) X
        ON T.ID = X.[IDFormaPagamento]
       WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.[IDFormaPagamento], X.[Descricao]);

-----------------------------------------------------------------------------------------------------------------------               
		                 
	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */
    UPDATE Dados.MeioPagamento SET LastValue = 0
   -- SELECT *
    FROM Dados.MeioPagamento MP
    WHERE MP.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.[PRPESPEC_TEMP] PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND MP.LastValue = 1 

/***********************************************************************
       Carrega os dados da Forma de Pagamento da Proposta
***********************************************************************/ 

;MERGE INTO Dados.MeioPagamento AS T
	    USING (
		    SELECT *
		    FROM
		    ( SELECT DISTINCT
								P.ID AS [IDProposta], 
								PRP.DataArquivo, 
								PRP.NomeArquivo Arquivo
								, /*PRP.[FormaPagamento],*/ 
								PRP.[TipoPagamento] [IDFormaPagamento], 
								'104' [Banco],
								PRP.[AgenciaDebitoConta] [Agencia], 
								PRP.[OperacaoDebitoConta] [Operacao],
								PRP.[ContaCorrenteDebitoConta] [ContaCorrente], 
								PRP.[DiaPagamento] [DiaVencimento],
								ROW_NUMBER() OVER(PARTITION BY PRP.[NumeroProposta] ORDER BY PRP.DataArquivo DESC, PRP.NomeArquivo DESC) [ORDER]

				FROM [dbo].[PRPESPEC_TEMP] PRP
					INNER JOIN Dados.Proposta P
						ON P.NumeroProposta = PRP.[NumeroProposta] 
						) A
			WHERE A.[ORDER] = 1
		 ) AS O

			ON 
		      T.[IDProposta] = O.[IDProposta]
		  AND T.[DataArquivo] = O.[DataArquivo]

	  WHEN MATCHED
		    THEN UPDATE 
			    SET  Operacao = COALESCE(O.Operacao, T.Operacao)
             , [Agencia] = COALESCE(O.[Agencia], T.[Agencia])
             , [ContaCorrente] = COALESCE(O.[ContaCorrente], T.[ContaCorrente])
             , [Banco] = COALESCE(O.[Banco], T.[Banco])
             , [IDFormaPagamento] = COALESCE(O.[IDFormaPagamento], T.[IDFormaPagamento])
             , [DiaVencimento] = COALESCE(O.[DiaVencimento], T.[DiaVencimento])

	  WHEN NOT MATCHED
		    THEN INSERT ([IDProposta], [DataArquivo], [Banco], [Agencia], [Operacao], [ContaCorrente], 
							[IDFormaPagamento], [DiaVencimento])

			    VALUES (O.[IDProposta], O.[DataArquivo], O.[Banco], O.[Agencia], O.[Operacao], 
						O.[ContaCorrente], O.[IDFormaPagamento], O.[DiaVencimento]);


    /*Limpa os meios de pagamento repetidos*/
	/*Diego - Data: 17/12/2013 */
		
	DELETE  Dados.MeioPagamento
	FROM  Dados.MeioPagamento b
	INNER JOIN
	(
		SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
		FROM Dados.MeioPagamento PGTO
			INNER JOIN
			dbo.[PRPESPEC_TEMP] PRP
			INNER JOIN Dados.Proposta P
			ON P.NumeroProposta = PRP.[NumeroProposta]
			AND P.IDSeguradora = 1 
			ON PGTO.IDProposta = P.ID	 
	) A
	ON   A.IDProposta = B.IDProposta
	AND A.DataArquivo = B.DataArquivo
	AND A.ordem > 1	 	
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */	
    UPDATE Dados.MeioPagamento SET LastValue = 1
    FROM Dados.MeioPagamento MP
	CROSS APPLY(
				SELECT TOP 1 *
				FROM Dados.MeioPagamento MP1
				WHERE 
				  MP.IDProposta = MP1.IDProposta
				ORDER BY MP1.IDProposta DESC, MP1.DataArquivo DESC
			   ) A
	 WHERE MP.IDProposta = A.IDProposta 	
 	   AND MP.DataArquivo = A.DataArquivo 
	   AND EXISTS (SELECT  PRP.ID [IDProposta]
					FROM dbo.[PRPESPEC_TEMP] PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
						AND PRP.IDSeguradora = 1
						AND MP.IDProposta = PRP.ID
				  )

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_PRPESPEC'

 /****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[PRPESPEC_TEMP]
  
  /**************************************************************************************/
   
  SET @COMANDO = 'INSERT INTO [dbo].[PRPESPEC_TEMP]
           ([Codigo], [ControleVersao], [NomeArquivo], [DataArquivo], [CPFCNPJ], [Nome], [TipoPessoa]
			,[NumeroProposta], [NumeroProduto], [AgenciaVenda], [DataProposta], [FormaPagamento],[TipoPagamento]
			,[AgenciaDebitoConta], [OperacaoDebitoConta], [ContaCorrenteDebitoConta], [MatriculaVendedor]
			,[ValorPremioTotal], [DeclaracaoSaudeTitular], [DeclaracaoSaudeConjuge], [AposentadoriaInvalidez]
			,[RenovacaoAutomatica], [DiaPagamento], [PercentualDesconto], [EmpresaConvenente], [MatriculaConvenente]
			,[CNPJEmpresaConvenente], [SituacaoProposta], [SituacaoCobranca], [MotivoSituacao], [OpcaoCobertura]
			,[CodigoPlano], [DataAutenticacaoSICOB], [ValorPagamento], [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB]
			,[DataCreditoGCSSICOB], [ValorComissaoSICOB], [PeriodicidadePagamento], [OpcaoConjuge], [OrigemProposta]
			,[SequencialArquivo], [SequencialRegistro], [TipoResidencia], [ValorIOF], [CustoApolice], [NumeroSICOB]
			,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP], [DDDComercial], [TelefoneComercial]
			,[DDDFax], [TelefoneFax], [DDD], [Telefone], [Email], [CodigoSegmento], [RendaIndividual], [RendaFamiliar], [RANK])

		   SELECT  [Codigo], [ControleVersao], [NomeArquivo], [DataArquivo], [CPFCNPJ], [Nome], [TipoPessoa]
			,[NumeroProposta], [NumeroProduto], [AgenciaVenda], [DataProposta], [FormaPagamento],[TipoPagamento]
			,[AgenciaDebitoConta], [OperacaoDebitoConta], [ContaCorrenteDebitoConta], [MatriculaVendedor]
			,[ValorPremioTotal], [DeclaracaoSaudeTitular], [DeclaracaoSaudeConjuge], [AposentadoriaInvalidez]
			,[RenovacaoAutomatica], [DiaPagamento], [PercentualDesconto], [EmpresaConvenente], [MatriculaConvenente]
			,[CNPJEmpresaConvenente], [SituacaoProposta], [SituacaoCobranca], [MotivoSituacao], [OpcaoCobertura]
			,[CodigoPlano], [DataAutenticacaoSICOB], [ValorPagamento], [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB]
			,[DataCreditoGCSSICOB], [ValorComissaoSICOB], [PeriodicidadePagamento], [OpcaoConjuge], [OrigemProposta]
			,[SequencialArquivo], [SequencialRegistro], [TipoResidencia], [ValorIOF], [CustoApolice], [NumeroSICOB]
			,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP], [DDDComercial], [TelefoneComercial]
			,[DDDFax], [TelefoneFax], [DDD], [Telefone], [Email], [CodigoSegmento], [RendaIndividual], [RendaFamiliar], [RANK]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRPESPEC_TEMP PRP 

  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPESPEC_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

			    
			                    