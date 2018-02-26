CREATE TABLE [Dados].[ContratoFinanciamentoHabitacional] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [NumeroContrato]      VARCHAR (20)    NOT NULL,
    [BitCCA]              BIT             NULL,
    [IDTipoFinanciamento] SMALLINT        NOT NULL,
    [DataContratacao]     DATE            NOT NULL,
    [BitOutlier]          BIT             NULL,
    [IDUnidade]           SMALLINT        NOT NULL,
    [IDCorrespondente]    INT             NULL,
    [CPFCNPJ]             VARCHAR (14)    NOT NULL,
    [ValorFinanciamento]  DECIMAL (28, 8) NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    [NomeArquivo]         VARCHAR (60)    NOT NULL,
    [BitLarMais]          BIT             NOT NULL,
    [IDProposta]          BIGINT          NULL,
    CONSTRAINT [pk_ContratoFinaciamentoHabitacional] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_IDCorrespondente_Habitacional] FOREIGN KEY ([IDCorrespondente]) REFERENCES [Dados].[Correspondente] ([ID]),
    CONSTRAINT [fk_IDProposta_FinanciamentoHabitacional] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [fk_TipoFinanciamento] FOREIGN KEY ([IDTipoFinanciamento]) REFERENCES [Dados].[TipoFinanciamentoHabitacional] ([ID])
);

