CREATE TABLE [dbo].[STASASSE_TP1_TEMP] (
    [Codigo]             BIGINT       NOT NULL,
    [NumeroProposta]     VARCHAR (20) NOT NULL,
    [TipoMotivo]         SMALLINT     NULL,
    [SituacaoProposta]   VARCHAR (3)  NULL,
    [DataInicioSituacao] DATE         NULL,
    [DataArquivo]        DATE         NULL,
    [TipoDado]           VARCHAR (30) NULL,
    [IDSeguradora]       SMALLINT     DEFAULT ((1)) NULL
);


GO
CREATE CLUSTERED INDEX [idx_STASASSE_TP1_TEMP]
    ON [dbo].[STASASSE_TP1_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP1_TEMP]
    ON [dbo].[STASASSE_TP1_TEMP]([NumeroProposta] ASC, [IDSeguradora] ASC, [DataInicioSituacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP1_Situacao_TEMP]
    ON [dbo].[STASASSE_TP1_TEMP]([SituacaoProposta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP1_TipoMotivo_TEMP]
    ON [dbo].[STASASSE_TP1_TEMP]([TipoMotivo] ASC) WITH (FILLFACTOR = 90);

