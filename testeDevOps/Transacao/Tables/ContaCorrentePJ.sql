CREATE TABLE [Transacao].[ContaCorrentePJ] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [IDUnidade]       SMALLINT     NOT NULL,
    [IDTipoTransacao] INT          NOT NULL,
    [NumeroContrato]  VARCHAR (50) NOT NULL,
    [NumeroCNPJ]      VARCHAR (15) NOT NULL,
    [DataContrato]    DATETIME     NOT NULL,
    [DataImportacao]  DATETIME     DEFAULT (getdate()) NOT NULL,
    [Ativo]           BIT          DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ContaCorrentePJ] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TipoTransacao_ContaCorrentePJ] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_Unidade_ContaCorrentePJ] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

