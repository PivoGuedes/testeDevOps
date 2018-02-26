CREATE TABLE [dbo].[BKPUPDATEPROPOSTACOBERTURA] (
    [id]                       BIGINT          NOT NULL,
    [NumeroProposta]           VARCHAR (20)    NOT NULL,
    [IDErrada]                 BIGINT          NOT NULL,
    [IDCobertura]              SMALLINT        NOT NULL,
    [IDTipoCobertura]          TINYINT         NOT NULL,
    [ValorPremio]              DECIMAL (19, 2) NULL,
    [ValorImportanciaSegurada] DECIMAL (19, 2) NULL,
    [IDPropostaCobertura]      BIGINT          NOT NULL
);

