CREATE TABLE [Dados].[PlanoFaixaEtaria] (
    [ID]               BIGINT      NOT NULL,
    [IDTabelaQtdVidas] INT         NULL,
    [IDAdesao]         INT         NULL,
    [UF]               VARCHAR (2) NULL,
    [Copart]           INT         NULL,
    [IdadeDe]          INT         NULL,
    [IdadeAte]         INT         NULL,
    [Premio]           FLOAT (53)  NULL,
    [Validade]         DATE        NULL,
    [IDPlano]          INT         NULL,
    CONSTRAINT [PK_PLANOFAIXAETARIA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

