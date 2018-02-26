CREATE TABLE [Dados].[ProdutoPropostaAIC] (
    [IDProdutoSIGPF]  TINYINT      NOT NULL,
    [IDTipoPessoa]    TINYINT      NOT NULL,
    [IDTipoPagamento] INT          NOT NULL,
    [DataInicio]      DATE         NOT NULL,
    [Nome]            VARCHAR (50) NULL,
    CONSTRAINT [PK_ProdutoPropostaAIC] PRIMARY KEY CLUSTERED ([IDProdutoSIGPF] ASC, [IDTipoPessoa] ASC, [IDTipoPagamento] ASC, [DataInicio] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

