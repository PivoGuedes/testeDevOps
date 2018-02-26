CREATE TABLE [Dados].[PremiacaoCorrespondenteBKPUpdateMes10] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProdutor]          INT             NOT NULL,
    [IDOperacao]          TINYINT         NOT NULL,
    [IDCorrespondente]    INT             NOT NULL,
    [IDFilialFaturamento] SMALLINT        NULL,
    [NumeroRecibo]        BIGINT          NULL,
    [IDContrato]          BIGINT          NULL,
    [IDProposta]          BIGINT          NULL,
    [NumeroEndosso]       BIGINT          NULL,
    [NumeroParcela]       SMALLINT        NULL,
    [NumeroBilhete]       VARCHAR (20)    NULL,
    [Grupo]               BIGINT          NULL,
    [Cota]                BIGINT          NULL,
    [ValorCorretagem]     DECIMAL (19, 2) NULL,
    [DataProcessamento]   DATE            NULL,
    [NumeroContrato]      VARCHAR (20)    NULL,
    [NumeroProposta]      VARCHAR (20)    NULL,
    [Arquivo]             VARCHAR (80)    NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    [IDTipoProduto]       TINYINT         NOT NULL
);

