CREATE TABLE [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] (
    [Codigo]             BIGINT          NOT NULL,
    [NumeroProposta]     VARCHAR (20)    NOT NULL,
    [SituacaoCobranca]   CHAR (3)        NULL,
    [DataInicioSituacao] DATE            NULL,
    [NomeArquivo]        VARCHAR (100)   NULL,
    [TipoDado]           VARCHAR (20)    NULL,
    [DataArquivo]        DATE            NULL,
    [ControleVersao]     DECIMAL (16, 8) NULL,
    [IDProposta]         INT             NULL,
    [IDSituacaoCobranca] TINYINT         NULL
);


GO
CREATE CLUSTERED INDEX [idx_SituacaoPagamento_STAFPREV_TEMP]
    ON [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NumeroProposta_STAFPREV_TEMP]
    ON [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP]([NumeroProposta] ASC, [SituacaoCobranca] ASC, [DataInicioSituacao] ASC, [DataArquivo] DESC, [Codigo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

