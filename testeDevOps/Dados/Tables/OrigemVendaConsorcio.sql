CREATE TABLE [Dados].[OrigemVendaConsorcio] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Codigo]    INT          NULL,
    [Descricao] VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

