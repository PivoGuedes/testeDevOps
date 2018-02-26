CREATE TABLE [Dados].[RegraComissaoProduto] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [IdProduto]          INT            NULL,
    [DataInicioVigencia] DATE           NULL,
    [DataFimVigencia]    DATE           NULL,
    [PercentualComissao] DECIMAL (5, 2) NULL,
    [PercentualIOF]      DECIMAL (5, 2) NULL,
    CONSTRAINT [PK_REGRACOMIMSSAO_PRODUTO] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_REGRACOMISSAOPRODUTO_PRODUTO] FOREIGN KEY ([IdProduto]) REFERENCES [Dados].[Produto] ([ID])
);

