CREATE TABLE [Transacao].[Habitacional] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IDTipoTransacao]    INT             NOT NULL,
    [IDUnidade]          INT             NOT NULL,
    [IDCCA]              INT             DEFAULT ((1)) NOT NULL,
    [NumeroContrato]     VARCHAR (20)    NOT NULL,
    [CPF]                VARCHAR (20)    NOT NULL,
    [ValorFinanciamento] DECIMAL (18, 2) NOT NULL,
    [DataContrato]       DATETIME        NOT NULL,
    [DataImportacao]     DATETIME        DEFAULT (getdate()) NOT NULL,
    [Ativo]              BIT             DEFAULT ((1)) NOT NULL,
    [IcCCa]              INT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Habitacional] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CCAHabitacional] FOREIGN KEY ([IDCCA]) REFERENCES [Transacao].[DmCCA] ([ID]),
    CONSTRAINT [FK_TipoTransacaoHabitacional] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_UNIDADE_HABITACIONAL] FOREIGN KEY ([IDUnidade]) REFERENCES [Transacao].[DimUnidade] ([ID])
);

