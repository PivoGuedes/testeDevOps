
CREATE PROCEDURE [Dados].[proc_InsereProposta_PRPFCAP]
AS
BEGIN

	BEGIN TRY		
  
	DECLARE @PontoDeParada AS VARCHAR(400)	= '0'
	DECLARE @MaiorCodigo AS BIGINT
	DECLARE @ParmDefinition NVARCHAR(500)
	DECLARE @COMANDO AS NVARCHAR(MAX) 

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPFCAP_TEMP]') AND type IN (N'U') /*ORDER BY NAME*/)
		DROP TABLE [dbo].[PRPFCAP_TEMP];

	CREATE TABLE [dbo].[PRPFCAP_TEMP]
	(
		[Codigo] [bigint] NOT NULL,
		[IDSeguradora] INT DEFAULT(3),
		[IDSegurado] [int] NULL,
		[ControleVersao] [decimal](16, 8) NULL,
		[NomeArquivo] [nvarchar](100) NULL,
		[DataArquivo] [date] NULL,
		[NumeroProposta] [varchar](20) NULL,
		[CPFCNPJ] [char](18) NULL,
		[TipoPessoa] [varchar](30) NULL,
		[Nome] [varchar](120) NULL,
		[DataNascimento] [date] NULL,
		[Identidade] [varchar](20) NULL,
		[OrgaoExpedidor] [varchar](20) NULL,
		[UFOrgaoExpedidor] [varchar](20) NULL,
		[DataExpedicaoRG] [date] NULL,
		[CodigoEstadoCivil] [tinyint] NULL,
		[EstadoCivil] [varchar](30) NULL,
		[CodigoSexo] [tinyint] NULL,
		[Sexo] [varchar](30) NULL,
		[DDDComercial] [nvarchar](5) NULL,
		[TelefoneComercial] [nvarchar](12) NULL,
		[DDDFax] [nvarchar](5) NULL,
		[TelefoneFax] [nvarchar](12) NULL,
		[DDDResidencial] [nvarchar](5) NULL,
		[TelefoneResidencial] [nvarchar](12) NULL,
		[Email] [varchar](120) NULL,
		[CodigoProfissao] [nvarchar](50) NULL,
		[Profissao] [varchar](300) NULL,
		[CodigoSegmento] [nvarchar](30) NULL,
		[RendaFamiliar] [varchar](30) NULL,
		[RendaIndividual] [varchar](30) NULL,
		[NomeConjuge] [varchar](120) NULL,
		[DataNascimentoConjuge] [date] NULL,
		[ProfissaoConjuge] [nvarchar](300) NULL,
		[TipoEndereco] [smallint] NULL,
		[Endereco] [varchar](50) NULL,
		[Bairro] [varchar](30) NULL,
		[Cidade] [varchar](35) NULL,
		[SiglaUF] [varchar](2) NULL,
		[CEP] [varchar](8) NULL,
		[NumeroProdutoSIGPF] [varchar](2) NULL,
		[AgenciaVenda] [varchar](10) NULL,
		[DiaPagamento] [varchar](10) NULL,
		[DataProposta] [date] NULL,
		[CodigoFormaPagamento] [varchar](1) NULL,
		[FormaPagamento] [varchar](30) NULL,
		[AgenciaDebitoConta] [varchar](20) NULL,
		[OperacaoDebitoConta] [varchar](20) NULL,
		[ContaCorrenteDebitoConta] [varchar](20) NULL,
		[DigitoDebitoConta] [varchar](3) NULL,
		[TipoTitular] [varchar](20) NULL,
		[ValorMensalidade] [numeric](15, 2) NULL,
		[QtdeTotalTitulos] [smallint] NULL,
		[MatriculaVendedor] [varchar](30) NULL,
		[ValorTotalProposta] [numeric](15, 2) NULL,
		[PercentualDesconto] [numeric](5, 2) NULL,
		[EmpresaConvenente] [varchar](120) NULL,
		[CNPJEmpresaConvenente] [char](18) NULL,
		[MatriculaConvenente] [varchar](30) NULL,
		[SituacaoProposta] [varchar](30) NULL,
		[SituacaoCobranca] [varchar](30) NULL,
		[MotivoSituacao] [varchar](30) NULL,
		[CodigoPlano] [varchar](30) NULL,
		[DataAutenticacaoSICOB] [date] NULL,
		[ValorPagoSICOB] [numeric](15, 2) NULL,
		[AgenciaPagamentoSICOB] [varchar](10) NULL,
		[TarifaCobrancaSICOB] [numeric](15, 2) NULL,
		[ValorComissaoSICOB] [numeric](15, 2) NULL,
		[TituloOriginarioRevenda] [varchar](30) NULL,
		[OrigemProposta] [varchar](30) NULL,
		[SequencialArquivo] [varchar](30) NULL,
		[SequencialRegistro] [varchar](300) NULL,
		[Reservado] [varchar](30) NULL,
		[DataCreditoFederalCap] [date] NULL,
		[TipoArquivo] [varchar](50) NULL,
		[RANK] [bigint] NULL
	);

	CREATE NONCLUSTERED INDEX idx_PRPFCAP_TEMP_NumeroProposta ON [dbo].[PRPFCAP_TEMP]
	( 
		NumeroProposta ASC,
		[DataArquivo] DESC
	)

	CREATE CLUSTERED INDEX idx_PRPFCAP_TEMP_NumeroPropost_TipoEndereco ON [dbo].[PRPFCAP_TEMP]
	( 
		NumeroProposta ASC,
		TipoEndereco ASC,
		Endereco ASC
	)

	CREATE NONCLUSTERED INDEX idx_PRPFCAP_TEMP_SituacaoProposta ON [dbo].[PRPFCAP_TEMP]
	( 
		SituacaoProposta
	)

	CREATE NONCLUSTERED INDEX idx_PRPFCAP_TEMP_MatriculaVendedor ON [dbo].[PRPFCAP_TEMP]
	( 
		MatriculaVendedor
	)

	CREATE NONCLUSTERED INDEX IDX_PRPFCAP_TEMP_CodigoFormaPagamento ON [dbo].[PRPFCAP_TEMP]
	(
		CodigoFormaPagamento
	)  

	CREATE NONCLUSTERED INDEX IDX_PRPFCAP_TEMP_NumeroProdutoSIGPF
    ON [dbo].[PRPFCAP_TEMP] ([NumeroProdutoSIGPF])



	SELECT @PontoDeParada = PontoParada
	FROM ControleDados.PontoParada
	WHERE NomeEntidade = 'Proposta_PRPFCAP'

	--SELECT @PontoDeParada = 20007037

	/*Recuperação do Maior Código de Retorno*/
	/*********************************************************************************************************************/               
	/*********************************************************************************************************************/
	--DECLARE @PontoDeParada AS VARCHAR(400)
	--set @PontoDeParada = 3215088
	--DECLARE @MaiorCodigo AS BIGINT
	--DECLARE @ParmDefinition NVARCHAR(500)
	--DECLARE @COMANDO AS NVARCHAR(MAX) 

	SET @COMANDO =
	'INSERT INTO [dbo].[PRPFCAP_TEMP]
				(
				 [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[CPFCNPJ],[TipoPessoa],
				 [Nome],[DataNascimento],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG],
				 [CodigoEstadoCivil],[EstadoCivil],[CodigoSexo],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial],
				 [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar],[RendaIndividual],
				 [NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoEndereco],[Endereco],[Bairro],[Cidade],
				 [SiglaUF],[CEP],[NumeroProdutoSIGPF],[AgenciaVenda],[DiaPagamento],[DataProposta],[CodigoFormaPagamento],
				 [FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta],[ContaCorrenteDebitoConta],[DigitoDebitoConta],
				 [TipoTitular],[ValorMensalidade],[QtdeTotalTitulos],[MatriculaVendedor],[ValorTotalProposta],[PercentualDesconto],
				 [EmpresaConvenente],[CNPJEmpresaConvenente],[MatriculaConvenente],[SituacaoProposta],[SituacaoCobranca],[MotivoSituacao],
				 [CodigoPlano],[DataAutenticacaoSICOB],[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[ValorComissaoSICOB],
				 [TituloOriginarioRevenda],[OrigemProposta],[SequencialArquivo],[SequencialRegistro],[Reservado],[DataCreditoFederalCap],[TipoArquivo],
				 [RANK]
				)    
				 SELECT [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[CPFCNPJ],[TipoPessoa],
				 [Nome],[DataNascimento],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG],
				 [CodigoEstadoCivil],[EstadoCivil],[CodigoSexo],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial],
				 [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar],[RendaIndividual],
				 [NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoEndereco],[Endereco],[Bairro],[Cidade],
				 [SiglaUF],[CEP],[NumeroProdutoSIGPF],[AgenciaVenda],[DiaPagamento],[DataProposta],[CodigoFormaPagamento],
				 [FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta],[ContaCorrenteDebitoConta],[DigitoDebitoConta],
				 [TipoTitular],[ValorMensalidade],[QtdeTotalTitulos],[MatriculaVendedor],[ValorTotalProposta],[PercentualDesconto],
				 [EmpresaConvenente],[CNPJEmpresaConvenente],[MatriculaConvenente],[SituacaoProposta],[SituacaoCobranca],[MotivoSituacao],
				 [CodigoPlano],[DataAutenticacaoSICOB],[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[ValorComissaoSICOB],
				 [TituloOriginarioRevenda],[OrigemProposta],[SequencialArquivo],[SequencialRegistro],[Reservado],[DataCreditoFederalCap],[TipoArquivo],
				 [RANK]
	 FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP
	'

	EXEC (@COMANDO)    

	SELECT @MaiorCodigo = MAX(PRP.Codigo)
	FROM dbo.PRPFCAP_TEMP AS PRP              

	/**********************************************************/
	/**********************************************************/
                           
	SET @COMANDO = '' 

	WHILE @MaiorCodigo IS NOT NULL
	BEGIN
	--PRINT @MaiorCodigo


	/**********************************************************************
		   Carrega os PRODUTOS SIGPF desconhecidos
	***********************************************************************/             
	;MERGE INTO Dados.ProdutoSIGPF AS T
	   USING (
				SELECT DISTINCT PRP.[NumeroProdutoSIGPF] [CodigoProduto], '' [Descricao]
				   FROM dbo.[PRPFCAP_TEMP] PRP
				   WHERE PRP.[NumeroProdutoSIGPF] IS NOT NULL
			  ) X
		ON T.CodigoProduto = X.CodigoProduto 
				WHEN NOT MATCHED
					  THEN INSERT (CodigoProduto, Descricao)
						   VALUES (X.[CodigoProduto], X.[Descricao]);


	--Carga das Situações de Proposta Desconhecidas
	/***********************************************************************
	***********************************************************************/
	MERGE INTO Dados.SituacaoProposta AS T
			USING 
				(
					SELECT DISTINCT PRP.SituacaoProposta AS [Sigla], '' [Descricao]
					FROM dbo.[PRPFCAP_TEMP] PRP
					WHERE PRP.SituacaoProposta IS NOT NULL
				) X
		ON T.[Sigla] = X.[Sigla] 
			WHEN NOT MATCHED THEN 
				INSERT (Sigla, Descricao)
				VALUES (X.[Sigla], X.[Descricao]);								  

	/***********************************************************************
		   Carregar as SITUAÇÕES de cobrança desconhecidas
	 ***********************************************************************/

	 ;MERGE INTO [Dados].[SituacaoCobranca] AS T
		  USING (
				   SELECT DISTINCT PRP.SituacaoCobranca [Sigla], '' [Descricao]
				   FROM dbo.PRPFCAP_TEMP PRP
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
				   FROM dbo.PRPFCAP_TEMP PRP
				   WHERE PRP.MotivoSituacao IS NOT NULL
				  ) X
			 ON T.[Codigo] = X.[Codigo] 
		   WHEN NOT MATCHED
					  THEN INSERT ([Codigo], [Nome])
						   VALUES (X.[Codigo], X.[Nome]);


	--Carga dos Funcionários de Proposta não Carregados
	/***********************************************************************
	***********************************************************************/
	MERGE INTO Dados.Funcionario AS T
			USING 
			(           
				SELECT DISTINCT PRP.[MatriculaVendedor] AS [Matricula],  
								1 [IDEmpresa],-- Caixa Econômica  
								MAX(tipoarquivo) AS NomeArquivo, 
								MAX(DataProposta) DataArquivo             
				FROM dbo.PRPFCAP_TEMP PRP 
				WHERE PRP.[MatriculaVendedor] IS NOT NULL --and PRP.[MatriculaVendedor] = 588938
				GROUP BY PRP.[MatriculaVendedor]
			) X
		ON T.[Matricula] = X.[Matricula] 
			AND T.IDEmpresa = X.IDEmpresa

			WHEN NOT MATCHED THEN 
				INSERT ([Matricula],IDEmpresa,NomeArquivo,DataArquivo)
				VALUES (X.[Matricula],X.IDEmpresa, X.NomeArquivo, X.DataArquivo); 		


	/*********************************************************************** 
      	   Carrega tabela FaixaRenda não inseridas (RendaIndividual) 
	***********************************************************************/

	  ;MERGE INTO Dados.FaixaRenda AS T
		   USING (           
				  SELECT DISTINCT PRP.[RendaIndividual]                
					FROM dbo.PRPFCAP_TEMP PRP 
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
				  FROM dbo.PRPFCAP_TEMP PRP 
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
	FROM dbo.PRPFCAP_TEMP CAD
	WHERE  CAD.AgenciaVenda IS NOT NULL 
	  AND not exists (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.AgenciaVenda)                  
                                                        

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					MAX([TipoArquivo]) [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					MAX([NomeArquivo]) [Arquivo]

	FROM dbo.PRPFCAP_TEMP EM
	INNER JOIN Dados.Unidade U
	ON EM.AgenciaVenda = U.Codigo
	WHERE 
		not exists (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 


	--Carga dos Dados de Proposta
	/***********************************************************************
	***********************************************************************/          
	MERGE INTO Dados.Proposta AS T
		USING 
				(
					--NumeroProdutoSIGPF,
					--AgenciaVenda,
					--DataProposta,
					--ValorTotalProposta,
					--PercentualDesconto,
					--EmpresaConvenente,
					--CNPJEmpresaConvenente,
					--MatriculaConvenente,
					--SituacaoProposta,
					--SituacaoCobranca,
					--DataAutenticacaoSICOB,
					--ValorPagoSICOB,
					--AgenciaPagamentoSICOB,
					--TarifaCobrancaSICOB,
					--ValorComissaoSICOB,
					--OrigemProposta,
					--MotivoSituacao,
					--CodigoPlano,
					--CodigoSegmento,
	
				SELECT DISTINCT 
					   PRP.NumeroProposta, 
					   SGD.ID AS IDSeguradora,
					   PRD.ID AS [IDProdutoSIGPF], 
					   PRP.DataProposta, 
					   F.ID [IDFuncionario],  
					   PRP.ValorPagoSICOB,
					   PRP.RendaIndividual, 
					   PRP.RendaFamiliar, 
					   U.ID AS [IDAgenciaVenda],
					   SP.ID AS [IDSituacaoProposta], 
					   PRP.DataArquivo, 
					   PRP.[TipoArquivo] AS TipoDado, 
					   PRP.Codigo,
					   PRP.ValorTotalProposta, 
					   PRP.[PercentualDesconto],
					   PRP.[EmpresaConvenente], 
					   PRP.[MatriculaConvenente], 
					   SB.ID [IDSituacaoCobranca],
					   TM.ID [IDTipoMotivo], 
					   PRP.[CodigoPlano], 
					   PRP.[DataAutenticacaoSICOB],
					   PRP.[AgenciaPagamentoSICOB], 
					   PRP.[TarifaCobrancaSICOB], 
					   PRP.[ValorComissaoSICOB], 
					   PRP.[OrigemProposta], 
					   PRP.[CodigoSegmento]
				FROM dbo.PRPFCAP_TEMP PRP
				INNER JOIN Dados.Seguradora SGD
				ON SGD.Codigo = PRP.IDSeguradora
				LEFT OUTER JOIN Dados.ProdutoSIGPF PRD
				ON PRD.CodigoProduto= PRP.NumeroProdutoSIGPF
				LEFT OUTER JOIN Dados.Unidade U
				ON U.Codigo = PRP.AgenciaVenda
				LEFT OUTER JOIN Dados.SituacaoProposta SP
				ON SP.Sigla = PRP.SituacaoProposta
				LEFT OUTER JOIN Dados.TipoMotivo TM
				ON TM.Codigo = PRP.MotivoSituacao
				LEFT OUTER JOIN Dados.SituacaoCobranca SB
				ON SB.Sigla = PRP.SituacaoCobranca
				LEFT OUTER JOIN Dados.Funcionario F
				ON F.[Matricula] = PRP.[MatriculaVendedor]
					AND F.IDEmpresa = 1

				WHERE [RANK] = 1
			) AS X
			ON      X.NumeroProposta = T.NumeroProposta  
				AND X.IDSeguradora = T.IDSeguradora

			WHEN MATCHED THEN 
				UPDATE
					SET IDProdutoSIGPF = COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF]),
						DataProposta = COALESCE(T.[DataProposta], X.[DataProposta]),
						IDFuncionario = COALESCE(T.[IDFuncionario], X.[IDFuncionario]),
						Valor = COALESCE(X.[ValorPagoSICOB], T.[Valor]),
						RendaIndividual = COALESCE(X.[RendaIndividual], T.[RendaIndividual]),
						RendaFamiliar = COALESCE(X.[RendaFamiliar], T.[RendaFamiliar]),
						IDAgenciaVenda = COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda]),
						IDSituacaoProposta = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta]),
						DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo]),
						TipoDado = COALESCE(X.[TipoDado], T.[TipoDado]),	
						DataSituacao = COALESCE(X.DataArquivo, T.DataSituacao),
						ValorPremioTotal = COALESCE(X.[ValorTotalProposta], T.[ValorPremioTotal]),
						EmpresaConvenente = COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente]),
						MatriculaConvenente = COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente]),
						IDSituacaoCobranca = COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca]),
						IDTipoMotivo = COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo]),
						CodigoPlano = COALESCE(X.[CodigoPlano], T.[CodigoPlano]),
						DataAutenticacaoSICOB = COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB]),
						AgenciaPagamentoSICOB = COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB]),
						TarifaCobrancaSICOB = COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB]),
						ValorComissaoSICOB = COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB]),
						OrigemProposta = COALESCE(X.[OrigemProposta], T.[OrigemProposta]),
						CodigoSegmento = COALESCE(X.[CodigoSegmento], T.[CodigoSegmento]),
						PercentualDesconto = COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
			WHEN NOT MATCHED THEN 
				INSERT (
						NumeroProposta,IDSeguradora,IDProdutoSIGPF,DataProposta,IDFuncionario,Valor,RendaIndividual,
						RendaFamiliar,IDAgenciaVenda,IDSituacaoProposta,DataArquivo,TipoDado,DataSituacao,ValorPremioTotal,
						EmpresaConvenente,MatriculaConvenente,IDSituacaoCobranca,IDTipoMotivo,CodigoPlano,DataAutenticacaoSICOB,
						AgenciaPagamentoSICOB,TarifaCobrancaSICOB,ValorComissaoSICOB,OrigemProposta,CodigoSegmento,PercentualDesconto	          
					   )
				VALUES (
						x.NumeroProposta,x.IDSeguradora,x.IDProdutoSIGPF,x.DataProposta,x.IDFuncionario,x.ValorPagoSICOB,x.RendaIndividual,
						x.RendaFamiliar,x.IDAgenciaVenda,x.IDSituacaoProposta,x.DataArquivo,x.TipoDado,x.DataArquivo,x.ValorTotalProposta,
						x.EmpresaConvenente,x.MatriculaConvenente,x.IDSituacaoCobranca,x.IDTipoMotivo,x.CodigoPlano,x.DataAutenticacaoSICOB,
						x.AgenciaPagamentoSICOB,x.TarifaCobrancaSICOB,x.ValorComissaoSICOB,x.OrigemProposta,x.CodigoSegmento,x.PercentualDesconto
					   );  
					   
	/***********************************************************************
	***********************************************************************/   
	/*Apaga a Marcação de LastValue das Propostas Recebidas*/		  

    UPDATE Dados.PropostaCapitalizacao 
	SET LastValue = 0
	FROM Dados.PropostaCapitalizacao PS
	WHERE PS.IDProposta IN 
							(
							SELECT PRP.ID
							FROM dbo.PRPFCAP_TEMP PRP_T
							INNER JOIN Dados.Proposta PRP
							ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
								AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
								--AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
							)
		AND PS.LastValue = 1

	--Carga da Tabela de Especialização - Dados.PropostaCapitalização
	/***********************************************************************
	***********************************************************************/
	MERGE INTO Dados.PropostaCapitalizacao AS T
		USING 
				( 	--IDProposta,
					--TipoTitular
					--ValorMensalidade
					--QtdeTotalTitulos
					--TituloOriginarioRevenda
					--DataCreditoFederalCap
					--TipoArquivo
					--NomeArquivo
					--DataArquivo

					--Dados.Proposta, Dados.PropostaCapitalização
				SELECT DISTINCT
					PRP1.ID AS IDProposta,
					TipoTitular,
					ValorMensalidade,
					QtdeTotalTitulos,
					TituloOriginarioRevenda,
					DataCreditoFederalCap,
					TipoArquivo,
					NomeArquivo,
					PRP.DataArquivo,
				    0 LastValue
				FROM dbo.PRPFCAP_TEMP PRP
				INNER JOIN Dados.Proposta PRP1
				ON PRP.NumeroProposta = PRP1.NumeroProposta
				and PRP1.idseguradora = PRP.IDSeguradora -- 3 - Verificar o IdSeguradora

				WHERE [RANK] = 1
			) X
		ON T.IDProposta = X.IDProposta 
		and T.DataArquivo = X.DataArquivo 
			WHEN MATCHED THEN 
				UPDATE
					SET TipoTitular = COALESCE(X.TipoTitular, T.TipoTitular),
						ValorMensalidade = COALESCE(T.ValorMensalidade, X.ValorMensalidade),
						QtdeTotalTitulos = COALESCE(T.QtdeTotalTitulos, X.QtdeTotalTitulos),
						TituloOriginarioRevenda = COALESCE(X.TituloOriginarioRevenda, T.TituloOriginarioRevenda),
						DataCreditoFederalCap = COALESCE(X.DataCreditoFederalCap, T.DataCreditoFederalCap),
						TipoArquivo = COALESCE(X.TipoArquivo, T.TipoArquivo),
						NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo),
						LastValue = X.LastValue
						--DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)
			WHEN NOT MATCHED THEN 
				INSERT (
						IDProposta,TipoTitular,ValorMensalidade,QtdeTotalTitulos,
						TituloOriginarioRevenda,DataCreditoFederalCap,TipoArquivo,NomeArquivo,DataArquivo,LastValue
					   )
				VALUES (
			
						x.IDProposta,x.TipoTitular,x.ValorMensalidade,x.QtdeTotalTitulos,
						x.TituloOriginarioRevenda,x.DataCreditoFederalCap,x.TipoArquivo,x.NomeArquivo,x.DataArquivo,X.LastValue
					   );  


