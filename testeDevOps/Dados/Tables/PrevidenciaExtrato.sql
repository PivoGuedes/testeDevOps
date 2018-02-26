CREATE TABLE [Dados].[PrevidenciaExtrato] (
    [ID]                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]         BIGINT          NOT NULL,
    [IDMotivo]           SMALLINT        NOT NULL,
    [IDMotivoSituacao]   SMALLINT        NULL,
    [IDSituacaoProposta] TINYINT         NULL,
    [DataInicioSituacao] DATE            NULL,
    [NumeroParcela]      BIGINT          NOT NULL,
    [ValorNominalRenda]  NUMERIC (16, 2) NULL,
    [ValorEstoqueRenda]  NUMERIC (16, 2) NULL,
    [ValorNominalRisco]  NUMERIC (16, 2) NULL,
    [ValorEstoqueRisco]  NUMERIC (16, 2) NULL,
    [CodigoNaFonte]      BIGINT          NULL,
    [DataArquivo]        DATE            NOT NULL,
    [Arquivo]            VARCHAR (100)   NULL,
    [TipoDado]           VARCHAR (30)    NULL,
    CONSTRAINT [PK_PREVIDENCIAEXTRATO] PRIMARY KEY NONCLUSTERED ([ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PREVIDEN_EXTRATO_MOTIVO] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PREVIDEN_EXTRATO_MOTIVOSITUACAO] FOREIGN KEY ([IDMotivoSituacao]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PREVIDEN_EXTRATO_SITUACAOPROPOSTA] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PREVIDEN_REFERENCE_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PREVIDENCIAEXTRATO] UNIQUE CLUSTERED ([IDProposta] DESC, [DataArquivo] DESC, [IDMotivo] ASC, [NumeroParcela] ASC, [ValorNominalRisco] ASC, [ValorEstoqueRisco] ASC, [ValorNominalRenda] ASC, [ValorEstoqueRenda] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_DataArquivo]
    ON [Dados].[PrevidenciaExtrato]([DataArquivo] ASC)
    INCLUDE([IDProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_NumeroParcela_VLNominalRiscoRenda]
    ON [Dados].[PrevidenciaExtrato]([ValorNominalRisco] ASC, [NumeroParcela] ASC, [ValorNominalRenda] ASC)
    INCLUDE([ID], [IDProposta], [IDMotivo], [ValorEstoqueRenda], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_NumeroParcelaVLNominalRendaRisco]
    ON [Dados].[PrevidenciaExtrato]([ValorNominalRenda] ASC, [NumeroParcela] ASC, [ValorNominalRisco] ASC)
    INCLUDE([ID], [IDProposta], [IDMotivo], [ValorEstoqueRisco], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

