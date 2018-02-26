CREATE TABLE [Dados].[ProdutoClassificacaoBloco_BKP] (
    [ID]                              INT           IDENTITY (1, 1) NOT NULL,
    [IDEmpresa]                       INT           NOT NULL,
    [CodigoClassificacaoVendaNova]    INT           NULL,
    [DescricaoClassificacaoVendaNova] VARCHAR (30)  NULL,
    [CodigoComercializado]            INT           NULL,
    [DescricaoProduto]                VARCHAR (100) NULL,
    [DsClassificacaoProdutos]         VARCHAR (30)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_Emp_CodigoClassificacaoVN_DescricaoVN]
    ON [Dados].[ProdutoClassificacaoBloco_BKP]([ID] ASC)
    INCLUDE([IDEmpresa], [CodigoClassificacaoVendaNova], [DescricaoClassificacaoVendaNova]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

