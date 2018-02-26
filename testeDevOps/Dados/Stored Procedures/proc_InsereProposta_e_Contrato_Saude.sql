

/*
	Autor: Pedro Guedes
	Data Criação: 20/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	

*/

/*******************************************************************************
	Nome: Dados.proc_InsereProposta_Saude
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_e_Contrato_Saude]
AS

BEGIN TRY	
    

--BEGIN TRAN

--DECLARE @PontoDeParada AS VARCHAR(400)
----set @PontoDeParada = 4188
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
----DECLARE @COMANDO AS NVARCHAR(max) 

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proposta_Saude_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Proposta_Saude_TEMP];


CREATE TABLE [dbo].[Proposta_Saude_TEMP](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDContrato] [bigint]   NULL,
	[IDProduto] [int] NULL,
	[IDProdutoAnterior] [int] NULL,
	[IDProdutoSIGPF] [tinyint] NULL,
	[IDSeguradora] [smallint] NOT NULL,
	[NumeroProposta] [varchar](20) NOT NULL,
	[NumeroPropostaEMISSAO] [varchar](20) NULL,
	[IDPeriodicidadePagamento] [tinyint] NULL,
	[CanalVendaPAR] [varchar] (5) NULL,
	[DataProposta] [date] NULL,
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	[IDFuncionario] [int] NULL,
	[Valor] [decimal](24, 4) NULL,
	[RendaIndividual]  [decimal](24, 4) NULL,
	[RendaFamiliar]  [decimal](24, 4) NULL,
	[IDAgenciaVenda] [smallint] NULL,
	[DataSituacao] [date] NULL,
	[IDSituacaoProposta] [int] NULL,
	[IDSituacaoCobranca] [int] NULL,
	[IDTipoMotivo] [smallint] NULL,
	[TipoDado] [varchar](80) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	--[IDCanalVenda]  AS (CONVERT([tinyint],left(coalesce([NumeroPropostaEMISSAO],[NumeroProposta]),(1)),(0))),
	[ValorPremioBrutoEmissao] [numeric](16, 2) NULL,
	[ValorPremioLiquidoEmissao] [numeric](16, 2) NULL,
	[ValorPremioBrutoCalculado] [numeric](16, 2) NULL,
	[ValorPremioLiquidoCalculado] [numeric](16, 2) NULL,
	[ValorPagoAcumulado] [numeric](16, 2) NULL,
	[ValorPremioTotal] [numeric](16, 2) NULL,
	[RenovacaoAutomatica] [varchar](1) NULL,
	[PercentualDesconto] [numeric](5, 2) NULL,
	[EmpresaConvenente] [varchar](40) NULL,
	[MatriculaConvenente] [varchar](8) NULL,
	[OpcaoCobertura] [varchar](1) NULL,
	[CodigoPlano] [varchar](4) NULL,
	[DataAutenticacaoSICOB] [date] NULL,
	[AgenciaPagamentoSICOB] [varchar](4) NULL,
	[TarifaCobrancaSICOB] [numeric](15, 2) NULL,
	[DataCreditoSASSESICOB] [date] NULL,
	[ValorComissaoSICOB] [numeric](15, 2) NULL,
	[PeriodicidadePagamento] [varchar](2) NULL,
	[OpcaoConjuge] [varchar](1) NULL,
	[OrigemProposta] [varchar](2) NULL,
	[DeclaracaoSaudeTitular] [varchar](7) NULL,
	[DeclaracaoSaudeConjuge] [varchar](7) NULL,
	[AposentadoriaInvalidez] [varchar](1) NULL,
	[CodigoSegmento] [varchar](4) NULL,
	[SubGrupo] [int] NULL,
	[Nome] [varchar] (60) NULL,
	[CepResidencial]  [varchar] (8) NULL,
	[EnderecoResidencial] [varchar] (60) NULL,
	[CNPJCPF]  [varchar] (14) NULL,
	[TipoLogradouroResidencial] [varchar](7) NULL,
	[NumeroEnderecoResidencial] [varchar] (5) NULL,
	[ComplementoEnderecoResidencial] [varchar] (50) NULL,
	[BairroResidencial] [varchar] (30) NULL,
	[CidadeResidencial] [varchar] (15) NULL,
	[EstadoResidencial] [varchar] (2) NULL,
	[DDDResidencial] [varchar] (3) NULL,
	[TelefoneResidencial] [varchar] (15) NULL,
	[EMPRESA] [varchar] (2)	NOT NULL,
	[NomeSeguradora] [varchar] (60) NOT NULL,
	[SeguradoraProtheus] [varchar] (4) NOT NULL,
	[CepCobranca]  [varchar] (8) NULL,
	[EnderecoCobranca] [varchar] (60) NULL,
	[TipoLogradouroCobranca] [varchar](7) NULL,
	[NumeroEnderecoCobranca] [varchar] (5) NULL,
	[ComplementoEnderecoCobranca] [varchar] (50) NULL,
	[BairroCobranca] [varchar] (30) NULL,
	[CidadeCobranca] [varchar] (15) NULL,	
	[EstadoCobranca] [varchar] (2) NULL,
	[DDDCobranca] [varchar] (3) NULL,
	[TelefoneCobranca] [varchar] (15) NULL,
	[CepCorrespondencia]  [varchar] (8) NULL,
	[EnderecoCorrespondencia] [varchar] (60) NULL,
	[TipoLogradouroCorrespondencia] [varchar](7) NULL,
	[NumeroEnderecoCorrespondencia] [varchar] (5) NULL,
	[ComplementoEnderecoCorrespondencia] [varchar] (50) NULL,
	[BairroCorrespondencia] [varchar] (30) NULL,
	[CidadeCorrespondencia] [varchar] (15) NULL,	
	[EstadoCorrespondencia] [varchar] (2) NULL,
	[DDDCorrespondencia] [varchar] (3) NULL,
	[TelefoneCorrespondencia] [varchar] (15) NULL,
	[Email] [varchar] (120) NULL,
	[EmailComercial] [varchar] (120) NULL,
	[SegmentoProtheus] [varchar] (4) NOT NULL,
	[CodigoFormaPagamento] [varchar] (4) NOT NULL,
	[Banco] [smallint] NOT NULL,
	[Agencia] [varchar] (10) NOT NULL,
	[Operacao] [varchar] (10) NOT NULL,
	[ContaCorrente] [varchar] (20) NOT NULL,
	[DiaVencimento] [tinyint],
	[CodigoRamoPAR]  [varchar] (2) NOT NULL,
	[NumeroContrato] [varchar] (20) NULL,
	[Coparticipacao] [int] NULL,
	[IDTipoAdesao] [int] NULL,
	[DataNascimento] [date] NULL,
	[IDSexo] [tinyint] NULL,
	[IDEstadoCivil] [tinyint] NULL,
	[Identidade] [varchar] (15) NULL,
	[OrgaoExpedidor] [varchar] (5) NULL,
	[DataExpedicaoRG] [date] NULL,
	[DescricaoSegmento] [varchar] (30) NULL,
	[DescricaoCanal] [varchar] (30) NULL,
	[StatusProposta] [int] NOT NULL,
	[NomeCanal] [varchar] (20) NOT NULL,
	--,US_XTIPLOG as TipoLogradouroCobranca,
	--[US_BAIRRO] [varchar] (5) NULL,
	----[US_BAIRRO] [varchar] (5) NULL,
	--NULL AS DataNascimento,
	--							NULL AS Sexo,
	--							NULL AS EstadoCivil,
	--							NULL as Identidade,
	--							NULL as OrgaoExpedidor,
	--							NULL as DataExpedicaoRG
	--[US_BAIRRO] [varchar] (5) NULL,
	--[US_BAIRRO] [varchar] (5) NULL,
	--[US_BAIRRO] [varchar] (5) NULL,
	--[US_BAIRRO] [varchar] (5) NULL,
	--[US_BAIRRO] [varchar] (5) NULL,
	--[US_BAIRRO] [varchar] (5) NULL

 CONSTRAINT [PK_PROPOSTA_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

ALTER TABLE [dbo].[Proposta_Saude_TEMP] ADD  CONSTRAINT [DF_Proposta_Saude_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroProposta_Saude_TEMP ON [dbo].Proposta_Saude_TEMP
( 
  NumeroProposta ASC
)       





/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)= '0'
--DECLARE @MaiorCodigo AS bigint
--SET @COMANDO = '
--SELECT * FROM [dbo].[Proposta_Saude_TEMP] where NumeroProposta like '%000000000003%'
--DELETE FROM Dados.Proposta
--DELETE FROM Dados.PropostaEndereco
--DELETE FROM Dados.Proposta
--DELETE FROM Dados.Proposta


INSERT into [dbo].[Proposta_Saude_TEMP] ( 
				[IDContrato] ,
				[IDSeguradora] ,
				[NumeroProposta] ,
				[NumeroPropostaEMISSAO] ,
				[IDProduto] ,
				[IDProdutoAnterior] ,
				[IDProdutoSIGPF] ,
				[IDPeriodicidadePagamento],
				[CanalVendaPAR] ,
				[DataProposta],
				[DataInicioVigencia],
				[DataFimVigencia],
				[IDFuncionario],
				[Valor],
				[RendaIndividual],
				[RendaFamiliar] ,
				[IDAgenciaVenda] ,
				[DataSituacao],
				[IDSituacaoProposta],
				[IDSituacaoCobranca],
				[IDTipoMotivo],
				[TipoDado],
				[DataArquivo],
				[ValorPremioBrutoEmissao],
				[ValorPremioLiquidoEmissao] ,
				[ValorPremioBrutoCalculado] ,
				[ValorPremioLiquidoCalculado],
				[ValorPagoAcumulado],
				[ValorPremioTotal],
				[RenovacaoAutomatica],
				[PercentualDesconto],
				[EmpresaConvenente] ,
				[MatriculaConvenente],
				[OpcaoCobertura],
				[CodigoPlano],
				[DataAutenticacaoSICOB],
				[AgenciaPagamentoSICOB],
				[TarifaCobrancaSICOB],
				[DataCreditoSASSESICOB],
				[ValorComissaoSICOB],
				[PeriodicidadePagamento],
				[OpcaoConjuge],
				[OrigemProposta] ,
				[DeclaracaoSaudeTitular],
				[DeclaracaoSaudeConjuge],
				[AposentadoriaInvalidez],
				[CodigoSegmento],
				[SubGrupo],
				[Nome],
				[CepResidencial],
				[EnderecoResidencial],
				[CNPJCPF],
				[TipoLogradouroResidencial],
				[NumeroEnderecoResidencial],
				[ComplementoEnderecoResidencial],
				[BairroResidencial],
				[CidadeResidencial],
				[EstadoResidencial],
				[DDDResidencial],
				[TelefoneResidencial],
				[EMPRESA],
				[SeguradoraProtheus],
				[NomeSeguradora],
				[CepCobranca],
				[EnderecoCobranca],
				[TipoLogradouroCobranca],
				[NumeroEnderecoCobranca],
				[ComplementoEnderecoCobranca],
				[BairroCobranca],
				[CidadeCobranca],	
				[EstadoCobranca],
				[DDDCobranca],
				[TelefoneCobranca],
				[CepCorrespondencia],
				[EnderecoCorrespondencia],
				[TipoLogradouroCorrespondencia],
				[NumeroEnderecoCorrespondencia],
				[ComplementoEnderecoCorrespondencia],
				[BairroCorrespondencia],
				[EstadoCorrespondencia],
				[CidadeCorrespondencia],	
				[DDDCorrespondencia],
				[TelefoneCorrespondencia],
				[Email],
				[EmailComercial],
				[SegmentoProtheus],
				[CodigoFormaPagamento],
				[Banco],
				[Agencia],
				[ContaCorrente],
				[Operacao],
				[DiaVencimento],
				[CodigoRamoPAR],
				[NumeroContrato],
				[Coparticipacao],
				[IDTipoAdesao],
				[DataNascimento],
				[IDSexo],
				[IDEstadoCivil],
				[Identidade],
				[OrgaoExpedidor],
				[DataExpedicaoRG],
				[DescricaoSegmento],
				[DescricaoCanal],
				[StatusProposta],
				[NomeCanal]
				) exec [Dados].[proc_RecuperaProposta_e_Contrato_Saude]
	


 /**********************************************************************
       Carrega os segmentos não conhecidos
 ***********************************************************************/  
            
