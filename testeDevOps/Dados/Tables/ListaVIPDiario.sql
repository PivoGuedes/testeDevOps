CREATE TABLE [Dados].[ListaVIPDiario] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [IDEmpresa]   SMALLINT      NOT NULL,
    [Nome]        VARCHAR (100) NOT NULL,
    [CPF]         VARCHAR (20)  NULL,
    [DataSistema] DATE          NULL,
    [RegraVIP]    VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_ListaVIPDiario_Empresa] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID])
);

