CREATE TABLE [Dados].[AtendimentoVeiculo] (
    [IDAtendimento]       INT             NOT NULL,
    [NumeroVeiculo]       TINYINT         NOT NULL,
    [IDVeiculo]           INT             NULL,
    [Placa]               VARCHAR (10)    NULL,
    [Premio_Atual]        DECIMAL (19, 2) NULL,
    [Premio_Sem_Desconto] DECIMAL (19, 2) NULL,
    [QtdParcelas]         TINYINT         NULL,
    [FormaPagamento]      VARCHAR (30)    NULL,
    [BitVistoria]         CHAR (2)        NULL,
    [IDSeguradora_Atual]  SMALLINT        NULL,
    [IDStatus_Ligacao]    TINYINT         NULL,
    CONSTRAINT [PK_AtendimentoVeiculo] PRIMARY KEY CLUSTERED ([IDAtendimento] ASC, [NumeroVeiculo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_AtendimentoVeiculo_Atendimento] FOREIGN KEY ([IDAtendimento]) REFERENCES [Dados].[Atendimento] ([ID]),
    CONSTRAINT [FK_AtendimentoVeiculo_Seguradora] FOREIGN KEY ([IDSeguradora_Atual]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_AtendimentoVeiculo_Status_Ligacao] FOREIGN KEY ([IDStatus_Ligacao]) REFERENCES [Dados].[Status_Ligacao] ([ID]),
    CONSTRAINT [FK_AtendimentoVeiculo_Veiculo] FOREIGN KEY ([IDVeiculo]) REFERENCES [Dados].[Veiculo] ([ID])
);

