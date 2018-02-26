CREATE TABLE [Dados].[Produto] (
    [ID]                        INT           IDENTITY (1, 1) NOT NULL,
    [CodigoComercializado]      VARCHAR (5)   NOT NULL,
    [IDRamoPrincipal]           SMALLINT      NULL,
    [IDRamoSUSEP]               SMALLINT      NULL,
    [IDRamoPAR]                 SMALLINT      NULL,
    [IDProdutoSIGPF]            TINYINT       NULL,
    [Descricao]                 VARCHAR (100) NULL,
    [DataInicioComercializacao] DATE          NULL,
    [DataFimComercializacao]    DATE          NULL,
    [IDSeguradora]              SMALLINT      NULL,
    [Exclusivo]                 BIT           CONSTRAINT [DF_Produto_Exclusivo] DEFAULT ((0)) NOT NULL,
    [LancamentoManual]          BIT           CONSTRAINT [DF_Produto_LancamentoManual] DEFAULT ((0)) NOT NULL,
    [IDPeriodoPagamento]        TINYINT       NULL,
    CONSTRAINT [PK_PRODUTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PRODUTO_FK_PRODUT_RAMO] FOREIGN KEY ([IDRamoPrincipal]) REFERENCES [Dados].[Ramo] ([ID]),
    CONSTRAINT [FK_PRODUTO_FK_PRODUT_RAMOSUSE] FOREIGN KEY ([IDRamoSUSEP]) REFERENCES [Dados].[RamoSUSEP] ([ID]),
    CONSTRAINT [FK_PRODUTO_FK_PRODUT_SEGURADO] FOREIGN KEY ([IDSeguradora]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_Produto_PeriodoPagamento] FOREIGN KEY ([IDPeriodoPagamento]) REFERENCES [Dados].[PeriodoPagamento] ([ID]),
    CONSTRAINT [FK_Produto_ProdutoSIGPF] FOREIGN KEY ([IDProdutoSIGPF]) REFERENCES [Dados].[ProdutoSIGPF] ([ID]),
    CONSTRAINT [FK_PRODUTO_RAMOPAR] FOREIGN KEY ([IDRamoPAR]) REFERENCES [Dados].[RamoPAR] ([ID]),
    CONSTRAINT [UNQ_CodigoComercializadoSeguradora] UNIQUE NONCLUSTERED ([CodigoComercializado] ASC, [IDSeguradora] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NCLProduto_Codigo_ID]
    ON [Dados].[Produto]([ID] ASC, [CodigoComercializado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

