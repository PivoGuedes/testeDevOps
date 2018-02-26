CREATE TABLE [Dados].[UsuarioEmpresa] (
    [IDUsuario]         INT      NOT NULL,
    [IDEmpresaContabil] SMALLINT NOT NULL,
    CONSTRAINT [PK_UsuarioEmpresa] PRIMARY KEY CLUSTERED ([IDUsuario] ASC, [IDEmpresaContabil] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_UsuarioEmpresa_EmpresaContabil] FOREIGN KEY ([IDEmpresaContabil]) REFERENCES [Dados].[EmpresaContabil] ([ID]),
    CONSTRAINT [FK_UsuarioEmpresa_Usuario] FOREIGN KEY ([IDUsuario]) REFERENCES [Dados].[Usuario] ([ID])
);