;MERGE INTO Dados.SegmentoSaude AS T
	 USING (SELECT DISTINCT Cast(t.[CodigoSegmento] as Int) as Segmento ,DescricaoSegmento
               FROM [dbo].[Proposta_Saude_TEMP] t
              ) X
       ON T.[Codigo] = X.Segmento
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, Nome)
		               VALUES (X.Segmento, X.DescricaoSegmento);
--Select * from Dados.SegmentoSaude


/**********************************************************************
       Carrega os canais de venda não conhecidos
	   SELECT * FROM Dados.CanalVendaPARSaude
 ***********************************************************************/  
            
;MERGE INTO Dados.CanalVendaPARSaude AS T
	 USING (SELECT DISTINCT CanalVendaPAR ,DescricaoCanal
               FROM [dbo].[Proposta_Saude_TEMP] t
              ) X
       ON T.[Codigo] = X.CanalVendaPAR
       WHEN NOT MATCHED
		          THEN INSERT (Codigo,IDCanalMestre,DigitoIdentificador,ProdutoIdentificador,MatriculaVendedorIdentificadora,VendaAgencia,CodigoHierarquico,DataInicio, Nome)
		               VALUES (X.CanalVendaPAR,0,0,0,0,0,0,cast('2010-01-01' as date) ,X.DescricaoCanal);
