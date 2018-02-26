CREATE TABLE [Dados].[ProdutoHistorico] (
    [ID]                        INT            IDENTITY (1, 1) NOT NULL,
    [IDProduto]                 INT            NOT NULL,
    [IDPeriodoContratacao]      TINYINT        NULL,
    [IDProdutoSegmento]         TINYINT        NULL,
    [PercentualCorretora]       DECIMAL (5, 2) NULL,
    [PercentualASVEN]           DECIMAL (5, 2) NULL,
    [PercentualRepasse]         DECIMAL (5, 2) CONSTRAINT [DF_ProdutoHistorico_PercentualRepasse] DEFAULT ((0)) NULL,
    [IDEmpresaRepasse]          SMALLINT       NULL,
    [MetaASVEN]                 BIT            CONSTRAINT [DF_ProdutoHistorico_MetaASVEN] DEFAULT ((0)) NULL,
    [MetaAVCaixa]               BIT            CONSTRAINT [DF_ProdutoHistorico_MetaAVCaixa] DEFAULT ((0)) NULL,
    [Descricao]                 VARCHAR (100)  NULL,
    [DataInicioComercializacao] DATE           NULL,
    [DataFimComercializacao]    DATE           NULL,
    [DataInicio]                DATE           NULL,
    [DataFim]                   DATE           NULL,
    CONSTRAINT [PK_PRODUTOHISTORICO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PRODUTOH_FK_SEGURA_PRODUTO] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID]),
    CONSTRAINT [FK_ProdutoHistorico_Empresa] FOREIGN KEY ([IDEmpresaRepasse]) REFERENCES [Dados].[Empresa] ([ID]),
    CONSTRAINT [FK_ProdutoHistorico_PeriodoContratacao] FOREIGN KEY ([IDPeriodoContratacao]) REFERENCES [Dados].[PeriodoContratacao] ([ID]),
    CONSTRAINT [FK_ProdutoHistorico_ProdutoSegmento] FOREIGN KEY ([IDProdutoSegmento]) REFERENCES [Dados].[ProdutoSegmento] ([ID]),
    CONSTRAINT [UNQ_ProdutoHistorico] UNIQUE NONCLUSTERED ([IDProduto] ASC, [DataInicio] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [idx_CLProdutoDataInicioDataFim]
    ON [Dados].[ProdutoHistorico]([IDProduto] ASC, [DataFim] DESC, [DataInicio] DESC, [ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

