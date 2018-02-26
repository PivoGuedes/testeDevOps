CREATE TABLE [Dados].[ClienteCC] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [DataNascimento]  DATE         NULL,
    [NomeCliente]     VARCHAR (50) NOT NULL,
    [CPFCNPJ]         VARCHAR (18) NOT NULL,
    [TipoDado]        VARCHAR (50) NOT NULL,
    [DataArquivo]     DATE         NOT NULL,
    [IDAberturaConta] INT          NOT NULL,
    CONSTRAINT [pk_ClienteCC_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_IDAberturaCC] FOREIGN KEY ([IDAberturaConta]) REFERENCES [Dados].[AberturaCC] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ncl_idx_CPFCNPJ]
    ON [Dados].[ClienteCC]([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

