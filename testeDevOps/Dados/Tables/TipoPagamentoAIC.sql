CREATE TABLE [Dados].[TipoPagamentoAIC] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Codigo]    VARCHAR (20)  NULL,
    [Descricao] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

