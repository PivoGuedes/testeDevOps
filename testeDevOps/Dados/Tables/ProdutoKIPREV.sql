CREATE TABLE [Dados].[ProdutoKIPREV] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]    VARCHAR (10)  NULL,
    [Descricao] VARCHAR (100) NULL,
    [IDProduto] INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_ProdutoKIPREV_PRODUTO] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID])
);