/***********************************************************************/
							   
/*Atualização da Marcação de LastValue das Propostas Recebidas para Atualização da Última Posição*/

	UPDATE Dados.PropostaCapitalizacao 
		SET LastValue = 1
	FROM Dados.PropostaCapitalizacao PE
	INNER JOIN 
				(
				 SELECT ID,
						ROW_NUMBER() OVER (PARTITION BY PS.IDProposta ORDER BY PS.IDProposta ASC, PS.DataArquivo DESC) Ordem
				 FROM Dados.PropostaCapitalizacao PS
				 WHERE PS.IDProposta IN 
										 (
										SELECT PRP.ID
										FROM dbo.PRPFCAP_TEMP PRP_T
										INNER JOIN Dados.Proposta PRP
										ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
											AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
										)
				) A
		ON A.ID = PE.ID 
			AND A.ORDEM = 1 

	/***********************************************************************
		Carrega os dados do estado civil não cadastrados
	***********************************************************************/
	--select * from [Dados].[EstadoCivil]
	;MERGE INTO [Dados].[EstadoCivil] T
		USING (SELECT DISTINCT t.CodigoEstadoCivil,
								t.EstadoCivil AS Descricao
				FROM [dbo].PRPFCAP_TEMP t
				WHERE t.CodigoEstadoCivil IS NOT NULL
				) X
				ON T.ID = X.CodigoEstadoCivil
				WHEN NOT MATCHED
					  THEN INSERT (ID, Descricao)
						   VALUES (X.CodigoEstadoCivil, X.Descricao);


	/***********************************************************************
		Carrega os dados de sexo do cliente não cadastrados
	***********************************************************************/

	;MERGE INTO [Dados].[Sexo] T
		USING (SELECT DISTINCT t.CodigoSexo, 
								t.Sexo AS descricao
				FROM [dbo].PRPFCAP_TEMP t
				WHERE t.CodigoSexo IS NOT NULL AND t.Sexo IS NOT NULL
				) X
			ON T.ID = X.CodigoSexo
				WHEN NOT MATCHED
					  THEN INSERT (ID, Descricao)
						   VALUES (X.CodigoSexo, X.descricao);


