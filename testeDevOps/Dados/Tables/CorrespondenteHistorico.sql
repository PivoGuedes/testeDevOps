CREATE TABLE [Dados].[CorrespondenteHistorico] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [IDCorrespondente] INT           NOT NULL,
    [Nome]             VARCHAR (140) NULL,
    [IDUnidade]        SMALLINT      NULL,
    [UF]               CHAR (2)      NULL,
    [Cidade]           VARCHAR (70)  NULL,
    [DataArquivo]      DATE          NULL,
    [LastValue]        BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CorrespondenteHistorico] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CorrespondenteHistorico_Unidade] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_CorrespontenteHistorico_Correspondente] FOREIGN KEY ([IDCorrespondente]) REFERENCES [Dados].[Correspondente] ([ID])
);

