CREATE TABLE [Dados].[TipoEventoConsorcio] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]    INT           NULL,
    [Descricao] VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

