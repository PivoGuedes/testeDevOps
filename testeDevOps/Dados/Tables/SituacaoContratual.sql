CREATE TABLE [Dados].[SituacaoContratual] (
    [ID]            SMALLINT      NOT NULL,
    [IDSituacaoMae] SMALLINT      NULL,
    [Descricao]     VARCHAR (100) NOT NULL,
    [IDOrigem]      TINYINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_SituacaoContratual_SituacaoContratual] FOREIGN KEY ([IDSituacaoMae]) REFERENCES [Dados].[SituacaoContratual] ([ID])
);

