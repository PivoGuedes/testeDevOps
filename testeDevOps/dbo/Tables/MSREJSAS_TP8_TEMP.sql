CREATE TABLE [dbo].[MSREJSAS_TP8_TEMP] (
    [CodigoNaFonte]   BIGINT          NOT NULL,
    [NumeroProposta]  VARCHAR (20)    NULL,
    [ParcelaProposta] INT             NULL,
    [TipoMotivo]      SMALLINT        NULL,
    [TipoLancamento]  SMALLINT        NULL,
    [Valor]           NUMERIC (13, 2) NULL,
    [ValorEstoque]    NUMERIC (13, 2) NULL,
    [DataLancamento]  DATE            NULL,
    [DataArquivo]     DATE            NULL,
    [TipoDado]        NVARCHAR (100)  NULL,
    [NomeArquivo]     NVARCHAR (100)  NULL,
    [IDSeguradora]    INT             DEFAULT ((1)) NULL
);


GO
CREATE CLUSTERED INDEX [idx_MSREJSAS_TP8_TEMP]
    ON [dbo].[MSREJSAS_TP8_TEMP]([CodigoNaFonte] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

