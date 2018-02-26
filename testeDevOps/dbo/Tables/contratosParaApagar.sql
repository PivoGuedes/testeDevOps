CREATE TABLE [dbo].[contratosParaApagar] (
    [IDContrato]          BIGINT       NULL,
    [IDPropostaPagamento] BIGINT       NULL,
    [NumeroContrato]      VARCHAR (20) NULL,
    [NumeroProposta]      VARCHAR (20) NOT NULL
);

