CREATE TABLE [Dados].[AVGestaoBloco] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [IDUnidade]               SMALLINT        NOT NULL,
    [IDBloco]                 SMALLINT        NOT NULL,
    [IDSegmento]              SMALLINT        NULL,
    [AnoPeriodo]              SMALLINT        NULL,
    [MesPeriodo]              SMALLINT        NULL,
    [ValorRealizadoMensal]    NUMERIC (15, 2) NULL,
    [ValorRealizadoAcumulado] NUMERIC (15, 2) NULL,
    [ValorNegociado]          NUMERIC (15, 2) NULL,
    [PercentualRealizado]     NUMERIC (10, 3) NULL,
    [PercentualEsperado]      NUMERIC (10, 3) NULL,
    [Mensuracao]              VARCHAR (10)    NULL,
    [DataProcessamento]       DATE            NOT NULL,
    [CodigoUnidade]           SMALLINT        NULL,
    [CodigoSegmento]          CHAR (5)        NULL,
    [Arquivo]                 VARCHAR (100)   NOT NULL,
    [DataArquivo]             DATE            NOT NULL,
    [LastValue]               BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Dados_AVGestaoBloco_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Dados_AVGestaoBloco_Bloco_ID] FOREIGN KEY ([IDBloco]) REFERENCES [Dados].[Bloco] ([ID]),
    CONSTRAINT [FK_Dados_AVGestaoBloco_Segmento_ID] FOREIGN KEY ([IDSegmento]) REFERENCES [Dados].[Segmento] ([ID]),
    CONSTRAINT [FK_Dados_AVGestaoBloco_Unidade_ID] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [UNQ_Dados_AVGestaoBloco_DataArquivo_Unidade_Bloco_Segmento_AnoPeriodo_DataProcessamento] UNIQUE NONCLUSTERED ([IDUnidade] ASC, [IDBloco] ASC, [IDSegmento] ASC, [AnoPeriodo] ASC, [MesPeriodo] ASC, [Arquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
ALTER TABLE [Dados].[AVGestaoBloco] NOCHECK CONSTRAINT [FK_Dados_AVGestaoBloco_Bloco_ID];


GO
ALTER TABLE [Dados].[AVGestaoBloco] NOCHECK CONSTRAINT [FK_Dados_AVGestaoBloco_Segmento_ID];


GO
ALTER TABLE [Dados].[AVGestaoBloco] NOCHECK CONSTRAINT [FK_Dados_AVGestaoBloco_Unidade_ID];


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_AVGestaoBloco]
    ON [Dados].[AVGestaoBloco]([IDUnidade] ASC, [IDBloco] ASC, [IDSegmento] ASC, [AnoPeriodo] ASC, [MesPeriodo] ASC, [DataProcessamento] ASC, [DataArquivo] ASC)
    INCLUDE([ID], [ValorRealizadoMensal], [ValorRealizadoAcumulado], [ValorNegociado], [PercentualRealizado], [PercentualEsperado], [Mensuracao], [CodigoUnidade], [CodigoSegmento], [Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NCL_F_AVGestaoBloco]
    ON [Dados].[AVGestaoBloco]([IDUnidade] ASC, [IDBloco] ASC, [IDSegmento] ASC, [AnoPeriodo] ASC, [MesPeriodo] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_AnoMesDataArquivo]
    ON [Dados].[AVGestaoBloco]([AnoPeriodo] ASC, [MesPeriodo] ASC, [DataArquivo] ASC)
    INCLUDE([ID], [IDUnidade], [IDBloco], [IDSegmento], [ValorRealizadoMensal], [ValorRealizadoAcumulado], [ValorNegociado], [PercentualRealizado], [PercentualEsperado], [Mensuracao], [DataProcessamento], [CodigoUnidade], [CodigoSegmento], [Arquivo], [LastValue]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

