CREATE TABLE [Dados].[PrevidenciaCobertura] (
    [ID]                             INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]                     BIGINT          NOT NULL,
    [IDAcessorio]                    TINYINT         NULL,
    [IndicadorPercContr]             CHAR (1)        NULL,
    [PrazoPercepcao]                 TINYINT         NULL,
    [PeriodicidadePagamentoProtecao] CHAR (1)        NULL,
    [ValorContribuicao]              DECIMAL (19, 2) NULL,
    [ValorBeneficio]                 DECIMAL (19, 2) NULL,
    [LastValue]                      BIT             NULL,
    [CodigoNaFonte]                  BIGINT          NULL,
    [TipoDado]                       VARCHAR (30)    NULL,
    [DataArquivo]                    DATE            NULL,
    CONSTRAINT [PK_PREVIDENCIACOBERTURA] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PREV_ACESSORIO_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PREVIDEN_ACESSORIO] FOREIGN KEY ([IDAcessorio]) REFERENCES [Dados].[Acessorio] ([ID]),
    CONSTRAINT [UNQ_PrevidenciaCobertura] UNIQUE CLUSTERED ([IDProposta] ASC, [IDAcessorio] ASC, [DataArquivo] DESC, [ValorContribuicao] DESC, [ValorBeneficio] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PrevidenciaCobertura_LastValue]
    ON [Dados].[PrevidenciaCobertura]([IDProposta] ASC, [IDAcessorio] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

