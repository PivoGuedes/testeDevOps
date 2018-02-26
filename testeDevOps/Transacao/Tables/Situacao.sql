CREATE TABLE [Transacao].[Situacao] (
    [ID]   INT           IDENTITY (1, 1) NOT NULL,
    [Nome] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Situacao] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

