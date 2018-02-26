CREATE TABLE [ConfiguracaoDados].[ImportaPrestamistaExtratoFinanceiro] (
    [CodigoComercializado] VARCHAR (5) NOT NULL,
    [Ordem]                TINYINT     NULL,
    [CodigoProdutoMip]     VARCHAR (5) NULL,
    [CodigoProdutoDfi]     VARCHAR (5) NULL,
    CONSTRAINT [PK_ImportaPrestamistaExtratoFinanceiro] PRIMARY KEY CLUSTERED ([CodigoComercializado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

