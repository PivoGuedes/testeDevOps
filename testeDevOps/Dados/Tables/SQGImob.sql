CREATE TABLE [Dados].[SQGImob] (
    [ID]                     BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]             BIGINT          NOT NULL,
    [IDObjetoContratoSQG]    INT             NOT NULL,
    [IDTipoMovimentoSQG]     INT             NOT NULL,
    [IDTipoCoberturaSQG]     INT             NOT NULL,
    [Grupo]                  VARCHAR (10)    NULL,
    [Cota]                   VARCHAR (10)    NULL,
    [Prazo]                  INT             NULL,
    [Assembleia]             INT             NULL,
    [NumeroPrestacaoPaga]    INT             NULL,
    [AnoMes]                 INT             NULL,
    [PrestacaoPagaRemessa]   INT             NULL,
    [AnoMesPrestacao]        INT             NULL,
    [DataPAgamentoPremio]    DATE            NULL,
    [PremioSqg]              DECIMAL (18, 2) NULL,
    [PrazoGrupo]             INT             NULL,
    [PercentualTA]           DECIMAL (18, 4) NULL,
    [PercentualFundoReserva] DECIMAL (18, 4) NULL,
    [ValorPagoSemMulta]      DECIMAL (18, 2) NULL,
    [PercentualSqg]          DECIMAL (18, 4) NULL,
    [DataArquivo]            DATE            NULL,
    [NomeArquivo]            VARCHAR (250)   NULL,
    [ValorParcela]           DECIMAL (18, 2) NULL,
    [CPFCNPJ]                VARCHAR (20)    NULL,
    CONSTRAINT [PK_SQGImob] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ContratoSQG] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_ObjetoContratoSQG] FOREIGN KEY ([IDObjetoContratoSQG]) REFERENCES [Dados].[ObjetoContratoSQG] ([ID]),
    CONSTRAINT [FK_TipoCoberturaSQG] FOREIGN KEY ([IDTipoCoberturaSQG]) REFERENCES [Dados].[TipoCoberturaSQG] ([ID]),
    CONSTRAINT [FK_TipoMovimentoSQG] FOREIGN KEY ([IDTipoMovimentoSQG]) REFERENCES [Dados].[TipoMovimentoSQG] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idxComissao]
    ON [Dados].[SQGImob]([IDContrato] ASC, [NumeroPrestacaoPaga] ASC, [DataPAgamentoPremio] ASC) WITH (FILLFACTOR = 90);

