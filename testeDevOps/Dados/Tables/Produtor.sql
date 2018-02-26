CREATE TABLE [Dados].[Produtor] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]              INT           NULL,
    [Nome]                VARCHAR (60)  NULL,
    [CPFCNPJ]             VARCHAR (18)  NULL,
    [Matricula]           BIGINT        NULL,
    [IDTipoProdutor]      TINYINT       NULL,
    [IDFilialFaturamento] SMALLINT      NULL,
    [NomeArquivo]         VARCHAR (100) NULL,
    [DataArquivo]         DATE          NULL,
    [CodigoProdutor]      INT           NULL,
    CONSTRAINT [PK_PRODUTOR] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Produtor_FilialFaturamento] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [FK_Produtor_TipoProdutor] FOREIGN KEY ([IDTipoProdutor]) REFERENCES [Dados].[TipoProdutor] ([ID]),
    CONSTRAINT [AK_UNQ_PRODUTOR_PRODUTOR] UNIQUE NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

