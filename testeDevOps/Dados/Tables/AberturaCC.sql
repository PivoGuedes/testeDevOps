CREATE TABLE [Dados].[AberturaCC] (
    [ID]                INT          IDENTITY (1, 1) NOT NULL,
    [CodigoUnidade]     SMALLINT     NOT NULL,
    [CodigoOperacao]    SMALLINT     NOT NULL,
    [IDCliente]         INT          NULL,
    [NumeroConta]       VARCHAR (50) NOT NULL,
    [DataAberturaConta] DATE         NULL,
    [TipoDado]          VARCHAR (50) NOT NULL,
    [DataArquivo]       DATE         NOT NULL,
    [CCA]               BIT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [pk_AberturaCC_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [unq_ncl_idx_CPFCNPJ]
    ON [Dados].[AberturaCC]([NumeroConta] ASC, [CodigoOperacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

