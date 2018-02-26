CREATE TABLE [Dados].[PropostaAssistencia] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [NumeroAssistencia]  VARCHAR (20)  NULL,
    [Evento]             VARCHAR (100) NULL,
    [UF]                 NCHAR (2)     NULL,
    [Cidade]             VARCHAR (50)  NULL,
    [Segmento]           VARCHAR (20)  NULL,
    [Motivo]             VARCHAR (50)  NULL,
    [DataAbertura]       DATETIME      NULL,
    [IDProposta]         BIGINT        NOT NULL,
    [NomeTitular]        VARCHAR (100) NULL,
    [DataInicioVigencia] DATETIME2 (7) NULL,
    [DataFimVigencia]    DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [fk_IDProposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);

