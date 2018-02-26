CREATE TABLE [dbo].[EndossoParcelaTMP] (
    [ID]                    BIGINT          NOT NULL,
    [IDEndosso]             BIGINT          NULL,
    [NumeroParcela]         INT             NULL,
    [NumeroTitulo]          VARCHAR (13)    NULL,
    [ValorPremioLiquido]    DECIMAL (19, 2) NULL,
    [DataVencimento]        DATE            NULL,
    [QuantidadeOcorrencias] SMALLINT        NULL,
    [IDSituacaoParcela]     TINYINT         NULL,
    [DataArquivo]           DATE            NULL,
    [DataEmissao]           DATE            NOT NULL,
    [DataSistema]           DATETIME2 (7)   NULL,
    [IDParcelaOperacao]     INT             NULL,
    [TipoDado]              VARCHAR (30)    NULL,
    [NomeArquivo]           VARCHAR (100)   NULL
);

