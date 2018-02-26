CREATE TABLE [dbo].[BKPUPDATEPCERTIFICADO] (
    [id]                 BIGINT          NOT NULL,
    [NumeroProposta]     VARCHAR (20)    NOT NULL,
    [IDErrada]           BIGINT          NOT NULL,
    [IDContrato]         BIGINT          NULL,
    [IDProposta]         BIGINT          NULL,
    [ValorPremioBruto]   DECIMAL (19, 2) NULL,
    [ValorPremioLiquido] DECIMAL (19, 2) NULL,
    [IDCertificado]      INT             NOT NULL,
    [DataArquivo]        DATE            NOT NULL,
    [ValorBrutoAntigo]   DECIMAL (19, 2) NULL,
    [ValorLiquidoAntigo] DECIMAL (19, 2) NULL
);

