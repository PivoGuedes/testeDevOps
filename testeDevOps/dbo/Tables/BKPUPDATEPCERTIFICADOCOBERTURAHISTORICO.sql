CREATE TABLE [dbo].[BKPUPDATEPCERTIFICADOCOBERTURAHISTORICO] (
    [IDCerta]                     BIGINT          NOT NULL,
    [NumeroProposta]              VARCHAR (20)    NOT NULL,
    [IDErrada]                    BIGINT          NOT NULL,
    [ValorBrutoAntigo]            DECIMAL (19, 2) NULL,
    [ValorTotal]                  DECIMAL (19, 2) NULL,
    [IDCertificadoPropostaErrada] BIGINT          NOT NULL,
    [ID]                          INT             NOT NULL,
    [IDCertificado]               INT             NOT NULL,
    [IDCobertura]                 SMALLINT        NOT NULL,
    [DataInicioVigencia]          DATE            NULL,
    [DataFimVigencia]             DATE            NULL,
    [ImportanciaSegurada]         DECIMAL (19, 2) NULL,
    [LimiteIndenizacao]           DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]          DECIMAL (19, 2) NULL,
    [Arquivo]                     VARCHAR (100)   NOT NULL,
    [DataArquivo]                 DATE            NOT NULL
);

