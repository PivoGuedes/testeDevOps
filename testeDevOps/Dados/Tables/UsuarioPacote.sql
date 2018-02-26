CREATE TABLE [Dados].[UsuarioPacote] (
    [IDUsuario] INT      NOT NULL,
    [IDPacote]  SMALLINT NOT NULL,
    CONSTRAINT [PK_UsuarioPacote] PRIMARY KEY CLUSTERED ([IDUsuario] ASC, [IDPacote] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_UsuarioPacote_Pacote] FOREIGN KEY ([IDPacote]) REFERENCES [Dados].[Pacote] ([ID]),
    CONSTRAINT [FK_UsuarioPacote_Usuario] FOREIGN KEY ([IDUsuario]) REFERENCES [Dados].[Usuario] ([ID])
);

