CREATE TABLE [ControleDados].[LogGeracaoMailing] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Situacao]        BIT           NULL,
    [DataRefMailing]  DATE          NULL,
    [DataHoraSistema] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [IDAtividade]     INT           NOT NULL,
    [HoraExecucao]    TINYINT       DEFAULT (datepart(hour,getdate())) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_LogGeracaoMailing_AtividadeGeracaoMailing] FOREIGN KEY ([IDAtividade]) REFERENCES [ControleDados].[AtividadeGeracaoMailing] ([ID])
);