--Select * from Dados.Seguradora




 /**********************************************************************
       Carrega as Seguradoras não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.Seguradora AS T
	 USING (SELECT DISTINCT case when cast(t.[SeguradoraProtheus] as int) = 1 then 7
			when cast(t.[SeguradoraProtheus] as int) = 2 then 14
			when cast(t.[SeguradoraProtheus] as int) = 3 then 15
			when cast(t.[SeguradoraProtheus] as int) = 4 then 16
			when cast(t.[SeguradoraProtheus] as int) = 10 then 998
			end
		  as SeguradoraProtheus2, t.NomeSeguradora as [Descricao]
               FROM [dbo].[Proposta_Saude_TEMP] t
              ) X
       ON T.[Codigo] = X.SeguradoraProtheus2
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, Nome)
		               VALUES (SeguradoraProtheus2, X.[Descricao]);
--Select * from Dados.Seguradora

/***********************************************************************
     Carregar as situações das propostas não cadastradas
***********************************************************************/

--; MERGE INTO [Dados].[SituacaoProposta] T
--	USING (SELECT DISTINCT t.Situacao, t.Sigla
--			FROM [dbo].[Proposta_Saude_TEMP] t
--			WHERE t.Sigla IS NOT NULL
--			) X
--		ON T.[Sigla] = X.[Sigla] 
--       WHEN NOT MATCHED
--		          THEN INSERT (Sigla, Descricao)
--		               VALUES (X.[Sigla], X.SITUACAO);

/***********************************************************************
     Carregar os dados da Proposta
***********************************************************************/

