CREATE TABLE [Financeiro].[PagamentosIncorretos] (
    [Contrato]            BIGINT          NULL,
    [ID]                  INT             NULL,
    [IDProdutor]          INT             NULL,
    [IDOperacao]          INT             NULL,
    [IDCorrespondente]    INT             NULL,
    [IDFilialFaturamento] INT             NULL,
    [NumeroRecibo]        BIGINT          NULL,
    [IDContrato]          INT             NULL,
    [IDProposta]          INT             NULL,
    [Endosso]             BIGINT          NULL,
    [NumeroParcela]       INT             NULL,
    [Bilhete]             BIGINT          NULL,
    [ValorCorretagem]     DECIMAL (18, 2) NULL,
    [DataProcessamento]   VARCHAR (100)   NULL,
    [Proposta]            BIGINT          NULL,
    [Arquivo]             VARCHAR (100)   NULL,
    [DataArquivo]         DATE            NULL
);

