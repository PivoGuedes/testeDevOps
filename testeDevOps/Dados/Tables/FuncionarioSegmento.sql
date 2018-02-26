CREATE TABLE [Dados].[FuncionarioSegmento] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [IDFuncionario] INT      NOT NULL,
    [Segmento]      CHAR (1) NOT NULL,
    [DataArquivo]   DATE     NOT NULL,
    CONSTRAINT [pk_FuncionarioSegmento_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_FuncionarioSegmento_IDFuncionario] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID])
);

