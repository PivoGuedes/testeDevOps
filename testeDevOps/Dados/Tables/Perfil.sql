CREATE TABLE [Dados].[Perfil] (
    [ID]            SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Descricao]     VARCHAR (50) NOT NULL,
    [IDEmpresa]     SMALLINT     NULL,
    [IDCentroCusto] SMALLINT     NULL,
    [IDUsuario]     INT          NULL,
    CONSTRAINT [PK_Perfil] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Perfil_Usuario] FOREIGN KEY ([IDUsuario]) REFERENCES [Dados].[Usuario] ([ID])
);

