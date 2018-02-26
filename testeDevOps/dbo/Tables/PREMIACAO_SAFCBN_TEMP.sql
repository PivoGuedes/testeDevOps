CREATE TABLE [dbo].[PREMIACAO_SAFCBN_TEMP] (
    [NomeArquivo]             NVARCHAR (100)  NULL,
    [DataArquivo]             DATE            NULL,
    [ControleVersao]          DECIMAL (16, 8) NULL,
    [Codigo]                  BIGINT          NOT NULL,
    [CodigoProdutor]          INT             NOT NULL,
    [NumeroRecibo]            BIGINT          NOT NULL,
    [NumeroMatricula]         BIGINT          NOT NULL,
    [NumeroApolice]           VARCHAR (20)    NOT NULL,
    [NumeroEndosso]           BIGINT          NOT NULL,
    [NumeroParcela]           SMALLINT        NOT NULL,
    [NumeroBilhete]           VARCHAR (20)    NULL,
    [NumeroProposta]          VARCHAR (20)    NULL,
    [CodigoOperacao]          SMALLINT        NULL,
    [CodigoFilialFaturamento] SMALLINT        NULL,
    [ValorCorretagem]         NUMERIC (15, 2) NULL,
    [DataProcessamento]       DATE            NULL,
    [IDTipoProduto]           TINYINT         DEFAULT ((1)) NOT NULL
);

