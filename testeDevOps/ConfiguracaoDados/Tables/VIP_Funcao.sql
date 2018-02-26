CREATE TABLE [ConfiguracaoDados].[VIP_Funcao] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [IDEmpresa]  SMALLINT      NOT NULL,
    [Descricao]  VARCHAR (100) NOT NULL,
    [Codigo]     INT           NULL,
    [Ativo]      BIT           NULL,
    [DataInicio] DATE          NULL,
    [DataFim]    DATE          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_VIP_Funcao_Empresa] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID])
);

