CREATE TABLE [ControleDados].[LogEMIOUTR] (
    [IDEndosso]           BIGINT          NOT NULL,
    [IDCobertura]         SMALLINT        NOT NULL,
    [NumeroApolice]       VARCHAR (20)    NOT NULL,
    [NumeroEndosso]       INT             NOT NULL,
    [NumeroItem]          SMALLINT        NULL,
    [RamoCobertura]       SMALLINT        NULL,
    [CodigoCobertura]     SMALLINT        NULL,
    [DataInicioVigencia]  DATE            NULL,
    [DataFimVigencia]     DATE            NULL,
    [ImportanciaSegurada] NUMERIC (15, 5) NULL,
    [LimiteIndenizacao]   NUMERIC (15, 5) NULL,
    [ValorPremioLiquido]  NUMERIC (15, 5) NULL,
    [ValorFranquia]       NUMERIC (15, 5) NULL,
    [DataArquivo]         DATE            NOT NULL,
    [Arquivo]             VARCHAR (100)   NOT NULL,
    [RANQ]                SMALLINT        NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RANQ_LogEMIOUTR]
    ON [ControleDados].[LogEMIOUTR]([RANQ] ASC)
    INCLUDE([IDEndosso], [IDCobertura], [NumeroApolice], [NumeroEndosso], [NumeroItem], [RamoCobertura], [CodigoCobertura], [DataInicioVigencia], [DataFimVigencia], [ImportanciaSegurada], [LimiteIndenizacao], [ValorPremioLiquido], [ValorFranquia], [DataArquivo], [Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