;MERGE INTO Dados.Proposta AS T
		USING (
				SELECT IDContrato,
						 IDSeguradora,
						NumeroProposta as NumeroProposta, --INSERIR TAMBÉM A SUB
						NumeroPropostaEMISSAO as NumeroPropostaEMISSAO, --INSERIR TAMBÉM A SUB
						IDProduto,
						IDProdutoAnterior,
						IDProdutoSIGPF,
						IDPeriodicidadePagamento, --MENSAL
						DataProposta,
						DataInicioVigencia,
						DataFimVigencia,
						IDFuncionario,
						Valor,
						RendaIndividual,
						RendaFamiliar,
						IDAgenciaVenda,
						DataSituacao,
						IDSituacaoProposta,
						IDSituacaoCobranca,
						IDTipoMotivo,
						TipoDado,
						DataArquivo,
						ValorPremioBrutoEmissao,
						ValorPremioLiquidoEmissao,
						ValorPremioBrutoCalculado,
						ValorPremioLiquidoCalculado,
						ValorPagoAcumulado,
						ValorPremioTotal,
						RenovacaoAutomatica, --verificar.....
						PercentualDesconto,
						EmpresaConvenente,
						MatriculaConvenente,
						OpcaoCobertura,
						CodigoPlano,
						DataAutenticacaoSICOB,
						AgenciaPagamentoSICOB,
						TarifaCobrancaSICOB,
						DataCreditoSASSESICOB,
						ValorComissaoSICOB,
						PeriodicidadePagamento,
						OpcaoConjuge,
						OrigemProposta,
						DeclaracaoSaudeTitular,
						DeclaracaoSaudeConjuge,
						AposentadoriaInvalidez,
						CodigoSegmento,
						SubGrupo
														
					FROM [dbo].[Proposta_Saude_TEMP] t
					
					
						----INNER JOIN [Dados].SituacaoProposta sp
						----	ON t.Sigla = sp.Sigla

						----INNER JOIN [Dados].[ProdutoSIGPF] p
						---- ON  p.CodigoProduto = '93' /*Fixo pois o máquina de vendas só comercializa o vida exclusivo.
						----                       Caso o máquina de vendas passe a vender outros produtos, todos
						----					    os códigos de produtos, assim como o código do produto armazenado no máquina de vendas deverão ser revisados*/--t.CodigoProduto = p.CodigoProduto 

						--INNER JOIN [Dados].[Funcionario] f
						--on f.Matricula = t.MatriculaVendedor
						--AND F.IDEmpresa = 3
						----and t.numeroproposta ='029993939999817'
					--WHERE [RANK] = 1
			) AS X
	 ON X.NumeroProposta  = T.NumeroProposta  COLLATE Latin1_General_CI_AS
   AND T.IDSeguradora = X.[IDSeguradora]

		WHEN MATCHED
			    THEN UPDATE
					SET
						 [IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato])
						,[IDSeguradora]= COALESCE(X.[IDSeguradora], T.[IDSeguradora])
						,[NumeroProposta]= COALESCE(X.[NumeroProposta], T.[NumeroProposta])
						,[NumeroPropostaEMISSAO]= COALESCE(X.[NumeroPropostaEMISSAO], T.[NumeroPropostaEMISSAO])
						,[IDProduto]= COALESCE(X.[IDProduto], T.[IDProduto])
						,[IDProdutoAnterior]= COALESCE(X.[IDProdutoAnterior], T.[IDProdutoAnterior])
						,[IDProdutoSIGPF]= COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF])
						,[IDPeriodicidadePagamento]= COALESCE(X.[IDPeriodicidadePagamento], T.[IDPeriodicidadePagamento])
						,[DataProposta] = COALESCE(X.[DataProposta], T.[DataProposta])
						,[DataInicioVigencia]= COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
					    ,[DataFimVigencia]= COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
					    ,[IDFuncionario]= COALESCE(X.[IDFuncionario], T.[IDFuncionario])
					    ,[Valor]= COALESCE(X.[Valor], T.[Valor])
					    ,[RendaIndividual] = COALESCE(X.[RendaIndividual], T.[RendaIndividual])
					    ,[RendaFamiliar]= COALESCE(X.[RendaFamiliar], T.[RendaFamiliar])
					    ,[IDAgenciaVenda]= COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda])
					    ,[DataSituacao]= COALESCE(X.[DataSituacao], T.[DataSituacao])
					    ,[IDSituacaoProposta]= COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
					    ,[IDSituacaoCobranca]= COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
					    ,[IDTipoMotivo]= COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo])
					    ,[TipoDado]= COALESCE(X.[TipoDado], T.[TipoDado])
					    ,[DataArquivo]= COALESCE(X.[DataArquivo], T.[DataArquivo])
					       ,[ValorPremioBrutoEmissao]= COALESCE(X.[ValorPremioBrutoEmissao], T.[ValorPremioBrutoEmissao])
					    ,[ValorPremioLiquidoEmissao]= COALESCE(X.[ValorPremioLiquidoEmissao], T.[ValorPremioLiquidoEmissao])
					    ,[ValorPremioBrutoCalculado]= COALESCE(X.[ValorPremioBrutoCalculado], T.[ValorPremioBrutoCalculado])
					    ,[ValorPremioLiquidoCalculado]= COALESCE(X.[ValorPremioLiquidoCalculado], T.[ValorPremioLiquidoCalculado])
					    ,[ValorPagoAcumulado]= COALESCE(X.[ValorPagoAcumulado], T.[ValorPagoAcumulado])
					    ,[ValorPremioTotal]= COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
					    ,[RenovacaoAutomatica]= COALESCE(X.[RenovacaoAutomatica], T.[RenovacaoAutomatica])
					    ,[PercentualDesconto]= COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
					    ,[EmpresaConvenente]= COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente])
					    ,[MatriculaConvenente]= COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente])
					    ,[OpcaoCobertura]= COALESCE(X.[OpcaoCobertura], T.[OpcaoCobertura])
					    ,[CodigoPlano]= COALESCE(X.[CodigoPlano], T.[CodigoPlano])
					    ,[DataAutenticacaoSICOB]= COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB])
					    ,[AgenciaPagamentoSICOB]= COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB])
					    ,[TarifaCobrancaSICOB]= COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB])
					    ,[DataCreditoSASSESICOB]= COALESCE(X.[DataCreditoSASSESICOB], T.[DataCreditoSASSESICOB])
					    ,[ValorComissaoSICOB]= COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB])
					    ,[PeriodicidadePagamento]= COALESCE(X.[PeriodicidadePagamento], T.[PeriodicidadePagamento])
					    ,[OpcaoConjuge]= COALESCE(X.[OpcaoConjuge], T.[OpcaoConjuge])
					    ,[OrigemProposta]= COALESCE(X.[OrigemProposta], T.[OrigemProposta])
					    ,[DeclaracaoSaudeTitular]= COALESCE(X.[DeclaracaoSaudeTitular], T.[DeclaracaoSaudeTitular])
					    ,[DeclaracaoSaudeConjuge]= COALESCE(X.[DeclaracaoSaudeConjuge], T.[DeclaracaoSaudeConjuge])
					    ,[AposentadoriaInvalidez]= COALESCE(X.[AposentadoriaInvalidez], T.[AposentadoriaInvalidez])
					    ,[CodigoSegmento]= COALESCE(X.[CodigoSegmento], T.[CodigoSegmento])
						,[SubGrupo]= COALESCE(X.[SubGrupo],T.[SubGrupo])
			WHEN NOT MATCHED
				THEN INSERT
							(	
							    [IDContrato]
							   ,[IDSeguradora]
							   ,[NumeroProposta]
							   ,[NumeroPropostaEMISSAO]
							   ,[IDProduto]
							   ,[IDProdutoAnterior]
							   ,[IDProdutoSIGPF]
							   ,[IDPeriodicidadePagamento]
							   ,[DataProposta]
							   ,[DataInicioVigencia]
							   ,[DataFimVigencia]
							   ,[IDFuncionario]
							   ,[Valor]
							   ,[RendaIndividual]
							   ,[RendaFamiliar]
							   ,[IDAgenciaVenda]
							   ,[DataSituacao]
							   ,[IDSituacaoProposta]
							   ,[IDSituacaoCobranca]
							   ,[IDTipoMotivo]
							   ,[TipoDado]
							   ,[DataArquivo]
							   ,[ValorPremioBrutoEmissao]
							   ,[ValorPremioLiquidoEmissao]
							   ,[ValorPremioBrutoCalculado]
							   ,[ValorPremioLiquidoCalculado]
							   ,[ValorPagoAcumulado]
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
							   ,[CodigoSegmento]
							   ,[SubGrupo]
							)

     VALUES (			X.[IDContrato], 
						X.[IDSeguradora],
						X.[NumeroProposta],
						X.[NumeroPropostaEMISSAO],
						X.[IDProduto],
						X.[IDProdutoAnterior],
						X.[IDProdutoSIGPF],
						X.[IDPeriodicidadePagamento],
						X.[DataProposta], 
						X.[DataInicioVigencia], 
					    X.[DataFimVigencia],
					    X.[IDFuncionario], 
					    X.[Valor], 
					    X.[RendaIndividual], 
					    X.[RendaFamiliar], 
					    X.[IDAgenciaVenda],
					    X.[DataSituacao], 
					    X.[IDSituacaoProposta],
					    X.[IDSituacaoCobranca], 
					    X.[IDTipoMotivo], 
					    X.[TipoDado], 
					    X.[DataArquivo], 
					    X.[ValorPremioBrutoEmissao], 
					    X.[ValorPremioLiquidoEmissao],
					    X.[ValorPremioBrutoCalculado], 
					    X.[ValorPremioLiquidoCalculado],
					    X.[ValorPagoAcumulado], 
					    X.[ValorPremioTotal],
					    X.[RenovacaoAutomatica], 
					    X.[PercentualDesconto],
					    X.[EmpresaConvenente], 
					    X.[MatriculaConvenente], 
					    X.[OpcaoCobertura], 
					    X.[CodigoPlano], 
					    X.[DataAutenticacaoSICOB], 
					    X.[AgenciaPagamentoSICOB], 
					    X.[TarifaCobrancaSICOB], 
					    X.[DataCreditoSASSESICOB], 
					    X.[ValorComissaoSICOB], 
					    X.[PeriodicidadePagamento], 
					    X.[OpcaoConjuge], 
					    X.[OrigemProposta], 
					    X.[DeclaracaoSaudeTitular], 
					    X.[DeclaracaoSaudeConjuge],
					    X.[AposentadoriaInvalidez], 
						x.[CodigoSegmento],
						x.[SubGrupo]);




