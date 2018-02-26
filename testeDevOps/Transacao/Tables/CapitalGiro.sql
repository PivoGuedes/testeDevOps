CREATE TABLE [Transacao].[CapitalGiro] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [IDTipoTransacao]  INT             NOT NULL,
    [IDUnidade]        SMALLINT        NOT NULL,
    [NumeroContrato]   VARCHAR (40)    NOT NULL,
    [CodigoModalidade] INT             NOT NULL,
    [CodigoSituacao]   INT             NOT NULL,
    [DataLiberacao]    DATETIME        NOT NULL,
    [ValorConcessao]   DECIMAL (18, 2) NOT NULL,
    [NumeroCnpj]       VARCHAR (40)    NOT NULL,
    [TaxaJuros]        DECIMAL (18, 4) NOT NULL,
    [Prazo]            INT             NOT NULL,
    [DataImportacao]   DATETIME        DEFAULT (getdate()) NOT NULL,
    [Ativo]            BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CAPITALGIRO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TipoTransacao_CapitalGiro] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_Unidade_CapitalGiro] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

