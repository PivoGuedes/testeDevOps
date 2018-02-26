CREATE TABLE [dbo].[BASE_CAPITAL_GIRO] (
    [NmTransacao]    VARCHAR (15)   NOT NULL,
    [NuContrato]     NVARCHAR (255) NULL,
    [CdModalidade]   FLOAT (53)     NULL,
    [CdSituacao]     FLOAT (53)     NULL,
    [CdUnidade]      FLOAT (53)     NULL,
    [IDProduto]      FLOAT (53)     NULL,
    [DtTransacao]    NVARCHAR (255) NULL,
    [VlrCredito]     NUMERIC (18)   NULL,
    [CdCliente]      NVARCHAR (255) NULL,
    [TxJuros]        FLOAT (53)     NULL,
    [PrazoPagamento] FLOAT (53)     NULL
);

