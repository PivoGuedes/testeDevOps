CREATE TABLE [dbo].[VENDAS] (
    [NumeroCertificado]    VARCHAR (20)    NULL,
    [NumeroProposta]       VARCHAR (20)    NULL,
    [CodigoFilial]         SMALLINT        NULL,
    [NumeroReciboCobranca] NUMERIC (15)    NULL,
    [NumeroBilhete]        NUMERIC (15)    NULL,
    [CodigoProduto]        SMALLINT        NULL,
    [DataMovimentacao]     DATE            NULL,
    [DataQuitacao]         DATE            NULL,
    [ValorPremioTotal]     NUMERIC (16, 2) NULL,
    [ValorPremioLiquido]   NUMERIC (16, 2) NULL,
    [DataArquivo]          DATE            NULL
);


GO
CREATE CLUSTERED INDEX [CL_VENDAS]
    ON [dbo].[VENDAS]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

