CREATE TABLE [dbo].[BKPCORRECAOPAGAMENTOS] (
    [id]             BIGINT       NOT NULL,
    [NumeroProposta] VARCHAR (20) NOT NULL,
    [IDErrada]       BIGINT       NOT NULL,
    [IDPagamento]    BIGINT       NOT NULL,
    [IDPGERRADO]     BIGINT       NULL,
    [Parcela]        SMALLINT     NULL
);

