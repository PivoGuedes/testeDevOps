CREATE TABLE [Transacao].[GrupoTipoTransacao] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (150) NOT NULL,
    CONSTRAINT [PK_GrupoTipoTransacao] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

