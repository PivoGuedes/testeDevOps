CREATE TABLE [Dados].[MigracaoConsorcio] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IDContrato]          BIGINT        NULL,
    [NUMERO_GRUPO]        INT           NULL,
    [NUMERO_COTA]         INT           NULL,
    [NUMERO_VERSAO]       INT           NULL,
    [NUMERO_GRUPO_ATUAL]  INT           NULL,
    [NUMERO_COTA_ATUAL]   INT           NULL,
    [NUMERO_VERSAO_ATUAL] INT           NULL,
    [BRANCOS]             VARCHAR (300) NULL,
    [NomeArquivo]         VARCHAR (200) NULL,
    [DataArquivo]         DATE          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_MigracaoConsorcio_Contrato] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID])
);

