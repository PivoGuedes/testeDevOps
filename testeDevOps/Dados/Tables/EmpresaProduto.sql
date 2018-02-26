CREATE TABLE [Dados].[EmpresaProduto] (
    [Id]        INT      NOT NULL,
    [IdProduto] INT      NULL,
    [IDEmpresa] SMALLINT NULL,
    CONSTRAINT [FK_EMPRESAPRODUTO_EMPRESA] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID]),
    CONSTRAINT [FK_EMPRESAPRODUTO_PRODUTO] FOREIGN KEY ([IdProduto]) REFERENCES [Dados].[Produto] ([ID])
);

