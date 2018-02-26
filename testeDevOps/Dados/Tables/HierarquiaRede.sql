CREATE TABLE [Dados].[HierarquiaRede] (
    [ID]                   BIGINT   IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]        INT      NOT NULL,
    [IDRegiaoRede]         INT      NOT NULL,
    [IDRegiaoRedeSuperior] INT      NOT NULL,
    [IDUnidade]            SMALLINT NOT NULL,
    [IDTipoVaga]           INT      NOT NULL,
    [DataInicio]           DATE     NULL,
    [DataHierarquia]       DATE     NOT NULL,
    [DataRegistro]         DATE     CONSTRAINT [DF_HierarquiaRede_DataRegistro] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_IDHierarquiaRede] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_HierarquiaRede_Funcionario] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_HierarquiaRede_RegiaoRede] FOREIGN KEY ([IDRegiaoRede]) REFERENCES [Dados].[RegiaoRede] ([ID]),
    CONSTRAINT [FK_HierarquiaRede_RegiaoRedeSuperior] FOREIGN KEY ([IDRegiaoRedeSuperior]) REFERENCES [Dados].[RegiaoRede] ([ID]),
    CONSTRAINT [FK_HierarquiaRede_TipoVaga] FOREIGN KEY ([IDTipoVaga]) REFERENCES [Dados].[TipoVaga] ([Id]),
    CONSTRAINT [FK_HierarquiaRede_Unidade] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

