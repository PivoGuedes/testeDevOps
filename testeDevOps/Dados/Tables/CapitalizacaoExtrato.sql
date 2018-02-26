CREATE TABLE [Dados].[CapitalizacaoExtrato] (
    [ID]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]    BIGINT          NULL,
    [CodigoPlano]   SMALLINT        NULL,
    [NumeroSerie]   CHAR (2)        NULL,
    [NumeroTitulo]  CHAR (7)        NULL,
    [DigitoTitulo]  CHAR (1)        NULL,
    [NumeroParcela] INT             NULL,
    [ValorTitulo]   NUMERIC (13, 2) NULL,
    [NomeArquivo]   NVARCHAR (50)   NULL,
    [DataArquivo]   DATE            NULL,
    [IDMotivo]      SMALLINT        NULL,
    CONSTRAINT [PK_CapitalizacaoExtrato_Codigo] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_CapitalizacaoExtrato_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_IDMotivo_TipoMotivo] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_InclusaoTitulos_NumeroSerieDigitoNumeroParcelaDataArquivo]
    ON [Dados].[CapitalizacaoExtrato]([IDProposta] ASC, [NumeroTitulo] ASC, [NumeroSerie] ASC, [DigitoTitulo] ASC, [NumeroParcela] ASC, [CodigoPlano] ASC, [IDMotivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

