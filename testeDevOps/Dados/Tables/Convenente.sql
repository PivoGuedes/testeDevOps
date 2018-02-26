CREATE TABLE [Dados].[Convenente] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Codigo]    VARCHAR (10) NOT NULL,
    [Descricao] VARCHAR (20) NOT NULL,
    CONSTRAINT [pk_Convenente_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

