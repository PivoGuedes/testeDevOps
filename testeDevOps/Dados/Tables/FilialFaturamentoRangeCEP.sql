CREATE TABLE [Dados].[FilialFaturamentoRangeCEP] (
    [ID]                  INT      IDENTITY (1, 1) NOT NULL,
    [IDFilialFaturamento] SMALLINT NOT NULL,
    [IDSeguradora]        SMALLINT NOT NULL,
    [RangeCEPInicio1]     BIGINT   NULL,
    [RangeCEPFim1]        BIGINT   NULL,
    [RangeCEPInicio2]     BIGINT   NULL,
    [RangeCEPFim2]        BIGINT   NULL,
    CONSTRAINT [pk_FilFat] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_FilFatCEPIDFilFat] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [fk_FilFatRangeCEPIDSeguradora] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID])
);

