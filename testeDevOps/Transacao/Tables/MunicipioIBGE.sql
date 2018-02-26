CREATE TABLE [Transacao].[MunicipioIBGE] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [IDUF]   INT           NOT NULL,
    [Codigo] INT           NOT NULL,
    [Nome]   VARCHAR (300) NOT NULL,
    [Slug]   VARCHAR (300) NOT NULL,
    CONSTRAINT [PK_MunicipioIBGE] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UF_Municipio] FOREIGN KEY ([IDUF]) REFERENCES [Transacao].[UF] ([ID])
);

