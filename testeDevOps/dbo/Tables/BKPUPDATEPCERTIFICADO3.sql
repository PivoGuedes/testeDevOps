CREATE TABLE [dbo].[BKPUPDATEPCERTIFICADO3] (
    [id]                 BIGINT          NOT NULL,
    [NumeroProposta]     VARCHAR (20)    NOT NULL,
    [IDErrada]           BIGINT          NOT NULL,
    [ValorBrutoAntigo]   DECIMAL (19, 2) NULL,
    [ValorLiquidoAntigo] DECIMAL (19, 2) NULL,
    [DataInicioVigencia] DATE            NULL,
    [DataFimVigencia]    DATE            NULL,
    [DataCancelamento]   DATE            NULL,
    [ValorPremioBruto]   DECIMAL (19, 2) NULL,
    [ValorPremioLiquido] DECIMAL (19, 2) NULL,
    [DataArquivo]        DATE            NOT NULL,
    [Arquivo]            VARCHAR (80)    NOT NULL
);

