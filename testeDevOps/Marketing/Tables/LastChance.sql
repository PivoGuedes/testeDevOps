CREATE TABLE [Marketing].[LastChance] (
    [Codigo]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [IdCliente]           BIGINT        NOT NULL,
    [IdProposta]          BIGINT        NOT NULL,
    [Telefone]            VARCHAR (30)  NULL,
    [TelefoneAlternativo] VARCHAR (30)  NULL,
    [Motivo]              VARCHAR (100) NULL,
    [Interacao]           VARCHAR (100) NULL,
    [RenovacaoAutomatica] VARCHAR (20)  NULL,
    [MotivosRecusas]      VARCHAR (300) NULL,
    [IsContaCorreta]      VARCHAR (200) NULL,
    [ContaCorreta]        VARCHAR (200) NULL,
    CONSTRAINT [PK_LastChance] PRIMARY KEY CLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [fk_proposta_lastchance] FOREIGN KEY ([IdProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [fk_propostacliente_lastchance] FOREIGN KEY ([IdCliente]) REFERENCES [Dados].[PropostaCliente] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_IDCLIENTE]
    ON [Marketing].[LastChance]([IdCliente] ASC) WITH (FILLFACTOR = 90);