/*INSERE CLIENTE NÃO LOCALIZADOS */
;MERGE INTO Dados.PropostaCliente AS T
     USING (
			SELECT DISTINCT PRP.ID [IDProposta], 
			 CASE WHEN em.Nome IS NULL OR em.Nome = '' THEN 'CLIENTE DESCONHECIDO – DADOS DO CLIENTE NÃO RECEBIDOS' 
				ELSE em.Nome END [NomeCliente], 
			 em.NomeArquivo [NomeArquivo], 
			 em.DataArquivo [DataArquivo],
			 em.[TipoArquivo] TipoDado
            FROM dbo.PRPFCAP_TEMP EM
                 INNER JOIN Dados.Proposta PRP
                     ON PRP.NumeroProposta = EM.NumeroProposta
						AND PRP.IDSeguradora = em.IDSeguradora
            WHERE em.nome is null

          ) X

           ON T.IDProposta = X.IDProposta
                WHEN NOT MATCHED
                                    THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                                           VALUES (X.IDProposta, X.TipoDado, X.[NomeCliente], X.[DataArquivo]);
	
	

	--Carga dos Dados de Cliente
	/***********************************************************************
	***********************************************************************/               
	MERGE INTO Dados.PropostaCliente AS T
			USING (
					--CPFCNPJ, 
					--TipoPessoa, 
					--Nome,
					--DataNascimento,
					--Identidade,
					--OrgaoExpedidor,
					--UFOrgaoExpedidor,
					--DataExpedicaoRG,
					--EstadoCivil,
					--Sexo,	
					--DDDComercial,
					--TelefoneComercial,
					--DDDFax,
					--TelefoneFax,
					--DDDResidencial,
					--TelefoneResidencial,
					--Email,
					--CodigoProfissao,
					--Profissao, ,
					--RendaFamiliar,
					--RendaIndividual,
					--NomeConjuge,
					--DataNascimentoConjuge,
					--ProfissaoConjuge,
	
					SELECT DISTINCT
					   PRP1.ID AS [IDProposta],
					   PRP.CPFCNPJ,           
					   PRP.Nome,              
					   PRP.DataNascimento,   
					   PRP.TipoPessoa,        
					   PRP.CodigoSexo AS [IDSexo],              
					   PRP.CodigoEstadoCivil AS [IDEstadoCivil],       
					   PRP.Identidade,        
					   PRP.OrgaoExpedidor,    
					   PRP.UFOrgaoExpedidor,  
					   PRP.DataExpedicaoRG,   
					   PRP.DDDComercial,      
					   PRP.TelefoneComercial, 
					   PRP.DDDFax,            
					   PRP.TelefoneFax,       
					   PRP.DDDResidencial,    
					   PRP.TelefoneResidencial,
					   PRP.Email,             
					   PRP.CodigoProfissao,   
					   PRP.Profissao,         
					   PRP.NomeConjuge,
					   PRP.RendaFamiliar,
					   PRP.RendaIndividual,
					   PRP.DataNascimentoConjuge,       
					   PRP.ProfissaoConjuge,                   
					   PRP.TipoArquivo AS [TipoDado],           
					   PRP.DataArquivo
				FROM dbo.PRPFCAP_TEMP PRP
				INNER JOIN Dados.Proposta PRP1
				ON PRP.NumeroProposta = PRP1.NumeroProposta
				AND PRP.IDSeguradora = PRP1.IDSeguradora -- Verificar o idSeguradora

				WHERE [RANK] = 1

				) AS X
		ON X.IDProposta = T.IDProposta
			WHEN MATCHED THEN 
					UPDATE
						SET CPFCNPJ = COALESCE(T.[CPFCNPJ], X.[CPFCNPJ]),
							Nome = COALESCE(T.[Nome], X.[Nome]),
							DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento]),
							TipoPessoa  = COALESCE(X.[TipoPessoa ], T.[TipoPessoa]),
							IDSexo = COALESCE(X.[IDSexo], T.[IDSexo]),
							IDEstadoCivil = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil]),
							Identidade = COALESCE(X.[Identidade], T.[Identidade]),
							OrgaoExpedidor = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor]),
							UFOrgaoExpedidor = COALESCE(X.[UFOrgaoExpedidor], T.[UFOrgaoExpedidor]),
							DataExpedicaoRG = COALESCE(X.[DataExpedicaoRG], T.[DataExpedicaoRG]),
							DDDComercial = COALESCE(X.[DDDComercial], T.[DDDComercial]),
							TelefoneComercial = COALESCE(X.[TelefoneComercial], T.[TelefoneComercial]),
							DDDFax = COALESCE(X.[DDDFax], T.[DDDFax]),
							TelefoneFax  = COALESCE(X.[TelefoneFax ], T.[TelefoneFax]),
							DDDResidencial = COALESCE(X.[DDDResidencial], T.[DDDResidencial]),
							TelefoneResidencial = COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial]),
							Email = COALESCE(X.[Email], T.[Email]),
							CodigoProfissao = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao]),
							Profissao = COALESCE(X.[Profissao], T.[Profissao]),
							NomeConjuge = COALESCE(X.[NomeConjuge], T.[NomeConjuge]),
							ProfissaoConjuge = COALESCE(X.[ProfissaoConjuge], T.[ProfissaoConjuge]),
							TipoDado = COALESCE(X.[TipoDado], T.[TipoDado]),
							DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])
				WHEN NOT MATCHED THEN 
					INSERT ( 
							 IDProposta,CPFCNPJ,Nome,DataNascimento,TipoPessoa,        
							 IDSexo,IDEstadoCivil,Identidade,OrgaoExpedidor,UFOrgaoExpedidor,  
							 DataExpedicaoRG,DDDComercial,TelefoneComercial, 
							 DDDFax,TelefoneFax,DDDResidencial,TelefoneResidencial,
							 Email,CodigoProfissao,Profissao,NomeConjuge,
							 ProfissaoConjuge,TipoDado, DataArquivo
							)
					VALUES (
							 X.IDProposta,X.CPFCNPJ,X.Nome,X.DataNascimento,X.TipoPessoa,        
							 X.IDSexo,X.IDEstadoCivil,X.Identidade,X.OrgaoExpedidor,X.UFOrgaoExpedidor,
							 X.DataExpedicaoRG,X.DDDComercial,X.TelefoneComercial,X.DDDFax,X.TelefoneFax,      
							 X.DDDResidencial,X.TelefoneResidencial,X.Email,X.CodigoProfissao,X.Profissao,        
							 X.NomeConjuge,X.ProfissaoConjuge,X.TipoDado,X.DataArquivo
						   );
	/***********************************************************************
	***********************************************************************/ 

	--Carga das Propostas Endereço
	/***********************************************************************
	***********************************************************************/   
	/*Apaga a Marcação de LastValue das Propostas Recebidas*/

	UPDATE Dados.PropostaEndereco 
	SET LastValue = 0
	FROM Dados.PropostaEndereco PS
	WHERE PS.IDProposta IN 
							(
							SELECT PRP.ID
							FROM dbo.PRPFCAP_TEMP PRP_T
							INNER JOIN Dados.Proposta PRP
							ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
								AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
								--AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
							)
		AND PS.LastValue = 1

	/*Merge dos Dados de Proposa Endereço*/

	MERGE INTO Dados.PropostaEndereco AS T
		USING 
				(
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
						, A.[TipoArquivo]           
						, A.DataArquivo	
						,ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco, Endereco ORDER BY A.DataArquivo DESC) NUMERADOR

					FROM
					(
						SELECT   
								PRP.ID [IDProposta]
							,TipoEndereco [IDTipoEndereco]
							,PRP_T.Endereco        
							,MAX(PRP_T.Bairro) Bairro             
							,MAX(PRP_T.Cidade) Cidade       
							,MAX(PRP_T.SiglaUF)  [UF]      
							,MAX(PRP_T.CEP) CEP   
							--CASE WHEN  
							,[TipoArquivo]           
							,MAX(PRP_T.DataArquivo) DataArquivo	   								
						FROM dbo.PRPFCAP_TEMP PRP_T
							INNER JOIN Dados.Proposta PRP
							ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
						WHERE  [RANK] = 1--PRP_T.NumeroProposta = 012984710001812
						and PRP_T.Endereco IS NOT NULL
						and PRP_T.TIPOENDERECO <> 0
						-- AND PRP.ID = 12585836
						GROUP BY PRP.ID 
								,PRP_T.TipoEndereco 
								,PRP_T.Endereco 
								,[TipoArquivo]        
	
					) A 				

			  ) AS X
		ON  X.IDProposta = T.IDProposta
			AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
			--	AND X.[DataArquivo] >= T.[DataArquivo]
			AND X.[Endereco] = T.[Endereco]
			AND NUMERADOR = 1 --Garante uma única ocorrência do mesmo endereço.

		WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
			UPDATE
				SET Endereco = COALESCE(X.[Endereco], T.[Endereco]),
					Bairro = COALESCE(X.[Bairro], T.[Bairro]),
					Cidade = COALESCE(X.[Cidade], T.[Cidade]),
					UF = COALESCE(X.[UF], T.[UF]),
					CEP = COALESCE(X.[CEP], T.[CEP]),
					TipoDado = COALESCE(X.[TipoArquivo], T.[TipoDado]),
					DataArquivo = X.DataArquivo,
					LastValue = X.LastValue
	WHEN NOT MATCHED THEN 
		INSERT ( 
				 IDProposta,IDTipoEndereco,Endereco,Bairro,Cidade,UF,CEP,TipoDado,DataArquivo,LastValue)                                            
		VALUES (
				 X.[IDProposta],X.[IDTipoEndereco],X.[Endereco],X.[Bairro],X.[Cidade],X.[UF],X.[CEP],X.[TipoArquivo],X.[DataArquivo],X.LastValue   
			   );

	/*Atualização da Marcação de LastValue das Propostas Recebidas para Atualização da Última Posição*/

	UPDATE Dados.PropostaEndereco 
		SET LastValue = 1
	FROM Dados.PropostaEndereco PE
	INNER JOIN 
				(
				 SELECT ID,
						ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) Ordem
				 FROM Dados.PropostaEndereco PS
				 WHERE PS.IDProposta IN 
										 (
										SELECT PRP.ID
										FROM dbo.PRPFCAP_TEMP PRP_T
										INNER JOIN Dados.Proposta PRP
										ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
											AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
										)
				) A
		ON A.ID = PE.ID 
			AND A.ORDEM = 1				  

	/***********************************************************************
	***********************************************************************/  


	--Inserção de Formas de Pagamentos Não Existentes
	/***********************************************************************
	***********************************************************************/
	--CodigoFormaPagamento  
	MERGE INTO Dados.FormaPagamento AS T
		USING 
				(
				 SELECT DISTINCT PRP.CodigoFormaPagamento [IDFormaPagamento], '' Descricao
				 FROM dbo.PRPFCAP_TEMP PRP
				 WHERE PRP.CodigoFormaPagamento IS NOT NULL
				) X
		ON T.ID = X.[IDFormaPagamento]
			WHEN NOT MATCHED THEN 
				INSERT (ID, Descricao)
				VALUES (X.[IDFormaPagamento], X.[Descricao]);

	/***********************************************************************
	***********************************************************************/  

	/***********************************************************************
	***********************************************************************/  

	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
		/*Diego Lima - Data: 19/12/2013 */

	UPDATE Dados.MeioPagamento SET LastValue = 0
	   -- SELECT *
		FROM Dados.MeioPagamento MP
		WHERE MP.IDProposta IN (
								SELECT PRP.ID
								FROM dbo.PRPFCAP_TEMP PRP_T
								  INNER JOIN Dados.Proposta PRP
								  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
								 AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
								-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
							   )
			   AND MP.LastValue = 1

	--Carga dos Dados de Forma de Pagamento da Proposta
	/***********************************************************************
	***********************************************************************/  
	MERGE INTO Dados.MeioPagamento AS T
		USING 
				(
					SELECT *
						FROM
							(
								--DiaPagamento,
								--FormaPagamento,
								--AgenciaDebitoConta
								--OperacaoDebitoConta,
								--ContaCorrenteDebitoConta,
								--DigitoDebitoConta

								SELECT DISTINCT
									P.ID [IDProposta], 
									PRP.DataArquivo, 
									PRP.NomeArquivo AS Arquivo,
									PRP.[FormaPagamento], 
									PRP.[CodigoFormaPagamento], 
									FP.ID AS [IDFormaPagamento], 
									'104' [Banco],
									PRP.[AgenciaDebitoConta] AS [Agencia], 
									PRP.[OperacaoDebitoConta] AS [Operacao],
									PRP.[ContaCorrenteDebitoConta] AS [ContaCorrente], 
									PRP.[DiaPagamento] AS[DiaVencimento],
									ROW_NUMBER() OVER(PARTITION BY PRP.[NumeroProposta] ORDER BY PRP.DataArquivo DESC, PRP.NomeArquivo DESC) [Order]
								FROM dbo.PRPFCAP_TEMP PRP
								INNER JOIN Dados.Proposta P
								ON P.NumeroProposta = PRP.[NumeroProposta] 
								INNER JOIN Dados.FormaPagamento FP
								ON FP.ID = PRP.[CodigoFormaPagamento]
								) A
						WHERE A.[Order] = 1
				) AS O
		ON T.[IDProposta] = O.[IDProposta]
			AND T.[DataArquivo] = O.[DataArquivo]

			WHEN MATCHED THEN 
				UPDATE 
					SET T.Operacao = COALESCE(O.Operacao, T.Operacao),
						T.[Agencia] = COALESCE(O.[Agencia], T.[Agencia]),
						T.[ContaCorrente] = COALESCE(O.[ContaCorrente], T.[ContaCorrente]),
						T.[Banco] = COALESCE(O.[Banco], T.[Banco]),
						T.[IDFormaPagamento] = COALESCE(O.[IDFormaPagamento], T.[IDFormaPagamento]),
						T.[DiaVencimento] = COALESCE(O.[DiaVencimento], T.[DiaVencimento])
			WHEN NOT MATCHED THEN 
				INSERT ([IDProposta], [DataArquivo], [Banco], [Agencia], [Operacao], [ContaCorrente], [IDFormaPagamento], [DiaVencimento])
				VALUES (O.[IDProposta], O.[DataArquivo], O.[Banco], O.[Agencia], O.[Operacao], O.[ContaCorrente], O.[IDFormaPagamento], O.[DiaVencimento]);
			    
	/***********************************************************************
	***********************************************************************/  

	/*Limpa os meios de pagamento repetidos*/
		/*Diego Lima - Data: 19/12/2013 */	
	DELETE  Dados.MeioPagamento
	FROM  Dados.MeioPagamento b
		INNER JOIN
		(
			SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.IDFormaPagamento, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
			FROM Dados.MeioPagamento PGTO
				INNER JOIN
				dbo.PRPFCAP_TEMP PRP
				INNER JOIN Dados.Proposta P
				ON P.NumeroProposta = PRP.[NumeroProposta]
				AND P.IDSeguradora = 3
				ON PGTO.IDProposta = P.ID	 
		) A
		ON   A.IDProposta = B.IDProposta
		AND A.DataArquivo = B.DataArquivo
		AND A.ordem > 1	 	
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Diego Lima - Data: 19/12/2013 */	
		 
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
						FROM dbo.PRPFCAP_TEMP PRP_T
							INNER JOIN Dados.Proposta PRP
							ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							AND PRP.IDSeguradora = PRP_T.IDSeguradora --3 - Caixa Capitalização
							AND MP.IDProposta = PRP.ID
					  )
	/***********************************************************************
	***********************************************************************/  			                             
                         
	/*Atualização do Ponto de Parada, igualando-o ao maior Código Trabalhado no Comando Acima*/
	/*************************************************************************************/
	/*************************************************************************************/
	SET @PontoDeParada = @MaiorCodigo
  
	UPDATE ControleDados.PontoParada 
	SET PontoParada = @MaiorCodigo
	WHERE NomeEntidade = 'Proposta_PRPFCAP'

	TRUNCATE TABLE [dbo].[PRPFCAP_TEMP]

	SET @COMANDO =
	'INSERT INTO [dbo].[PRPFCAP_TEMP]
				(
				 [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[CPFCNPJ],[TipoPessoa],
				 [Nome],[DataNascimento],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG],
				 [CodigoEstadoCivil],[EstadoCivil],[CodigoSexo],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial],
				 [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar],[RendaIndividual],
				 [NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoEndereco],[Endereco],[Bairro],[Cidade],
				 [SiglaUF],[CEP],[NumeroProdutoSIGPF],[AgenciaVenda],[DiaPagamento],[DataProposta],[CodigoFormaPagamento],
				 [FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta],[ContaCorrenteDebitoConta],[DigitoDebitoConta],
				 [TipoTitular],[ValorMensalidade],[QtdeTotalTitulos],[MatriculaVendedor],[ValorTotalProposta],[PercentualDesconto],
				 [EmpresaConvenente],[CNPJEmpresaConvenente],[MatriculaConvenente],[SituacaoProposta],[SituacaoCobranca],[MotivoSituacao],
				 [CodigoPlano],[DataAutenticacaoSICOB],[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[ValorComissaoSICOB],
				 [TituloOriginarioRevenda],[OrigemProposta],[SequencialArquivo],[SequencialRegistro],[Reservado],[DataCreditoFederalCap],[TipoArquivo],
				 [RANK]
				)    
				 SELECT [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[CPFCNPJ],[TipoPessoa],
				 [Nome],[DataNascimento],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG],
				 [CodigoEstadoCivil],[EstadoCivil],[CodigoSexo],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial],
				 [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar],[RendaIndividual],
				 [NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoEndereco],[Endereco],[Bairro],[Cidade],
				 [SiglaUF],[CEP],[NumeroProdutoSIGPF],[AgenciaVenda],[DiaPagamento],[DataProposta],[CodigoFormaPagamento],
				 [FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta],[ContaCorrenteDebitoConta],[DigitoDebitoConta],
				 [TipoTitular],[ValorMensalidade],[QtdeTotalTitulos],[MatriculaVendedor],[ValorTotalProposta],[PercentualDesconto],
				 [EmpresaConvenente],[CNPJEmpresaConvenente],[MatriculaConvenente],[SituacaoProposta],[SituacaoCobranca],[MotivoSituacao],
				 [CodigoPlano],[DataAutenticacaoSICOB],[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[ValorComissaoSICOB],
				 [TituloOriginarioRevenda],[OrigemProposta],[SequencialArquivo],[SequencialRegistro],[Reservado],[DataCreditoFederalCap],[TipoArquivo],
				 [RANK]
	 FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP
	'

	EXEC (@COMANDO)    

	SELECT @MaiorCodigo = MAX(PRP.Codigo)
	FROM dbo.PRPFCAP_TEMP AS PRP    

	END
	 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
		DROP TABLE [dbo].[PRPFCAP_TEMP];

	END TRY                
	BEGIN CATCH
	
	  EXEC CleansingKit.dbo.proc_RethrowError	
	 -- RETURN @@ERROR	
	END CATCH  
END