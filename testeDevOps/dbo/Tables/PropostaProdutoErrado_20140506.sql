CREATE TABLE [dbo].[PropostaProdutoErrado_20140506] (
    [IDProposta]                BIGINT        NOT NULL,
    [NumeroProposta]            VARCHAR (20)  NOT NULL,
    [IDProdutoProposta]         INT           NULL,
    [IDProdutoAnteriorPropsota] INT           NULL,
    [IDProdutoComissao]         INT           NULL,
    [CodigoComercializado]      VARCHAR (5)   NOT NULL,
    [ProdutoComercializado]     VARCHAR (100) NULL,
    [CodigoProduto]             CHAR (2)      NULL,
    [ProdutoSIGPF]              VARCHAR (100) NULL,
    [DataArquivo]               DATE          NOT NULL
);

