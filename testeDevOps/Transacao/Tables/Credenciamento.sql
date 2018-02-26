CREATE TABLE [Transacao].[Credenciamento] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [IDUnidade]      SMALLINT     NOT NULL,
    [AnoMes]         VARCHAR (7)  NOT NULL,
    [CpfCnpj]        VARCHAR (20) NOT NULL,
    [DataInstalacao] DATETIME     NOT NULL,
    [Credenciadora]  VARCHAR (10) NOT NULL,
    [DataImportacao] DATETIME     DEFAULT (getdate()) NOT NULL,
    [Ativo]          BIT          DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CREDENCIAMENTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Unidade_Credenciamento] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

