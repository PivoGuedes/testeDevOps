CREATE TABLE [Dados].[AtendimentoVeiculoPARIndica] (
    [IDAtendimento]        INT             NOT NULL,
    [NumeroVeiculo]        TINYINT         NOT NULL,
    [IDVeiculo]            INT             NULL,
    [Placa]                VARCHAR (10)    NULL,
    [Premio_Atual]         DECIMAL (19, 2) NULL,
    [Premio_Sem_Desconto]  DECIMAL (19, 2) NULL,
    [QtdParcelas]          TINYINT         NULL,
    [FormaPagamento]       VARCHAR (30)    NULL,
    [BitVistoria]          CHAR (2)        NULL,
    [NomeSeguradora_Atual] SMALLINT        NULL,
    [Status_Ligacao]       VARCHAR (30)    NULL,
    CONSTRAINT [PK_AtendimentoVeiculoPARIndica] PRIMARY KEY CLUSTERED ([IDAtendimento] ASC, [NumeroVeiculo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_AtendimentoVeiculo_AtendimentoPARIndica] FOREIGN KEY ([IDAtendimento]) REFERENCES [Dados].[AtendimentoPARIndica] ([ID])
);

