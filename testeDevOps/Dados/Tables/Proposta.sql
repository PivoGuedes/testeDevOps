CREATE TABLE [Dados].[Proposta] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]                  BIGINT          NULL,
    [IDSeguradora]                SMALLINT        CONSTRAINT [DF_Proposta_IDSeguradora] DEFAULT ((1)) NOT NULL,
    [NumeroProposta]              VARCHAR (20)    NOT NULL,
    [NumeroPropostaEMISSAO]       VARCHAR (20)    NULL,
    [IDProduto]                   INT             NULL,
    [IDProdutoAnterior]           INT             NULL,
    [IDProdutoSIGPF]              TINYINT         NULL,
    [IDPeriodicidadePagamento]    TINYINT         NULL,
    [IDCanalVendaPAR]             INT             NULL,
    [DataProposta]                DATE            NULL,
    [DataInicioVigencia]          DATE            NULL,
    [DataFimVigencia]             DATE            NULL,
    [IDFuncionario]               INT             NULL,
    [Valor]                       DECIMAL (24, 4) NULL,
    [RendaIndividual]             VARCHAR (2)     NULL,
    [RendaFamiliar]               VARCHAR (2)     NULL,
    [IDAgenciaVenda]              SMALLINT        NULL,
    [DataSituacao]                DATE            NULL,
    [IDSituacaoProposta]          TINYINT         NULL,
    [IDSituacaoCobranca]          TINYINT         NULL,
    [IDTipoMotivo]                SMALLINT        NULL,
    [TipoDado]                    VARCHAR (80)    NOT NULL,
    [DataArquivo]                 DATE            NOT NULL,
    [ValorPremioBrutoEmissao]     NUMERIC (16, 2) NULL,
    [ValorPremioLiquidoEmissao]   NUMERIC (16, 2) NULL,
    [ValorPremioBrutoCalculado]   NUMERIC (16, 2) NULL,
    [ValorPremioLiquidoCalculado] NUMERIC (16, 2) NULL,
    [ValorPagoAcumulado]          NUMERIC (16, 2) NULL,
    [ValorPremioTotal]            NUMERIC (16, 2) NULL,
    [RenovacaoAutomatica]         VARCHAR (1)     NULL,
    [PercentualDesconto]          NUMERIC (5, 2)  NULL,
    [EmpresaConvenente]           VARCHAR (40)    NULL,
    [MatriculaConvenente]         VARCHAR (8)     NULL,
    [OpcaoCobertura]              VARCHAR (1)     NULL,
    [CodigoPlano]                 VARCHAR (4)     NULL,
    [DataAutenticacaoSICOB]       DATE            NULL,
    [AgenciaPagamentoSICOB]       VARCHAR (4)     NULL,
    [TarifaCobrancaSICOB]         NUMERIC (15, 2) NULL,
    [DataCreditoSASSESICOB]       DATE            NULL,
    [ValorComissaoSICOB]          NUMERIC (15, 2) NULL,
    [PeriodicidadePagamento]      VARCHAR (2)     NULL,
    [OpcaoConjuge]                VARCHAR (1)     NULL,
    [OrigemProposta]              VARCHAR (2)     NULL,
    [DeclaracaoSaudeTitular]      VARCHAR (7)     NULL,
    [DeclaracaoSaudeConjuge]      VARCHAR (7)     NULL,
    [AposentadoriaInvalidez]      VARCHAR (1)     NULL,
    [CodigoSegmento]              VARCHAR (4)     NULL,
    [SubGrupo]                    INT             NULL,
    [DataEmissao]                 DATE            NULL,
    [DataVenda]                   DATE            NULL,
    [IDContratoAnterior]          BIGINT          NULL,
    [IDSituacaoContratual]        SMALLINT        NULL,
    [DataSituacaoContratual]      DATE            NULL,
    [TotalDeVidas]                INT             NULL,
    [IDPropostaM]                 BIGINT          NULL,
    [IDCanalVenda1]               AS              (CONVERT([tinyint],case when isnumeric(left([NumeroProposta],(2)))=(1) then left([NumeroProposta],(1)) else (255) end)) PERSISTED,
    [IDCanalVenda]                AS              (CONVERT([tinyint],case when isnumeric(left([NumeroProposta],(2)))=(1) then left([NumeroProposta],(1)) else (255) end)) PERSISTED,
    [QuantidadeParcelas]          SMALLINT        NULL,
    [BitAntecipacao]              BIT             NULL,
    [BitMudancaPlano]             BIT             NULL,
    [Rowversion]                  ROWVERSION      NOT NULL,
    CONSTRAINT [PK_PROPOSTA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_NUMEROFAIXARENDAFAMILIAR] FOREIGN KEY ([RendaFamiliar]) REFERENCES [Dados].[FaixaRenda] ([ID]),
    CONSTRAINT [FK_NUMEROFAIXARENDAINDIVIDUAL] FOREIGN KEY ([RendaIndividual]) REFERENCES [Dados].[FaixaRenda] ([ID]),
    CONSTRAINT [FK_PROPOSTA_CANALVENDA_PAR] FOREIGN KEY ([IDCanalVendaPAR]) REFERENCES [Dados].[CanalVendaPAR] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_CONTRATO] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_PRODUTOS] FOREIGN KEY ([IDProdutoSIGPF]) REFERENCES [Dados].[ProdutoSIGPF] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_SITUACAO] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FUNCIONARIO] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_PROPOSTA_PERIODOPAGAMENTO] FOREIGN KEY ([IDPeriodicidadePagamento]) REFERENCES [Dados].[PeriodoPagamento] ([ID]),
    CONSTRAINT [FK_PROPOSTA_PRODUTO] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID]),
    CONSTRAINT [FK_PROPOSTA_PRODUTOANT] FOREIGN KEY ([IDProdutoAnterior]) REFERENCES [Dados].[Produto] ([ID]),
    CONSTRAINT [FK_Proposta_Proposta] FOREIGN KEY ([IDPropostaM]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_Proposta_SituacaoCobranca] FOREIGN KEY ([IDSituacaoCobranca]) REFERENCES [Dados].[SituacaoCobranca] ([ID]),
    CONSTRAINT [FK_PROPOSTAAGENCIAVENDA_UNIDADE] FOREIGN KEY ([IDAgenciaVenda]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_PropostaContratoAnterior] FOREIGN KEY ([IDContratoAnterior]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_SituacaoContratual_Proposta] FOREIGN KEY ([IDSituacaoContratual]) REFERENCES [Dados].[SituacaoContratual] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Proposta_IDContrato_ID]
    ON [Dados].[Proposta]([IDContrato] ASC)
    INCLUDE([NumeroProposta]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Produto_SuporteCalculoCanal]
    ON [Dados].[Proposta]([IDProduto] ASC)
    INCLUDE([ID], [NumeroProposta], [IDCanalVendaPAR]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NCL_UNQ_Proposta_NumeroProposta_IDSeguradora_ID]
    ON [Dados].[Proposta]([NumeroProposta] ASC, [IDSeguradora] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IND_NDX_Propostas_PropostaM]
    ON [Dados].[Proposta]([IDPropostaM] ASC)
    INCLUDE([ID], [IDProduto], [DataProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Proposta_IDSeguradora_ID_NumeroProposta]
    ON [Dados].[Proposta]([IDSeguradora] ASC)
    INCLUDE([ID], [NumeroProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_IDProdutoSIGPF_Data]
    ON [Dados].[Proposta]([IDProdutoSIGPF] ASC, [DataArquivo] ASC)
    INCLUDE([IDContrato], [IDProduto]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_IDSeguradora_NumeroProposta_Proposta]
    ON [Dados].[Proposta]([IDSeguradora] ASC, [NumeroProposta] ASC)
    INCLUDE([ID], [DataProposta], [ValorPremioLiquidoEmissao], [IDFuncionario], [IDSituacaoProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Proposta_IDContrato_DataInicioVigencia]
    ON [Dados].[Proposta]([IDContrato] ASC, [DataInicioVigencia] ASC)
    INCLUDE([ID], [IDProdutoSIGPF], [IDSituacaoProposta]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Proposta_IDProdutoSIGPF_IDContrato_DataInicioVigencia]
    ON [Dados].[Proposta]([IDProdutoSIGPF] ASC, [IDContrato] ASC, [DataInicioVigencia] ASC)
    INCLUDE([ID], [IDSituacaoProposta]) WITH (FILLFACTOR = 90);

