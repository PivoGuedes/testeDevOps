CREATE TABLE [dbo].[TESTECOBVIDA] (
    [NumeroApolice]         NUMERIC (13)    NULL,
    [NumeroCertificado]     NUMERIC (15)    NULL,
    [CodigoCobertura]       SMALLINT        NULL,
    [DataInicioVigencia]    DATE            NULL,
    [DataTerminoVigencia]   DATE            NULL,
    [ImportanciaSegurada]   NUMERIC (15, 5) NULL,
    [LimiteIndenizacao]     NUMERIC (15, 5) NULL,
    [ValorPremioLiquido]    NUMERIC (15, 5) NULL,
    [DataArquivo]           DATE            NULL,
    [NomeArquivo]           NVARCHAR (100)  NULL,
    [DataHoraProcessamento] DATETIME2 (7)   NOT NULL,
    [Codigo]                BIGINT          NOT NULL,
    [CodigoProduto]         SMALLINT        NULL
);

