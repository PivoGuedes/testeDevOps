CREATE TABLE [dbo].[ENSOSSO_STASASSE_TEMP] (
    [Codigo]                BIGINT          NOT NULL,
    [NumeroProposta]        VARCHAR (20)    NULL,
    [NumeroPropostaTratado] AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroProposta]))) PERSISTED,
    [NumeroContrato]        VARCHAR (20)    NOT NULL,
    [IDSeguradora]          INT             NOT NULL,
    [DataInicioVigencia]    DATE            NOT NULL,
    [DataFimVigencia]       DATE            NULL,
    [ValorDiferencaEndosso] NUMERIC (16, 2) NOT NULL,
    [ValorPremioLiquido]    NUMERIC (16, 2) NOT NULL,
    [ValorIOF]              NUMERIC (16, 2) NOT NULL,
    [DataEmissao]           DATE            NULL,
    [DataArquivo]           DATE            NULL
);


GO
CREATE CLUSTERED INDEX [idx_ENSOSSO_STASASSE_TEMP]
    ON [dbo].[ENSOSSO_STASASSE_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_NumeroProposta_ENSOSSO_STASASSE_TEMP]
    ON [dbo].[ENSOSSO_STASASSE_TEMP]([NumeroProposta] ASC)
    INCLUDE([NumeroPropostaTratado], [IDSeguradora], [DataEmissao]) WITH (FILLFACTOR = 100);

