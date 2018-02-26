CREATE TABLE [Dados].[PropostaSituacao] (
    [ID]                 BIGINT       IDENTITY (1, 1) NOT NULL,
    [IDProposta]         BIGINT       NOT NULL,
    [IDSituacaoProposta] TINYINT      NOT NULL,
    [IDMotivo]           SMALLINT     NULL,
    [DataInicioSituacao] DATE         NULL,
    [LastValue]          BIT          CONSTRAINT [DF_PropostaSituacao_LastValue] DEFAULT ((0)) NOT NULL,
    [DataArquivo]        DATE         NOT NULL,
    [TipoDado]           VARCHAR (70) NOT NULL,
    CONSTRAINT [PK_PROPOSTASITUACAO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTA_SITUACAOPROPOSTA] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PROPOSTASITUACAO_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PROPOSTASITUACAO_TIPOMOTIVO] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [idx_UNQ_NCLPropostaSituacao]
    ON [Dados].[PropostaSituacao]([IDProposta] ASC, [DataInicioSituacao] DESC, [IDSituacaoProposta] ASC, [IDMotivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_UNQ_NCLPropostaSituacao_LastValue]
    ON [Dados].[PropostaSituacao]([IDProposta] ASC, [DataInicioSituacao] DESC, [IDSituacaoProposta] ASC, [IDMotivo] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_Idx_IDProposta_Situacao_DataArquivo_PropostaSituacao]
    ON [Dados].[PropostaSituacao]([IDProposta] ASC, [DataArquivo] ASC, [IDSituacaoProposta] ASC)
    INCLUDE([IDMotivo], [DataInicioSituacao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_DataArquivo]
    ON [Dados].[PropostaSituacao]([DataArquivo] ASC)
    INCLUDE([IDProposta], [IDSituacaoProposta], [IDMotivo], [DataInicioSituacao], [LastValue]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_IDSituacaoProposta_DataArquivo]
    ON [Dados].[PropostaSituacao]([IDSituacaoProposta] ASC, [DataArquivo] ASC)
    INCLUDE([IDProposta], [IDMotivo], [DataInicioSituacao], [LastValue]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

