CREATE TABLE [Dados].[PropostaSituacaoPagamento] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]              BIGINT          NULL,
    [IDSituacaoCobranca]      TINYINT         NULL,
    [DataInicioSituacao]      DATE            NULL,
    [ParcelasPagas]           SMALLINT        NULL,
    [TotalDeParcelas]         SMALLINT        NULL,
    [CodigoPlano]             SMALLINT        NULL,
    [NumeroSerie]             CHAR (2)        NULL,
    [NumeroTitulo]            CHAR (7)        NULL,
    [DigitoTitulo]            CHAR (1)        NULL,
    [ValorJurosAtraso]        NUMERIC (13, 2) NULL,
    [ValorProvisaoMatematica] NUMERIC (13, 2) NULL,
    [DataReferenciaProvisao]  DATE            NULL,
    [NossoNumeroComDV]        NUMERIC (14)    NULL,
    [ValorEmAtraso]           NUMERIC (13, 2) NULL,
    [DataValidadeValorAtraso] DATE            NULL,
    [DataVencimento]          DATE            NULL,
    [ValorParcela]            NUMERIC (13, 2) NULL,
    [NomeArquivo]             VARCHAR (130)   NULL,
    [DataArquivo]             DATE            NULL,
    [CodigoNaFonte]           BIGINT          NULL,
    [LastValue]               BIT             CONSTRAINT [DF_PropostaSituacaoPagamento_LastValue] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PROPOSTASITUACAOPAGAMENTO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_PROPOSTA_SITUACAOPAGAMENTO_COBRANCA] FOREIGN KEY ([IDSituacaoCobranca]) REFERENCES [Dados].[SituacaoCobranca] ([ID]),
    CONSTRAINT [FK_PROPOSTA_SITUACAOPAGAMENTO_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
) ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_PropostaSituacaoPagamento_PRPFCAP]
    ON [Dados].[PropostaSituacaoPagamento]([IDProposta] ASC, [ParcelasPagas] ASC, [NumeroSerie] ASC, [NumeroTitulo] ASC, [DigitoTitulo] ASC, [DataReferenciaProvisao] ASC, [CodigoPlano] ASC, [DataVencimento] ASC) WHERE ([NumeroTitulo] IS NOT NULL) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_PropostaSituacaoPagamento]
    ON [Dados].[PropostaSituacaoPagamento]([IDProposta] ASC, [IDSituacaoCobranca] ASC, [DataInicioSituacao] ASC, [ParcelasPagas] ASC) WHERE ([NumeroTitulo] IS NULL) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PropostaSituacaoPagamento_LastValue]
    ON [Dados].[PropostaSituacaoPagamento]([IDProposta] ASC, [NumeroSerie] ASC, [NumeroTitulo] ASC, [DigitoTitulo] ASC, [LastValue] ASC)
    INCLUDE([ID], [DataArquivo]) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaSituacaoPagamento_IDProposta]
    ON [Dados].[PropostaSituacaoPagamento]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

