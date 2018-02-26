CREATE TABLE [Dados].[PlanoFaixaEtariaProposta] (
    [ID]               BIGINT      IDENTITY (1, 1) NOT NULL,
    [IDTabelaQtdVidas] INT         NULL,
    [IDAdesao]         INT         NULL,
    [UF]               VARCHAR (2) NULL,
    [Copart]           INT         NULL,
    [IdadeDe]          INT         NULL,
    [IdadeAte]         INT         NULL,
    [Premio]           FLOAT (53)  NULL,
    [Validade]         DATE        NULL,
    [IDPlano]          INT         NULL,
    [IDProposta]       BIGINT      NOT NULL,
    [Empresa]          VARCHAR (2) NOT NULL,
    [IDSeguradora]     INT         NOT NULL,
    CONSTRAINT [PK_PLANOFAIXAETARIAPROPOSTA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

