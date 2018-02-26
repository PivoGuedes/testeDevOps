CREATE TABLE [Dados].[ProdutoPremiacao] (
    [ID]                        INT           IDENTITY (1, 1) NOT NULL,
    [CodigoComercializado]      VARCHAR (5)   NOT NULL,
    [IDProdutoSIGPF]            TINYINT       NULL,
    [Descricao]                 VARCHAR (100) NULL,
    [DataInicioComercializacao] DATE          NULL,
    [DataFimComercializacao]    DATE          NULL,
    [IDSeguradora]              SMALLINT      NULL,
    [IDPeriodoPagamento]        TINYINT       NULL,
    [CodigoBU]                  VARCHAR (5)   NULL,
    CONSTRAINT [PK_PRODUTO_PREMIACAO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_ProdutoPremiaca_CodigoComercializadoSeguradora] UNIQUE NONCLUSTERED ([CodigoComercializado] ASC, [IDSeguradora] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

