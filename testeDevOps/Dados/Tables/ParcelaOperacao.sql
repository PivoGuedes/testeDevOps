CREATE TABLE [Dados].[ParcelaOperacao] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IDRamo]          SMALLINT      NOT NULL,
    [Codigo]          VARCHAR (4)   NOT NULL,
    [Descricao]       VARCHAR (100) NOT NULL,
    [SinalLancamento] CHAR (1)      NULL,
    CONSTRAINT [pk_ParcelaOperacao_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_Parcela_RamoPAR_ID] FOREIGN KEY ([IDRamo]) REFERENCES [Dados].[RamoPAR] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [unq_ncl_idx_Codigo_Ramo_ParcelaOperacao]
    ON [Dados].[ParcelaOperacao]([Codigo] ASC, [IDRamo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

