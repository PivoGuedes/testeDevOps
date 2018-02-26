CREATE TABLE [Dados].[Previdencia_KIPREV] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]              INT             NOT NULL,
    [IDProdutoKIPREV]         INT             NOT NULL,
    [CodigoConta]             VARCHAR (20)    NULL,
    [Sobrevida_contratado_pm] DECIMAL (19, 2) NULL,
    [Sobrevida_contratado_pu] DECIMAL (19, 2) NULL,
    [Risco_contratado_pm]     DECIMAL (19, 2) NULL,
    [Risco_contratado_PU]     DECIMAL (19, 2) NULL,
    [PRAZO]                   VARCHAR (50)    NULL,
    [SEXO]                    VARCHAR (5)     NULL,
    [DATA_NASCIMENTO]         DATE            NULL,
    [RENDA_PARTICIPANTE]      DECIMAL (19, 2) NULL,
    [DataArquivo]             DATE            NULL,
    [NomeArquivo]             VARCHAR (200)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

