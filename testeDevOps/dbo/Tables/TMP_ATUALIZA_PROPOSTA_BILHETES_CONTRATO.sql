CREATE TABLE [dbo].[TMP_ATUALIZA_PROPOSTA_BILHETES_CONTRATO] (
    [IDProposta]                        BIGINT          NULL,
    [IDContrato]                        BIGINT          NULL,
    [IDProduto]                         INT             NULL,
    [DataInicioVigencia]                DATE            NULL,
    [DataFimVigencia]                   DATE            NULL,
    [ValorPremioLiquidoEmissao]         DECIMAL (19, 2) NULL,
    [ValorPremioBrutoEmissao]           DECIMAL (19, 2) NULL,
    [ValorPremioTotal]                  DECIMAL (19, 2) NULL,
    [IDPropostaInserted]                BIGINT          NULL,
    [IDContratoInserted]                BIGINT          NULL,
    [IDProdutoInserted]                 INT             NULL,
    [DataInicioVigenciaInserted]        DATE            NULL,
    [DataFimVigenciaInserted]           DATE            NULL,
    [ValorPremioLiquidoEmissaoInserted] DECIMAL (19, 2) NULL,
    [ValorPremioBrutoEmissaoInserted]   DECIMAL (19, 2) NULL,
    [ValorPremioTotalInserted]          DECIMAL (19, 2) NULL
);

