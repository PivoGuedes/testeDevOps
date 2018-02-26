CREATE TABLE [Dados].[PropostaFinanceiro] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]              BIGINT          NOT NULL,
    [IDOperacaoCredito]       TINYINT         NULL,
    [IDTipoCredito]           TINYINT         NULL,
    [NumeroContratoVinculado] VARCHAR (20)    NULL,
    [DataContrato]            DATE            NULL,
    [DataInclusao]            DATE            NULL,
    [DataEncerramento]        DATE            NULL,
    [Complemento]             VARCHAR (30)    NULL,
    [IDISMip]                 TINYINT         CONSTRAINT [DF_PropostaFinanceiro_IDISMip] DEFAULT ((0)) NULL,
    [ValorFinanciamento]      NUMERIC (16, 2) NULL,
    [RendaPactuada]           NUMERIC (5, 2)  NULL,
    [PrazoVigencia]           SMALLINT        NULL,
    [NumeroOrdemInclusao]     VARCHAR (10)    NULL,
    [NumeroRI]                VARCHAR (5)     NULL,
    [NumeroOrdemExclusao]     VARCHAR (10)    NULL,
    [NumeroRE]                VARCHAR (5)     NULL,
    [CodigoESCNEG]            VARCHAR (5)     NULL,
    [Arquivo]                 VARCHAR (100)   NULL,
    [DataArquivo]             DATE            NULL,
    CONSTRAINT [PK_PROPOSTAFINANCEIRO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTA_OPERACAOCREDITO] FOREIGN KEY ([IDOperacaoCredito]) REFERENCES [Dados].[OperacaoCredito] ([ID]),
    CONSTRAINT [FK_PropostaFinanceiro_IdentificacaoIS] FOREIGN KEY ([IDISMip]) REFERENCES [Dados].[IdentificacaoIS] ([ID]),
    CONSTRAINT [FK_PROPOSTAPRESTAMISTA__PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PROPOSTA_FINANCEIRO] UNIQUE CLUSTERED ([IDProposta] ASC, [DataArquivo] ASC, [NumeroContratoVinculado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaFinanceiro_DataInclusao]
    ON [Dados].[PropostaFinanceiro]([DataInclusao] ASC)
    INCLUDE([IDProposta], [IDOperacaoCredito], [IDTipoCredito], [NumeroContratoVinculado], [DataContrato], [DataArquivo], [NumeroOrdemInclusao], [NumeroRI], [NumeroOrdemExclusao], [NumeroRE], [CodigoESCNEG], [Arquivo], [DataEncerramento], [Complemento], [IDISMip], [ValorFinanciamento], [RendaPactuada], [PrazoVigencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [INDEXES];


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaFinanceiro_IDProposta]
    ON [Dados].[PropostaFinanceiro]([IDProposta] ASC)
    INCLUDE([DataInclusao], [IDOperacaoCredito], [IDTipoCredito], [NumeroContratoVinculado], [DataContrato], [DataArquivo], [NumeroOrdemInclusao], [NumeroRI], [NumeroOrdemExclusao], [NumeroRE], [CodigoESCNEG], [Arquivo], [DataEncerramento], [Complemento], [IDISMip], [ValorFinanciamento], [RendaPactuada], [PrazoVigencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [INDEXES];


GO
CREATE NONCLUSTERED INDEX [IDX_NC_ValorFinanciamento]
    ON [Dados].[PropostaFinanceiro]([ValorFinanciamento] ASC)
    INCLUDE([IDProposta], [DataInclusao], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_tmp_contratovinculado]
    ON [Dados].[PropostaFinanceiro]([NumeroContratoVinculado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

