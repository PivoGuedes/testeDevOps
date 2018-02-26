CREATE TABLE [Dados].[PropostaSaudeComissao] (
    [ID]                     INT       IDENTITY (1, 1) NOT NULL,
    [IDPropostaSaude]        BIGINT    NULL,
    [TipoComissao]           NCHAR (1) NULL,
    [PercentualComissao]     INT       NULL,
    [ParcelaInicialComissao] INT       NULL,
    [ParcelaFinalComissao]   INT       NULL,
    [BaseCalculoComissao]    INT       NULL,
    [IDProdutor]             INT       NOT NULL,
    CONSTRAINT [PK_PROPOSTASAUDECOMISSAO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

