CREATE TABLE [Marketing].[TipoErro] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]    INT           NOT NULL,
    [Descricao] VARCHAR (150) NOT NULL,
    CONSTRAINT [pk_TipoErro] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

