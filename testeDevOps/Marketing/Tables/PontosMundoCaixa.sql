CREATE TABLE [Marketing].[PontosMundoCaixa] (
    [Codigo]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdFuncionario]    INT             NOT NULL,
    [SaldoMesAnterior] DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [CreditosMesAtual] DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [ResgateMesAtual]  DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [PontosExpirar]    DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [SaldoAtual]       DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [DataArquivo]      DATE            NOT NULL,
    [DataHoraSistema]  DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_PontosMundoCaixa] PRIMARY KEY CLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_PontosMundoCaixa] FOREIGN KEY ([IdFuncionario]) REFERENCES [Dados].[Funcionario] ([ID])
);

