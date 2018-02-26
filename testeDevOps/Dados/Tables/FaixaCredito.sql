CREATE TABLE [Dados].[FaixaCredito] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [Descricao]    VARCHAR (100)   NULL,
    [ValorInicial] DECIMAL (18, 2) NULL,
    [ValorFinal]   DECIMAL (18, 2) NULL,
    CONSTRAINT [pk_FaixaCredito] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_ValorInicial_Final_FaixaCredito]
    ON [Dados].[FaixaCredito]([ValorInicial] ASC, [ValorFinal] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

