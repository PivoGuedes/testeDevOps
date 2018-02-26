CREATE TABLE [dbo].[STAFCAP_TP2_TEMP] (
    [Codigo]                   BIGINT          NOT NULL,
    [NumeroProposta]           VARCHAR (20)    NOT NULL,
    [NumeroOrdemTitular]       SMALLINT        NULL,
    [SerieTitulo]              CHAR (2)        NULL,
    [NumeroTitulo]             CHAR (7)        NULL,
    [DigitoNumeroTitulo]       CHAR (1)        NULL,
    [SituacaoTitulo]           CHAR (3)        NULL,
    [DataInicioSituacaoTitulo] DATE            NULL,
    [DataPostagemTitulo]       DATE            NULL,
    [DataInicioVigencia]       DATE            NULL,
    [DataInicioSorteio]        DATE            NULL,
    [NumeroCombinacao]         INT             NULL,
    [ValorTitulo]              NUMERIC (17, 2) NULL,
    [CodigoPlanoSUSEP]         INT             NULL,
    [MotivoSituacaoTitulo]     INT             NULL,
    [DataArquivo]              DATE            NULL,
    [NomeArquivo]              VARCHAR (130)   NULL,
    [IDSeguradora]             SMALLINT        DEFAULT ((3)) NULL
);


GO
CREATE CLUSTERED INDEX [idx_STASASSE_TP2_TEMP]
    ON [dbo].[STAFCAP_TP2_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP2_TEMP]
    ON [dbo].[STAFCAP_TP2_TEMP]([NumeroProposta] ASC, [IDSeguradora] ASC, [DataInicioSituacaoTitulo] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP2_SituacaoTitulo_TEMP]
    ON [dbo].[STAFCAP_TP2_TEMP]([SituacaoTitulo] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxNCL_STASASSE_TP2_MotivoSituacaoTitulo_TEMP]
    ON [dbo].[STAFCAP_TP2_TEMP]([MotivoSituacaoTitulo] ASC) WITH (FILLFACTOR = 90);

