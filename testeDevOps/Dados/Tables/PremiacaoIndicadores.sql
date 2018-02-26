CREATE TABLE [Dados].[PremiacaoIndicadores] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]        INT             NULL,
    [IDEscritorioNegocio]  SMALLINT        NULL,
    [IDUnidade]            SMALLINT        NULL,
    [IDProduto]            INT             NULL,
    [ValorBruto]           DECIMAL (19, 5) NULL,
    [TipoPagamento]        CHAR (1)        NULL,
    [IDContrato]           BIGINT          NULL,
    [NumeroEndosso]        BIGINT          NULL,
    [NumeroParcela]        INT             NULL,
    [IDProposta]           BIGINT          NULL,
    [NumeroOcorrencia]     INT             NULL,
    [NomeArquivo]          VARCHAR (60)    NOT NULL,
    [DataArquivo]          DATE            NOT NULL,
    [NumeroApolice]        VARCHAR (20)    NULL,
    [CodigoSubGrupo]       SMALLINT        NULL,
    [NomeSegurado]         VARCHAR (200)   NULL,
    [NumeroTitulo]         VARCHAR (20)    NULL,
    [IDProdutoPremiacao]   INT             NULL,
    [Gerente]              BIT             NULL,
    [IDLote]               INT             NULL,
    [AnoMesArquivo]        AS              (CONVERT([varchar](10),datepart(year,[dataarquivo]))+right('0'+CONVERT([varchar](10),datepart(month,[dataarquivo])),(2))),
    [NumeroTituloOriginal] VARCHAR (20)    NULL,
    [DataEmissao]          DATE            NULL,
    CONSTRAINT [PK_PremiacaoIndicadores] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PremiacaoIndicadores_Contrato] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_Funcionario] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_LoteProtheus] FOREIGN KEY ([IDLote]) REFERENCES [ControleDados].[LoteProtheus] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_PremiacaoIndicadores] FOREIGN KEY ([ID]) REFERENCES [Dados].[PremiacaoIndicadores] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_Produto] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_ProdutoPremiacao] FOREIGN KEY ([IDProdutoPremiacao]) REFERENCES [Dados].[ProdutoPremiacao] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_UnidadeAG] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_PremiacaoIndicadores_UnidadeEN] FOREIGN KEY ([IDEscritorioNegocio]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [UNQ_PremiacaoIndicadores] UNIQUE NONCLUSTERED ([NomeArquivo] ASC, [NumeroApolice] ASC, [NumeroTitulo] ASC, [IDProdutoPremiacao] ASC, [NumeroEndosso] ASC, [NumeroParcela] ASC, [NumeroOcorrencia] ASC, [IDFuncionario] ASC, [TipoPagamento] ASC, [Gerente] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoIndicadores_IDIndicadorDataArquivo]
    ON [Dados].[PremiacaoIndicadores]([IDFuncionario] ASC, [DataArquivo] ASC)
    INCLUDE([ValorBruto]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoIndicadores_DataArquivoIDIndicador]
    ON [Dados].[PremiacaoIndicadores]([DataArquivo] ASC, [IDFuncionario] ASC)
    INCLUDE([ValorBruto], [IDUnidade], [TipoPagamento], [NumeroApolice], [NumeroTitulo], [IDProdutoPremiacao], [NumeroParcela]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [INDEXES];


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoIndicadores_SuporteCargaDeLote]
    ON [Dados].[PremiacaoIndicadores]([IDLote] ASC)
    INCLUDE([DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoIndicadores_Gerente_DataArquivo]
    ON [Dados].[PremiacaoIndicadores]([Gerente] ASC)
    INCLUDE([DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoIndicadores_IDLoteIDIndicador]
    ON [Dados].[PremiacaoIndicadores]([IDLote] ASC, [IDFuncionario] ASC)
    INCLUDE([ValorBruto]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_IDProduto_PremiacaoIndicadores]
    ON [Dados].[PremiacaoIndicadores]([IDProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [TMP_NCL_IDX_NUMEROTITULO_PREMIACAOINDICADORES]
    ON [Dados].[PremiacaoIndicadores]([NumeroTitulo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_NumeroTituloOriginal]
    ON [Dados].[PremiacaoIndicadores]([NumeroTituloOriginal] ASC)
    INCLUDE([IDFuncionario], [IDUnidade], [IDProduto], [ValorBruto], [IDContrato], [NumeroEndosso], [NumeroParcela], [NumeroApolice], [NumeroTitulo], [IDProdutoPremiacao], [Gerente], [IDLote], [AnoMesArquivo], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_APOLICE_SUPORTA_3C]
    ON [Dados].[PremiacaoIndicadores]([NumeroApolice] ASC)
    INCLUDE([IDFuncionario], [IDUnidade], [ValorBruto], [TipoPagamento], [NumeroParcela], [DataArquivo], [NumeroTitulo], [IDProdutoPremiacao], [Gerente]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

