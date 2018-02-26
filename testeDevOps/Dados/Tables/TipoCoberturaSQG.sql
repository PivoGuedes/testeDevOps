CREATE TABLE [Dados].[TipoCoberturaSQG] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Codigo]    VARCHAR (2)  NOT NULL,
    [Descricao] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TipoCoberturaSQG] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

