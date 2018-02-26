CREATE TABLE [Dados].[FaixaRenda] (
    [ID]                    VARCHAR (2)     NOT NULL,
    [ValorMinimoFaixaRenda] DECIMAL (19, 2) NULL,
    [ValorMaximoFaixaRenda] DECIMAL (19, 2) NULL,
    CONSTRAINT [PK_FaixaRenda] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