/***********************************************************************
    Carrega os dados do Cliente da proposta
	SELECT * FROM Dados.PropostaCliente
***********************************************************************/
---revisar!!!!!
;MERGE INTO Dados.PropostaCliente AS T
		USING (
				SELECT  DISTINCT prp.id as [IDProposta],
								 t.cnpjCPF as [CPFCNPJ],
								t.nome as [Nome],
								 [DataNascimento],
								Case When t.EMPRESA = '03' 
										AND t.SegmentoProtheus = '0001' AND t.SeguradoraProtheus = '0004'
												 Then 'Pessoa Jurídica' 
									When t.EMPRESA = '03' AND t.SeguradoraProtheus = '0004' 
										AND  t.SegmentoProtheus <> '0001'
												Then 'Pessoa Física'
									When t.EMPRESA = '04' then 'Pessoa Jurídica' 
									Else 'Pessoa Física'
								End as [TipoPessoa],
								t.[IDSexo],
								t.IDEstadoCivil, 
								t.Identidade [Identidade],
								[OrgaoExpedidor],
								NULL [UFOrgaoExpedidor],
								t.[DataExpedicaoRG],
								--T.telcomercial,
								[DDDCobranca],
								Left([TelefoneCobranca],9) AS [TelefoneCobranca],
								--t.telfax,
								null as [DDDFax],
								null as [TelefoneFax],
								--t.telresidencial,
								[DDDResidencial],
								Left([TelefoneResidencial],9) AS [TelefoneResidencial],
								LEFT(t.Email,50) as [Email],
								null as [CodigoProfissao],
								null as [Profissao],
								null as [NomeConjuge],
								null as [ProfissaoConjuge],
								'SAUDE' as [TipoDado],
								t.DataProposta as [DataArquivo],
								LEFT(t.EmailComercial,50) AS [EmailComercial],
								--T.TelCelular,
								NULL as [DDDCelular],
							    NULL as [TelefoneCelular],
								NULL as [CPFConjuge],
								NULL as [SexoConjuge],
								NULL as [DataNascimentoConjuge],
								NULL as [CodigoProfissaoConjuge],
								NULL as [Matricula]

					FROM [dbo].[Proposta_Saude_TEMP] t
						INNER JOIN Dados.Proposta PRP
							ON t.NumeroProposta = PRP.NumeroProposta 
								AND PRP.IDSeguradora = t.IDSeguradora
						where Nome IS NOT NULL
							
						--	and PRP.id= 10084193
			) AS X
			ON X.IDProposta = T.IDProposta
			--and t.idproposta = 10084193
			WHEN MATCHED
			    THEN UPDATE
				     SET CPFCNPJ = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
					   , Nome = COALESCE(X.[Nome], T.[Nome])
					   , DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento])
					   , TipoPessoa  = COALESCE(X.[TipoPessoa ], T.[TipoPessoa])
					   , IDSexo = COALESCE(X.[IDSexo], T.[IDSexo])
					   , IDEstadoCivil = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil])
					   , Identidade = COALESCE(X.[Identidade], T.[Identidade])
					   , OrgaoExpedidor = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor])
					   , UFOrgaoExpedidor = COALESCE(X.[UFOrgaoExpedidor], T.[UFOrgaoExpedidor])
					   , DataExpedicaoRG = COALESCE(X.[DataExpedicaoRG], T.[DataExpedicaoRG])
					   , DDDComercial = RTRIM(COALESCE(X.[DDDCobranca], T.[DDDComercial]))
					   , TelefoneComercial = RTRIM(COALESCE(X.[TelefoneCobranca], T.[TelefoneComercial]))
					   , DDDFax = COALESCE(X.[DDDFax], T.[DDDFax])
					   , TelefoneFax  = COALESCE(X.[TelefoneFax ], T.[TelefoneFax])
					   , DDDResidencial = RTRIM(COALESCE(X.[DDDResidencial], T.[DDDResidencial]))
					   , TelefoneResidencial = RTRIM(COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial]))
					   , Email = LEFT(COALESCE(X.[Email], T.[Email]),50)
					   , CodigoProfissao = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao])
					   , Profissao = COALESCE(X.[Profissao], T.[Profissao])
					   , NomeConjuge = COALESCE(X.[NomeConjuge], T.[NomeConjuge])
					   , ProfissaoConjuge = COALESCE(X.[ProfissaoConjuge], T.[ProfissaoConjuge])
					   , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
					   , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])
					   , EmailComercial = LEFT(COALESCE(X.EmailComercial, T.EmailComercial) ,50)
					   , DDDCelular = COALESCE(X.DDDCelular, T.DDDCelular) 
					   , TelefoneCelular = COALESCE(X.TelefoneCelular, T.TelefoneCelular) 
					   , CPFConjuge = COALESCE(X.CPFConjuge, T.CPFConjuge) 
					   , IDSexoConjuge = COALESCE(X.SexoConjuge, T.IDSexoConjuge) 
					   , DataNascimentoConjuge = COALESCE(X.DataNascimentoConjuge, T.DataNascimentoConjuge) 
					   , CodigoProfissaoConjuge = COALESCE(X.CodigoProfissaoConjuge, T.CodigoProfissaoConjuge) 
					   , Matricula = COALESCE(X.Matricula, T.Matricula) 
		 WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, CPFCNPJ, Nome, DataNascimento, TipoPessoa        
              , IDSexo, IDEstadoCivil, Identidade, OrgaoExpedidor, UFOrgaoExpedidor  
              , DataExpedicaoRG, DDDComercial, TelefoneComercial 
              , DDDFax, TelefoneFax, DDDResidencial, TelefoneResidencial
              , Email, CodigoProfissao, Profissao, NomeConjuge, ProfissaoConjuge                   
              , TipoDado, DataArquivo, EmailComercial, DDDCelular, TelefoneCelular, CPFConjuge, 
			  IDSexoConjuge, DataNascimentoConjuge, CodigoProfissaoConjuge, Matricula)
          VALUES (X.IDProposta        
                 ,X.CPFCNPJ           
                 ,X.Nome              
                 ,X.DataNascimento    
                 ,X.TipoPessoa        
                 ,X.IDSexo              
                 ,X.IDEstadoCivil       
                 ,X.Identidade        
                 ,X.OrgaoExpedidor    
                 ,X.UFOrgaoExpedidor  
                 ,X.DataExpedicaoRG   
                 ,RTRIM(X.DDDCobranca)     
				 ,RTRIM(X.TelefoneCobranca)
                 ,RTRIM(X.DDDFax)            
                 ,RTRIM(X.TelefoneFaX)
                 ,RTRIM(X.DDDResidencial)    
                 ,RTRIM(X.TelefoneResidencial)
                 ,LEFT(X.Email,50)
                 ,X.CodigoProfissao   
                 ,X.Profissao         
                 ,X.NomeConjuge       
                 ,X.ProfissaoConjuge                   
                 ,X.TipoDado          
                 ,X.DataArquivo
				 ,LEFT(X.EmailComercial,50)
				 ,X.DDDCelular
				 ,X.TelefoneCelular
				 ,X.CPFConjuge
				 ,X.SexoConjuge
				 ,X.DataNascimentoConjuge
				 ,X.CodigoProfissaoConjuge
				 ,X.Matricula
                 );

