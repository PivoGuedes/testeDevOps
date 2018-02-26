CREATE TABLE [ConfiguracaoDados].[VIP_Sigla_Lotacao] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [IDEmpresa]  SMALLINT      NOT NULL,
    [Descricao]  VARCHAR (100) NOT NULL,
    [Ativo]      BIT           NULL,
    [DataInicio] DATE          NULL,
    [DataFim]    DATE          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_VIP_Sigla_Lotacao_Empresa] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID])
);

