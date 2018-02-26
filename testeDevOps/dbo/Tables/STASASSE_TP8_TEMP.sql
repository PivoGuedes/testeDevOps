CREATE TABLE [dbo].[STASASSE_TP8_TEMP] (
    [Codigo]           BIGINT          NOT NULL,
    [NumeroProposta]   VARCHAR (20)    NULL,
    [IDSeguradora]     INT             NOT NULL,
    [TipoMotivo]       SMALLINT        NULL,
    [TipoMotivo_TP1]   SMALLINT        NULL,
    [SituacaoProposta] VARCHAR (3)     NULL,
    [NumeroParcela]    INT             NULL,
    [Valor]            NUMERIC (13, 2) NULL,
    [TipoDado]         VARCHAR (26)    NULL,
    [DataEfetivacao]   DATE            NULL,
    [NomeArquivo]      VARCHAR (100)   NULL,
    [DataArquivo]      DATE            NULL
);


GO
CREATE CLUSTERED INDEX [idx_STASASSE_TP8_TEMP]
    ON [dbo].[STASASSE_TP8_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

