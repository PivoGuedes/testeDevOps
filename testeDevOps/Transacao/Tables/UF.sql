CREATE TABLE [Transacao].[UF] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [CodigoIBGE] INT           NOT NULL,
    [Sigla]      VARCHAR (2)   NOT NULL,
    [Nome]       VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_UF] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

