CREATE TABLE [dbo].[Temp_COMISSAO_SAFAT] (
    [CodigoFilial]          SMALLINT        NULL,
    [CodigoProdutor]        INT             NULL,
    [NumeroRecibo]          NUMERIC (9)     NULL,
    [DataProcessamento]     DATE            NULL,
    [NumeroMatricula]       NUMERIC (15)    NULL,
    [NumeroApolice]         NUMERIC (15)    NULL,
    [NumeroEndosso]         INT             NULL,
    [NumeroParcela]         SMALLINT        NULL,
    [NumeroBilhete]         NUMERIC (15)    NULL,
    [NumeroProposta]        NUMERIC (16)    NULL,
    [CodigoOperacao]        SMALLINT        NULL,
    [ValorCorretagem]       NUMERIC (15, 2) NULL,
    [CodigoFonte]           SMALLINT        NULL,
    [DataArquivo]           DATE            NULL,
    [NomeArquivo]           NVARCHAR (100)  NULL,
    [DataHoraProcessamento] DATETIME2 (7)   NOT NULL,
    [Codigo]                BIGINT          NOT NULL
);

