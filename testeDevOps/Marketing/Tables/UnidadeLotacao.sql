CREATE TABLE [Marketing].[UnidadeLotacao] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (300) NULL,
    CONSTRAINT [PK_UnidadeLotacao] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

