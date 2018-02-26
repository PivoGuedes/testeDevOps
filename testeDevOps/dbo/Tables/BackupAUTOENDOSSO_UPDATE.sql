CREATE TABLE [dbo].[BackupAUTOENDOSSO_UPDATE] (
    [IDContrato]           BIGINT          NULL,
    [qtdEnd]               INT             NULL,
    [NumeroEndosso]        INT             NOT NULL,
    [IDAU]                 BIGINT          NOT NULL,
    [IDPropostaAU]         BIGINT          NULL,
    [DataEmissaoAU]        DATE            NULL,
    [ValorPremioTotalAU]   DECIMAL (19, 2) NULL,
    [IDProdutoAU]          INT             NOT NULL,
    [ValorPremioLiquidoAU] DECIMAL (19, 2) NULL,
    [QuantidadeParcelasAU] TINYINT         NULL,
    [ValorIOFAU]           DECIMAL (19, 2) NULL,
    [IDOU]                 BIGINT          NOT NULL,
    [IDPropostaOU]         BIGINT          NULL,
    [DataEmissaoOU]        DATE            NULL,
    [ValorPremioTotalOU]   DECIMAL (19, 2) NULL,
    [IDProdutoOU]          INT             NOT NULL,
    [ValorPremioLiquidoOU] DECIMAL (19, 2) NULL,
    [QuantidadeParcelasOU] TINYINT         NULL,
    [ValorIOFOU]           DECIMAL (19, 2) NULL
);

