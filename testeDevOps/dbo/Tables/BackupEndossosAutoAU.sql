CREATE TABLE [dbo].[BackupEndossosAutoAU] (
    [ID]                   BIGINT          NOT NULL,
    [IDContrato]           BIGINT          NOT NULL,
    [IDProduto]            INT             NOT NULL,
    [IDProposta]           BIGINT          NULL,
    [CodigoSubestipulante] SMALLINT        NULL,
    [NumeroEndosso]        INT             NOT NULL,
    [DataEmissao]          DATE            NULL,
    [DataInicioVigencia]   DATE            NULL,
    [DataFimVigencia]      DATE            NULL,
    [ValorPremioTotal]     DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]   DECIMAL (19, 2) NULL,
    [IDTipoEndosso]        TINYINT         NULL,
    [IDSituacaoEndosso]    TINYINT         NULL,
    [QuantidadeParcelas]   TINYINT         NULL,
    [DataArquivo]          DATE            NOT NULL,
    [Arquivo]              VARCHAR (80)    NOT NULL,
    [ValorPremioTarifario] DECIMAL (19, 2) NULL,
    [ValorIOF]             DECIMAL (19, 2) NULL,
    [IDRamo]               SMALLINT        NULL,
    [IDFilialFaturamento]  SMALLINT        NULL
);

