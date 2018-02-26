CREATE TABLE [Dados].[UsuarioCentroCusto] (
    [IDUsuario]         INT          NOT NULL,
    [CodigoCentroCusto] VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_UsuarioCentroCusto] PRIMARY KEY CLUSTERED ([IDUsuario] ASC, [CodigoCentroCusto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_UsuarioCentroCusto_Usuario] FOREIGN KEY ([IDUsuario]) REFERENCES [Dados].[Usuario] ([ID])
);

