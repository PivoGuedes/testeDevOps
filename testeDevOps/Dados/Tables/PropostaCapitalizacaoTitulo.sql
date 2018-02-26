CREATE TABLE [Dados].[PropostaCapitalizacaoTitulo] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]               BIGINT          NOT NULL,
    [NumeroOrdemTitular]       SMALLINT        NULL,
    [NumeroTitulo]             CHAR (7)        NULL,
    [SerieTitulo]              CHAR (2)        NULL,
    [DigitoNumeroTitulo]       CHAR (1)        NULL,
    [IDSituacaoTitulo]         TINYINT         NULL,
    [DataInicioSituacaoTitulo] DATE            NULL,
    [DataPostagemTitulo]       DATE            NULL,
    [DataInicioVigencia]       DATE            NULL,
    [DataInicioSorteio]        DATE            NULL,
    [NumeroCombinacao]         INT             NULL,
    [ValorTitulo]              NUMERIC (17, 2) NULL,
    [CodigoPlanoSUSEP]         INT             NULL,
    [IDMotivoSituacaoTitulo]   SMALLINT        NULL,
    [DataArquivo]              DATE            NULL,
    [TipoArquivo]              VARCHAR (100)   NULL,
    CONSTRAINT [PK_PropostaCapitalizacaoTitulo] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_IDMotivoSituacaoTitulo_TipoMotivo] FOREIGN KEY ([IDMotivoSituacaoTitulo]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_IDSituacaoTitulo_SituacaoProposta] FOREIGN KEY ([IDSituacaoTitulo]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PropostaCapitalizacaoTitulo_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_Titulos_NumeroSerieDigitoNumeroProposta]
    ON [Dados].[PropostaCapitalizacaoTitulo]([NumeroTitulo] ASC, [SerieTitulo] ASC, [DigitoNumeroTitulo] ASC)
    INCLUDE([IDProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaCapitalizacaoTitulo_IDProposta]
    ON [Dados].[PropostaCapitalizacaoTitulo]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

