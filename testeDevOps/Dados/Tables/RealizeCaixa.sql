CREATE TABLE [Dados].[RealizeCaixa] (
    [IDRealizeCaixa]              INT             IDENTITY (1, 1) NOT NULL,
    [NumeroAvaliacaoRealizeCaixa] INT             NULL,
    [AnoMes]                      INT             NULL,
    [CodigoUnidade]               INT             NULL,
    [CodigoBlocoRealizeCaixa]     INT             NULL,
    [CodigoItemRealizeCaixa]      INT             NULL,
    [NomeItemRealizeCaixa]        VARCHAR (100)   NULL,
    [RealizadoAcumulado]          DECIMAL (19, 2) NULL,
    [MetaAcumulada]               DECIMAL (19, 2) NULL,
    [PercentualRealizado]         DECIMAL (19, 2) NULL,
    [PercentualMeta]              DECIMAL (19, 2) NULL,
    [DataUltimaAtualizacao]       DATETIME        NULL,
    [NomeArquivoImportado]        VARCHAR (100)   NULL,
    [DataArquivoImportado]        DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([IDRealizeCaixa] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

