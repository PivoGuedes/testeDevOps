CREATE TABLE [dbo].[PROPOSTA_BACKUP_PRESTAMISTA_PRODUTO] (
    [NumeroProposta]       VARCHAR (20) NOT NULL,
    [ID]                   BIGINT       NOT NULL,
    [CodigoComercializado] VARCHAR (5)  NULL,
    [VCPPCodigoProduto]    VARCHAR (5)  NULL,
    [IDAgenciaVenda]       SMALLINT     NULL,
    [CodigoPontoVenda]     VARCHAR (4)  NULL
);

