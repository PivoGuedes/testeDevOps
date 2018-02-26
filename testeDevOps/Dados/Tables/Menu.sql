CREATE TABLE [Dados].[Menu] (
    [ID]             SMALLDATETIME NOT NULL,
    [IDPerfil]       SMALLINT      NOT NULL,
    [Nome]           VARCHAR (20)  NOT NULL,
    [ActionName]     VARCHAR (20)  NOT NULL,
    [ControllerName] VARCHAR (10)  NOT NULL,
    [Url]            VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Menu_Perfil] FOREIGN KEY ([IDPerfil]) REFERENCES [Dados].[Perfil] ([ID])
);

