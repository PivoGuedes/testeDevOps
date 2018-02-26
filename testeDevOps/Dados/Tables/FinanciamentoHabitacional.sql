CREATE TABLE [Dados].[FinanciamentoHabitacional] (
    [ID]                               INT             DEFAULT (NEXT VALUE FOR [Dados].[SequenceFinanciamento]) NOT NULL,
    [DataContratacao]                  DATE            NULL,
    [Agencia]                          VARCHAR (50)    NULL,
    [NumeroContrato]                   VARCHAR (12)    NOT NULL,
    [CodigoProdutoGestaoProdutividade] VARCHAR (1)     NULL,
    [BitCCa]                           BIT             NULL,
    [BitOutlier]                       BIT             NULL,
    [CodigoCCA]                        VARCHAR (9)     NULL,
    [Valor]                            DECIMAL (18, 4) NULL,
    [CNPJCCA]                          VARCHAR (14)    NULL,
    [DataArquivo]                      DATE            NULL,
    [NomeArquivo]                      VARCHAR (50)    NULL,
    [NomeCCA]                          VARCHAR (100)   NULL,
    [FlagLarMais]                      BIT             CONSTRAINT [cnt_BitCCA] DEFAULT ((0)) NOT NULL,
    [CodigoAgencia]                    VARCHAR (4)     NULL,
    [CPF]                              VARCHAR (14)    NULL,
    [IDProposta]                       BIGINT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_contrato]
    ON [Dados].[FinanciamentoHabitacional]([NumeroContrato] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_DataContratacao]
    ON [Dados].[FinanciamentoHabitacional]([DataContratacao] ASC)
    INCLUDE([ID], [NumeroContrato], [CodigoProdutoGestaoProdutividade], [BitCCa], [BitOutlier], [CodigoCCA], [Valor], [CNPJCCA], [DataArquivo], [NomeCCA], [FlagLarMais], [CodigoAgencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

