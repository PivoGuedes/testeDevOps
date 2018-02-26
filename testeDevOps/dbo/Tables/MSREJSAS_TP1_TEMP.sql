CREATE TABLE [dbo].[MSREJSAS_TP1_TEMP] (
    [Codigo]                BIGINT         NOT NULL,
    [NumeroProposta]        VARCHAR (20)   NULL,
    [SituacaoProposta]      VARCHAR (3)    NULL,
    [TipoMotivo]            VARCHAR (3)    NULL,
    [DataInicioSituacao]    DATE           NULL,
    [SequencialArquivo]     INT            NULL,
    [SequencialProposta]    INT            NULL,
    [DataArquivo]           DATE           NULL,
    [NomeArquivo]           NVARCHAR (100) NULL,
    [Motivo]                CHAR (3)       NULL,
    [DataHoraProcessamento] DATETIME2 (7)  NOT NULL,
    [TipoArquivo]           VARCHAR (30)   NOT NULL,
    [IDSeguradora]          SMALLINT       DEFAULT ((1)) NULL
);


GO
CREATE CLUSTERED INDEX [idx_MSREJSAS_TP1_TEMP]
    ON [dbo].[MSREJSAS_TP1_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idxNCL_MSREJSAS_TP1_TEMP]
    ON [dbo].[MSREJSAS_TP1_TEMP]([NumeroProposta] ASC, [IDSeguradora] ASC, [DataInicioSituacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idxNCL_MSREJSAS_TP1_Situacao_TEMP]
    ON [dbo].[MSREJSAS_TP1_TEMP]([SituacaoProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idxNCL_MSREJSAS_TP1_TipoMotivo_TEMP]
    ON [dbo].[MSREJSAS_TP1_TEMP]([TipoMotivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

