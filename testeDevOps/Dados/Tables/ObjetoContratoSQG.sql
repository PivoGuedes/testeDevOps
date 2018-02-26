CREATE TABLE [Dados].[ObjetoContratoSQG] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (250) NOT NULL,
    CONSTRAINT [PK_ObjetoContratoSQG] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

