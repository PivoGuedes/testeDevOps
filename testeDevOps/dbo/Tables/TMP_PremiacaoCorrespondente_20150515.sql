CREATE TABLE [dbo].[TMP_PremiacaoCorrespondente_20150515] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProdutor]          INT             NOT NULL,
    [IDOperacao]          TINYINT         NOT NULL,
    [IDCorrespondente]    INT             NOT NULL,
    [IDFilialFaturamento] SMALLINT        NULL,
    [NumeroRecibo]        INT             NULL,
    [IDContrato]          BIGINT          NULL,
    [IDProposta]          BIGINT          NULL,
    [NumeroEndosso]       INT             NULL,
    [NumeroParcela]       SMALLINT        NULL,
    [NumeroBilhete]       VARCHAR (20)    NULL,
    [Grupo]               INT             NULL,
    [Cota]                INT             NULL,
    [ValorCorretagem]     DECIMAL (19, 2) NULL,
    [DataProcessamento]   DATE            NULL,
    [NumeroContrato]      VARCHAR (20)    NULL,
    [NumeroProposta]      VARCHAR (20)    NULL,
    [Arquivo]             VARCHAR (80)    NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    [IDTipoProduto]       TINYINT         NOT NULL
);

