CREATE TABLE [Dados].[ProdutoSIGPF] (
    [ID]                    TINYINT       IDENTITY (1, 1) NOT NULL,
    [CodigoProduto]         CHAR (2)      NOT NULL,
    [Descricao]             VARCHAR (100) NULL,
    [ProdutoComCertificado] BIT           NULL,
    [ProdutoComContrato]    BIT           NULL,
    [ProdutoPatrimonial]    BIT           CONSTRAINT [DF_ProdutoSIGPF_ProdutoPatrimonial] DEFAULT ((0)) NULL,
    [Apelido]               VARCHAR (50)  NULL,
    CONSTRAINT [PK_PRODUTOSIGPF] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_CodigoProduto] UNIQUE NONCLUSTERED ([CodigoProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

