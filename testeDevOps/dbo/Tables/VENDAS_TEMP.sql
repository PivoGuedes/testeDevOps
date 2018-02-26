CREATE TABLE [dbo].[VENDAS_TEMP] (
    [NumeroCertificado]    VARCHAR (20)    NULL,
    [NumeroReciboCobranca] VARCHAR (20)    NULL,
    [CodigoFilial]         SMALLINT        NULL,
    [NumeroProposta]       VARCHAR (20)    NULL,
    [NumeroBilhete]        VARCHAR (20)    NULL,
    [CodigoProduto]        SMALLINT        NULL,
    [CodigoAgencia]        SMALLINT        NULL,
    [DataQuitacao]         DATE            NOT NULL,
    [ValorPremioTotal]     NUMERIC (15, 2) NULL,
    [DataMovimentacao]     DATE            NOT NULL,
    [ValorPremioLiquido]   NUMERIC (15, 2) NULL,
    [CodigoOperacao]       SMALLINT        NULL,
    [DataArquivo]          DATE            NOT NULL,
    [NomeArquivo]          VARCHAR (100)   NOT NULL,
    [ControleVersao]       NUMERIC (16, 8) NULL,
    [Codigo]               BIGINT          NULL
);

