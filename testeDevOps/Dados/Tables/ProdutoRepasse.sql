CREATE TABLE [Dados].[ProdutoRepasse] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [IDProduto]           INT             NOT NULL,
    [ParcelaInicial]      SMALLINT        NOT NULL,
    [ParcelaFinal]        SMALLINT        NOT NULL,
    [PercentualComissao]  NUMERIC (18, 2) NOT NULL,
    [PercentualCorretora] NUMERIC (18, 2) NOT NULL,
    [PercentualRepasse]   NUMERIC (18, 2) NOT NULL,
    [ValidadeInicio]      DATE            NOT NULL,
    [ValidadeFim]         DATE            NULL,
    CONSTRAINT [PK_ProdutoRepasse] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_ProdutoRepasse_Produto] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID])
);

