CREATE TABLE [Dados].[ProdutoClassificacaoBloco] (
    [ID]                              INT           IDENTITY (1, 1) NOT NULL,
    [IDEmpresa]                       INT           NOT NULL,
    [CodigoClassificacaoVendaNova]    VARCHAR (5)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DescricaoClassificacaoVendaNova] VARCHAR (30)  NULL,
    [CodigoComercializado]            VARCHAR (5)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DescricaoProduto]                VARCHAR (100) NULL,
    [DsClassificacaoProdutos]         VARCHAR (30)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_Emp_CodigoClassificacaoVN_DescricaoVN]
    ON [Dados].[ProdutoClassificacaoBloco]([ID] ASC)
    INCLUDE([IDEmpresa], [CodigoClassificacaoVendaNova], [DescricaoClassificacaoVendaNova]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

