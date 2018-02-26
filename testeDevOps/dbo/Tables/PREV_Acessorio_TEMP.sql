CREATE TABLE [dbo].[PREV_Acessorio_TEMP] (
    [Codigo]                          BIGINT          NOT NULL,
    [ControleVersao]                  DECIMAL (16, 8) NULL,
    [NomeArquivo]                     VARCHAR (100)   NULL,
    [TipoArquivo]                     VARCHAR (30)    NULL,
    [DataArquivo]                     DATE            NULL,
    [NumeroProposta]                  NUMERIC (14)    NULL,
    [NumeroPropostaTratado]           AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroProposta]))) PERSISTED,
    [CodigoAcessorio]                 SMALLINT        NULL,
    [Acessorio]                       VARCHAR (27)    NULL,
    [IndicadorPerc_ValorContribuicao] VARCHAR (1)     NULL,
    [PrazoPercepcao]                  TINYINT         NULL,
    [PeriodicidadePagamentoProtecao]  CHAR (1)        NULL,
    [ValorBeneficio]                  DECIMAL (19, 2) NULL,
    [ValorContribuicao]               DECIMAL (19, 2) NULL
);


GO
CREATE CLUSTERED INDEX [idx_PREV_Acessorio_TEMP]
    ON [dbo].[PREV_Acessorio_TEMP]([NumeroPropostaTratado] ASC, [CodigoAcessorio] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_PREV_Acessorio_CodigoAcessorio_TEMP]
    ON [dbo].[PREV_Acessorio_TEMP]([CodigoAcessorio] ASC) WITH (FILLFACTOR = 90);

