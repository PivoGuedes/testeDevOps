CREATE TABLE [Dados].[PropostaSituacaoContratual] (
    [ID]                   BIGINT       IDENTITY (1, 1) NOT NULL,
    [IDProposta]           BIGINT       NOT NULL,
    [IDSituacaoContratual] SMALLINT     NOT NULL,
    [DataInicioSituacao]   DATE         NOT NULL,
    [LastValue]            BIT          CONSTRAINT [DF_PropostaSituacaoContratual_LastValue] DEFAULT ((0)) NOT NULL,
    [DataArquivo]          DATE         NOT NULL,
    [TipoDado]             VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_PROPOSTASituacaoContratual] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTA_SITUACAOCONTRATUAL] FOREIGN KEY ([IDSituacaoContratual]) REFERENCES [Dados].[SituacaoContratual] ([ID]),
    CONSTRAINT [FK_PROPOSTASITCONTRATUAL_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [idx_UNQ_NCLPropostaSituacaoContratual]
    ON [Dados].[PropostaSituacaoContratual]([IDProposta] ASC, [DataInicioSituacao] DESC, [IDSituacaoContratual] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_UNQ_NCLPropostaSituacaoContratual_LastValue]
    ON [Dados].[PropostaSituacaoContratual]([IDProposta] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

