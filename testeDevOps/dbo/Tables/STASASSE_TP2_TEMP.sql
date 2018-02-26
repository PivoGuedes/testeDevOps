CREATE TABLE [dbo].[STASASSE_TP2_TEMP] (
    [Codigo]                   BIGINT          NOT NULL,
    [IDSeguradora]             INT             NOT NULL,
    [NumeroProposta]           VARCHAR (20)    NULL,
    [NumeroCertificado]        VARCHAR (20)    NULL,
    [DataInicioVigencia]       DATE            NULL,
    [DataFimVigencia]          DATE            NULL,
    [SituacaoProposta]         VARCHAR (3)     NULL,
    [TipoMotivo]               VARCHAR (3)     NULL,
    [NumeroParcela]            INT             NOT NULL,
    [Valor]                    NUMERIC (15, 2) NULL,
    [ValorIOF]                 NUMERIC (15, 2) NULL,
    [TipoDado]                 VARCHAR (26)    NULL,
    [DataEfetivacao]           DATE            NULL,
    [DataArquivo]              DATE            NULL,
    [NomeArquivo]              VARCHAR (100)   NULL,
    [Rank]                     BIGINT          NULL,
    [NumeroCertificadoTratado] AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroCertificado]))) PERSISTED
);


GO
CREATE CLUSTERED INDEX [idx_STASASSE_TP2_TEMP]
    ON [dbo].[STASASSE_TP2_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 90);

