CREATE TABLE [Dados].[RegraComissaoProduto_hml] (
    [Id]                 INT            NOT NULL,
    [IdProduto]          INT            NULL,
    [DataInicioVigencia] DATE           NULL,
    [DataFimVigencia]    DATE           NULL,
    [PercentualComissao] DECIMAL (5, 2) NULL,
    [PercentualIOF]      DECIMAL (5, 2) NULL
);

