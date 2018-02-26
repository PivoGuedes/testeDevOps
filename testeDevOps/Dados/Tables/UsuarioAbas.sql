CREATE TABLE [Dados].[UsuarioAbas] (
    [IDUsuario] INT     NOT NULL,
    [IDAbas]    TINYINT NOT NULL,
    CONSTRAINT [PK_UsuarioAbas] PRIMARY KEY CLUSTERED ([IDUsuario] ASC, [IDAbas] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_UsuarioAbas_Abas] FOREIGN KEY ([IDAbas]) REFERENCES [Dados].[Abas] ([ID]),
    CONSTRAINT [FK_UsuarioAbas_Usuario] FOREIGN KEY ([IDUsuario]) REFERENCES [Dados].[Usuario] ([ID])
);

