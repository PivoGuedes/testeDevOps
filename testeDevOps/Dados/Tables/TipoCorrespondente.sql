CREATE TABLE [Dados].[TipoCorrespondente] (
    [ID]        TINYINT      NOT NULL,
    [Descricao] VARCHAR (25) NULL,
    CONSTRAINT [PK_TipoCorrespondente] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