/***********************************************************************
    Atualiza o Last Value
***********************************************************************/

 UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM [dbo].[Proposta_Saude_TEMP] t
							  INNER JOIN Dados.Proposta PRP
							  ON T.[NumeroProposta] = PRP.NumeroProposta
							-- AND PRP.IDSeguradora = 1
							-- WHERE [Rank] = 1
							-- AND T.[DataProposta] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
		   --AND PS.TipoDado = 'CSVE'

 /***********************************************************************
		Carrega os dados do Cliente endereco da proposta

 ***********************************************************************/ 

;MERGE INTO  Dados.PropostaEndereco AS T
		USING ( SELECT  A. [IDProposta],
						A.[IDTipoEndereco]
						,A.Endereco        
						,A.Bairro              
						,A.Cidade       
						,A.[UF]      
						,A.CEP    
						--,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco ORDER BY A.DataArquivo DESC) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
						--					ELSE 0
						--	END) LastValue
						, 0 LastValue
						, A.[TipoDado]           
						, A.DataArquivo	
						,ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco, Endereco ORDER BY A.DataArquivo DESC) NUMERADOR
			FROM ( 
						SELECT prp.id as [IDProposta],
								2 as [IDTipoEndereco],
								rTrim([EnderecoCorrespondencia])  as Endereco,
								t.[BairroCorrespondencia] as Bairro,
								t.[CidadeCorrespondencia] as Cidade,
								t.[EstadoCorrespondencia] as UF,
								t.[CepCorrespondencia] as CEP,
								'SAUDE' as [TipoDado],
								t.DataProposta as [DataArquivo]
							FROM [dbo].[Proposta_Saude_TEMP] t
								INNER JOIN Dados.Proposta PRP
									on t.NumeroProposta = PRP.NumeroProposta 
										and PRP.IDSeguradora = t.IDSeguradora
								WHERE Len([EnderecoCorrespondencia]) > 0
								Union
								SELECT prp.id as [IDProposta],
								1 as [IDTipoEndereco],
								rTrim([EnderecoResidencial]) as Endereco,
								t.[BairroResidencial] as Bairro,
								t.[CidadeResidencial] as Cidade,
								t.[EstadoResidencial] as UF,
								t.[CepResidencial] as CEP,
								'SAUDE' as [TipoDado],
								t.DataProposta as [DataArquivo]
							FROM [dbo].[Proposta_Saude_TEMP] t
								INNER JOIN Dados.Proposta PRP
									on t.NumeroProposta = PRP.NumeroProposta 
										and PRP.IDSeguradora = t.IDSeguradora
									WHERE Len([EnderecoResidencial]) > 0
								Union
								SELECT prp.id as [IDProposta],
								4 as [IDTipoEndereco],
								rTrim([EnderecoCobranca]) as Endereco,
								t.[BairroCobranca] as Bairro,
								t.[CidadeCobranca] as Cidade,
								t.[EstadoCobranca] as UF,
								t.[CepCobranca] as CEP,
								'SAUDE' as [TipoDado],
								t.DataProposta as [DataArquivo]
							FROM [dbo].[Proposta_Saude_TEMP] t
								INNER JOIN Dados.Proposta PRP
									on t.NumeroProposta = PRP.NumeroProposta 
										and PRP.IDSeguradora = t.IDSeguradora
								

							WHERE Len([EnderecoCobranca]) > 0

						) as A
			) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
	AND NUMERADOR = 1 --Garante uma única ocorrência do mesmo endereço.
	WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
		      UPDATE
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
/*Pedro - Data: 18/10/2013 */		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].[Proposta_Saude_TEMP] t
										  INNER JOIN Dados.Proposta PRP
										  ON t.[NumeroProposta] = PRP.NumeroProposta
										-- AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	

 /***********************************************************************
        Comando para inserir Formas de pagamento não existentes
		SELECT * FROM DADOS.FORMAPAGAMENTO
 ***********************************************************************/ 

--;MERGE INTO [Dados].[FormaPagamento] T
--	USING (SELECT distinct t.CodigoFormaPagamento, '' AS Descricao 
--			FROM [dbo].[Proposta_Saude_TEMP] t 
--				WHERE t.CodigoFormaPagamento IS NOT NULL
--			) X
--		ON T.ID = X.CodigoFormaPagamento
--       WHEN NOT MATCHED
--		          THEN INSERT (ID, Descricao)
--		               VALUES (X.CodigoFormaPagamento, X.[Descricao]);

-----------------------------------------------------------------------------------------------------------------------               
		                 
	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
	
    UPDATE Dados.MeioPagamento SET LastValue = 0
   -- SELECT * FROM DADOS.MEIOPAGAMENTO
    FROM Dados.MeioPagamento MP
    WHERE MP.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.[Proposta_Saude_TEMP] PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
				--			 AND PRP.IDSeguradora = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND MP.LastValue = 1 


  /***********************************************************************
       Carrega os dados da meio Pagamento da Proposta
   ***********************************************************************/ 
	  
