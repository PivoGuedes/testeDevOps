CREATE TABLE [Dados].[OperacaoContratual] (
    [ID]            SMALLINT      NOT NULL,
    [IDOperacaoMae] SMALLINT      NULL,
    [Descricao]     VARCHAR (100) NOT NULL,
    [IDOrigem]      TINYINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_OperacaoContratual_OperacaoContratual] FOREIGN KEY ([IDOperacaoMae]) REFERENCES [Dados].[OperacaoContratual] ([ID])
);

