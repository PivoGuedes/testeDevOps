CREATE TABLE [Transacao].[ContaCorrentePF] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [IDUnidade]       SMALLINT     NOT NULL,
    [IDTipoTransacao] INT          NOT NULL,
    [NumeroContrato]  VARCHAR (50) NOT NULL,
    [NumeroCPF]       VARCHAR (15) NOT NULL,
    [DataContrato]    DATETIME     NOT NULL,
    [DataImportacao]  DATETIME     DEFAULT (getdate()) NOT NULL,
    [DataNascimento]  DATETIME     NULL,
    [Ativo]           BIT          DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ContaCorrentePF] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TipoTransacao_ContaCorrentePF] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_Unidade_ContaCorrentePF] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

