CREATE TABLE [dbo].[PagamentosProtheus_TEMP] (
    [ID]                                INT             IDENTITY (1, 1) NOT NULL,
    [IDMotivo]                          INT             NULL,
    [IDMotivoSituacao]                  INT             NULL,
    [IDEndosso]                         INT             NULL,
    [IDSituacaoProposta]                INT             NULL,
    [NumeroParcela]                     INT             NULL,
    [NumeroTitulo]                      VARCHAR (12)    NULL,
    [Valor]                             DECIMAL (24, 4) NULL,
    [ValorIOF]                          DECIMAL (24, 4) NULL,
    [DataEfetivacao]                    DATE            NULL,
    [DataArquivo]                       DATE            NULL,
    [CodigoNaFonte]                     INT             NULL,
    [TipoDado]                          VARCHAR (12)    NULL,
    [EfetivacaoPgtoEstimadoPelaEmissao] INT             NULL,
    [SinalLancamento]                   VARCHAR (5)     NULL,
    [ExpectativaDeReceita]              VARCHAR (12)    NULL,
    [Arquivo]                           VARCHAR (80)    NULL,
    [DataInicioVigencia]                VARCHAR (12)    NULL,
    [DataFimVigencia]                   VARCHAR (12)    NULL,
    [ParcelaCalculada]                  INT             NULL,
    [SaldoProcessado]                   INT             NULL,
    [DataEmissao]                       VARCHAR (12)    NULL,
    [DataVencimento]                    VARCHAR (12)    NULL,
    [Empresa]                           VARCHAR (12)    NULL,
    [cliente]                           VARCHAR (12)    NULL,
    [AnoMesBase]                        VARCHAR (12)    NULL,
    [NumeroProposta]                    VARCHAR (20)    NOT NULL,
    [Operadora]                         VARCHAR (4)     NOT NULL,
    [MotivoBaixa]                       VARCHAR (3)     NULL,
    [Ranking]                           INT             NOT NULL,
    CONSTRAINT [PK_PagamentosProtheus_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_PagamentosProtheus_TEMP]
    ON [dbo].[PagamentosProtheus_TEMP]([NumeroTitulo] ASC, [AnoMesBase] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