;MERGE INTO Dados.MeioPagamento AS T
	 USING ( 
			SELECT *
					FROM
						(
							SELECT DISTINCT
											P.ID [IDProposta],
											t.DataProposta as [DataArquivo],
											t.CodigoFormaPagamento as [IDFormaPagamento],
											[Banco],
											t.Agencia,
											t.Operacao,
											t.ContaCorrente as [ContaCorrente],
											t.diavencimento as [DiaVencimento],
										    ROW_NUMBER() OVER(PARTITION BY t.[NumeroProposta] ORDER BY t.dataproposta DESC) [ORDER]
							FROM [dbo].[Proposta_Saude_TEMP] t 
								INNER JOIN Dados.Proposta P
									ON P.NumeroProposta = t.[NumeroProposta] AND P.IDSeguradora = t.IDSeguradora
								--	AND P.IDSeguradora = 1           
						) A 
				WHERE A.[ORDER] = 1
		    ) AS O
		ON 
		      T.[IDProposta] = O.[IDProposta]
		  AND T.[DataArquivo] = O.[DataArquivo]
	    WHEN MATCHED
		    THEN UPDATE 
			    SET  T.Operacao = COALESCE(O.Operacao, T.Operacao)
             , T.[Agencia] = COALESCE(O.[Agencia], T.[Agencia])
             , T.[ContaCorrente] = COALESCE(O.[ContaCorrente], T.[ContaCorrente])
             , T.[Banco] = COALESCE(O.[Banco], T.[Banco])
             , T.[IDFormaPagamento] = COALESCE(O.[IDFormaPagamento], T.[IDFormaPagamento])
             , T.[DiaVencimento] = COALESCE(O.[DiaVencimento], T.[DiaVencimento])
			 ,T.[LastValue] = 1
	    WHEN NOT MATCHED
		    THEN INSERT ([IDProposta], [DataArquivo], [Banco], [Agencia], [Operacao], [ContaCorrente], [IDFormaPagamento], [DiaVencimento],[LastValue])
			    VALUES (O.[IDProposta], O.[DataArquivo], O.[Banco], O.[Agencia], O.[Operacao], O.[ContaCorrente], O.[IDFormaPagamento], O.[DiaVencimento],1);



   -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Contratos recebidos no arquivo EMISSAO (EMISSÃO INICIAL - ENDOSSO ZERO)
	--DELETE FROM DADOS.CONTRATO
	--SELECT * from dbo.[Proposta_Saude_TEMP] where NumeroProposta = '031000000000111001'
        
   ;MERGE INTO Dados.Contrato AS T
		USING (
        SELECT DISTINCT
               PRP.ID as IDProposta, EM.[IDSeguradora], 
				 EM.[CodigoRamoPAR],
			   R.ID [IDRamo]--, EM.Nome [NomeCliente], EM.[CPFCNPJ]               
             ,  Left(EM.NumeroProposta,15)+'001' as [NumeroContrato],NULL AS [CodigoFonteProdutora],NULL as [NumeroBilhete]
             , NULL AS [NumeroSICOB], CNT_ANT.[IDContratoAnterior] AS IDContratoAnterior, EM.[DataInicioVigencia] as [DataEmissao], EM.[DataInicioVigencia], EM.[DataFimVigencia]
             , EM.[Valor] AS [ValorTotal], EM.[ValorPremioLiquidoEmissao], NULL AS [QuantidadeParcelas], NULL as [IDAgencia] 
             , NULL AS [IDIndicador], NULL AS [IDIndicadorGerente], NULL AS [IDIndicadorSuperintendenteRegional]
             , NULL AS [CodigoMoedaSegurada], NULL AS [CodigoMoedaPremio], NULL AS [LayoutRisco],  EM.[DataArquivo], 'PROTHEUS - SAÚDE' as [Arquivo]
			 , EM.ValorPremioTotal/*,EM.Subgrupo*/,EM.StatusProposta, Left(EM.NumeroProposta,15)+'001' as [NumeroProposta]
        FROM [dbo].[Proposta_Saude_TEMP] EM
			
          INNER JOIN Dados.RamoPAR R
          ON R.Codigo = EM.CodigoRamoPAR
          OUTER APPLY (SELECT TOP 1 ID [IDContratoAnterior] FROM Dados.Contrato  
                       WHERE ID = EM.IDContrato
                         AND IDSeguradora = EM.IDSeguradora) CNT_ANT
		  inner join [dbo].[Proposta_Saude_TEMP] EM2 on 
				(EM.NumeroProposta = LEFT(EM2.Numeroproposta,15)+'001' AND EM.IDSeguradora = EM2.IDSeguradora) or (EM.NumeroProposta = EM2.Numeroproposta AND EM.IDSeguradora = EM2.IDSeguradora /*and EM.IDSeguradora = 4*/ and EM.Empresa = '03')
		   OUTER APPLY(SELECT ID FROM Dados.Proposta PRP WHERE 
				(left(EM.NumeroProposta,15)+'001' = PRP.NumeroProposta          
			   AND EM.IDSeguradora = PRP.IDSeguradora ) or (EM.NumeroProposta = PRP.Numeroproposta AND EM.IDSeguradora = PRP.IDSeguradora /*and EM.IDSeguradora = 4*/ and EM.Empresa = '03')) prp
			   --CROSS APPLY(SELECT ID FROM Dados.Proposta PRP WHERE 
      --    ON (left(EM.NumeroProposta,15)+'001' = PRP.NumeroProposta          
			   --AND EM.IDSeguradora = PRP.IDSeguradora ) or (EM.NumeroProposta = PRP.Numeroproposta AND EM.IDSeguradora = PRP.IDSeguradora and EM.IDSeguradora = 4 and EM.Empresa = '03')
		WHERE /*EM.SubGrupo = 1*/  EM.StatusProposta = 6  --AND EM.NumeroProposta = '031000000000019001'
        
		) AS X
    ON  Left(X.[NumeroProposta],15)+'001' = T.[NumeroContrato]
    AND X.[IDSeguradora] = T.[IDSeguradora]
	AND /*X.SubGrupo = 1 and*/  X.StatusProposta = 6 AND X.IDProposta = t.IDProposta
  
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
               , [ValorPremioLiquidoAtual] = COALESCE(T.[ValorPremioLiquido], X.[ValorPremioLiquidoEmissao])               
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
                , X.[ValorPremioLiquidoEmissao]
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







  /***********************************************************************
       Carrega a Proposta Saúde - Dados específicos de propostas Saúde.
	   select * from dados.PropostaSaude 
***********************************************************************/ 
	  
;MERGE INTO Dados.PropostaSaude AS T
	 USING ( 
			SELECT *
					FROM
						(
							SELECT 			P.ID [IDProposta],
											Right('000000000' + Cast(t.SubGrupo as Varchar),9) as [CodigoSubestipulante],
										--	left(t.NumeroProposta,15)+'001',
										--	P.numeroproposta,
											t.Coparticipacao as [Coparticipacao],
											t.IDTipoAdesao,
										--	P.SUBGRUPO,
											PropOri.POID as IDPropostaOrigem,
											t.NomeCanal,
											t.CanalVendaPAR as [CanalVendaPAR],
											c.ID as IDCanalVendaPARSaude

											--	ROW_NUMBER() OVER(PARTITION BY t.[NumeroProposta] ORDER BY t.dataproposta DESC) [ORDER]
							FROM [dbo].[Proposta_Saude_TEMP] t 
								INNER JOIN Dados.Proposta P								
									ON P.NumeroProposta = t.[NumeroProposta] AND P.IDSeguradora = t.IDSeguradora           
								inner join Dados.CanalVendaPARSaude c on c.Codigo = t.[CanalVendaPAR]
								outer APPLY (SELECT  PO.ID as POID FROM Dados.Proposta  PO 
								
								WHERE (PO.NUMEROPROPOSTA = left(t.NumeroProposta,15)+'001' and PO.IDSeguradora = P.IDSeguradora ) 
									or (t.NumeroProposta = PO.Numeroproposta AND t.IDSeguradora = PO.IDSeguradora and t.IDSeguradora = 4 and t.Empresa = '03' )
								
								/*and SubGrupo = 1*/) as PropOri						
						) A 
			--	WHERE A.[ORDER] = 1
		    ) AS O
		ON 
		      T.[IDProposta] = O.[IDProposta] 
	    WHEN MATCHED
		    THEN UPDATE 
			    SET  T.CodigoSubEstipulante = COALESCE(Right('000000000' + rtrim(Cast(O.[CodigoSubestipulante] as Varchar)),9), T.CodigoSubestipulante)
             , T.[Coparticipacao] = COALESCE(O.[Coparticipacao], T.[Coparticipacao])
             , T.[IDTipoAdesao] = COALESCE(O.[IDTipoAdesao], T.[IDTipoAdesao])
             , T.[IDPropostaOrigem] = COALESCE(O.[IDPropostaOrigem], T.[IDPropostaOrigem])
             , T.[IDProposta] = COALESCE(O.[IDProposta], T.[IDProposta])
			 , T.[NomeCanal] = COALESCE(O.[NomeCanal], T.[NomeCanal])
			 , T.[IDCanalVendaPARSaude] = COALESCE(O.[IDCanalVendaPARSaude], T.[IDCanalVendaPARSaude])
			
	    WHEN NOT MATCHED
		    THEN INSERT ([CodigoSubEstipulante], [Coparticipacao], [IDTipoAdesao], [IDPropostaOrigem], [IDProposta],[NomeCanal],[IDCanalVendaPARSaude])
			    VALUES (O.[CodigoSubEstipulante], O.[Coparticipacao], O.[IDTipoAdesao], O.[IDPropostaOrigem], O.[IDProposta],O.[NomeCanal],O.[IDCanalVendaPARSaude]);

			--	 SELECT * FROM Dados.Proposta where id not in (SELECT IDPROPOSTA FROM Dados.PropostaSaude  )



 /***********************************************************************
       Atualiza o campo CONTRATO na Dados.Proposta
	   --select * from Dados.Proposta
	    --select * from Dados.Contrato
***********************************************************************/ 


;MERGE INTO Dados.Proposta AS T
		--USING ( SELECT DISTINCT c.ID,IDProposta,c.IDSeguradora,left(NumeroContrato,18) as NumeroContrato
		--			FROM Dados.Contrato c
		--			inner join DAdos.Proposta p on c.NumeroContrato = p.NumeroProposta

			USING ( SELECT DISTINCT CTR.IDContrato,p.ID as IDProposta,CTR.IDSeguradora,left(NumeroContrato,15) as NumeroContrato
					FROM Dados.Proposta p
					CROSS APPLY(SELECT ID AS IDCONTRATO,IDSeguradora as IDSeguradora,NumeroContrato as NumeroContrato FROM  Dados.Contrato c WHERE left(c.NumeroContrato,15) = left(p.NumeroProposta,15) AND c.IDSeguradora = p.IDSeguradora) as CTR
			) AS X
	 ON X.IDProposta  = T.ID
 --  AND T.IDSeguradora = X.[IDSeguradora]

		WHEN MATCHED
			    THEN UPDATE
					SET
						 [IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato]);



-----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Contratos recebidos no arquivo EMISSAO (EMISSÃO INICIAL - ENDOSSO ZERO)
	--DELETE FROM DADOS.CONTRATO

	--select * from [dbo].[Proposta_Saude_TEMP] t where SubGrupo = 1
	--SELECT top 200 * from Dados.ContratoCliente where NumeroProposta = '031000000000111001'
        
   ;MERGE INTO Dados.ContratoCliente AS T
		USING (
       SELECT  DISTINCT
								left(t.cnpjCPF,18) as [CPFCNPJ] ,
								left(t.nome,140) as [NomeCliente],
																Case When t.EMPRESA = '03' 
										AND t.SegmentoProtheus = '0001' AND t.SeguradoraProtheus = '0004'
												 Then 'Pessoa Juridica' 
									When t.EMPRESA = '03' AND t.SeguradoraProtheus = '0004' 
										AND  t.SegmentoProtheus <> '0001'
												Then 'Pessoa Fisica'
									When t.EMPRESA = '04' then 'Pessoa Juridica' 
									Else 'Pessoa Fisica'
								End as [TipoPessoa],
								LEFT([DDDCobranca],4) as DDD,
								Left([TelefoneCobranca],9) AS [Telefone],
								1 as LastValue,
								left(rTrim([EnderecoCorrespondencia]),40)  as Endereco,
								LEFT(t.[BairroCorrespondencia],20) as Bairro,
								LEFT(t.[CidadeCorrespondencia],20) as Cidade,
								left(t.[EstadoCorrespondencia],2) as UF,
								left(t.[CepCorrespondencia],9) as CEP,
								'PROTHEUS' as [Arquivo],
								GetDate() as [DataArquivo],
								--t.DataProposta as [DataArquivo],
								c.ID as IDContrato
								

					FROM [dbo].[Proposta_Saude_TEMP] t
						INNER JOIN Dados.Proposta PRP
							ON t.NumeroProposta = PRP.NumeroProposta 
								AND PRP.IDSeguradora = t.IDSeguradora
						INNER JOIN Dados.Contrato c on PRP.IDContrato = c.ID
						where Nome IS NOT NULL and t.SubGrupo = 1 
		) AS X
    ON  X.IDContrato = T.IDContrato
     
    WHEN MATCHED
			    THEN UPDATE
				     SET
				
					CPFCNPJ = COALESCE(X.[CPFCNPJ],T.[CPFCNPJ]),
					NomeCliente = COALESCE(X.NomeCliente,T.NomeCliente),
					TipoPessoa = COALESCE(X.TipoPessoa,T.TipoPessoa),
					DDD = COALESCE(X.DDD,T.DDD),
					Telefone = COALESCE(X.Telefone,T.Telefone),
					LastValue = COALESCE(X.LastValue,T.LastValue),
					Endereco = COALESCE(X.Endereco,T.Endereco),
					Bairro = COALESCE(X.Bairro,T.Bairro),
					Cidade = COALESCE(X.Cidade,T.Cidade),
					UF = COALESCE(X.UF,T.UF),
					CEP = COALESCE(X.CEP,T.CEP),
					Arquivo = COALESCE(X.Arquivo,T.Arquivo),
					DataArquivo = COALESCE(X.DataArquivo,T.DataArquivo),
					IDContrato	= COALESCE(X.IDContrato,T.IDContrato)	
    WHEN NOT MATCHED
			    THEN INSERT          
              ( CPFCNPJ,
			  NomeCliente,
			  TipoPessoa,
			  DDD,
			  Telefone,
			  LastValue,
			  Endereco,
			  Bairro,
			  Cidade,
			  UF,
			  CEP,
			  Arquivo,
			  DataArquivo,
			  IDContrato			  			  
			  			  
			  
			  
			  
			   )
          VALUES (
		  X.CPFCNPJ,
			  X.NomeCliente,
			  X.TipoPessoa,
			  X.DDD,
			  X.Telefone,
			  X.LastValue,
			  X.Endereco,
			  X.Bairro,
			  X.Cidade,
			  X.UF,
			  X.CEP,
			  X.Arquivo,
			  X.DataArquivo,
			  X.IDContrato	
		  
		             
                 );

	
END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  


    
