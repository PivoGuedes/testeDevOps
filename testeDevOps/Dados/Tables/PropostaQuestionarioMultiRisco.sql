CREATE TABLE [Dados].[PropostaQuestionarioMultiRisco] (
    [ID]                  BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]          BIGINT        NOT NULL,
    [IDCobertura]         SMALLINT      NOT NULL,
    [IDPerguntaRisco]     SMALLINT      NOT NULL,
    [IDRespostaRisco]     SMALLINT      NOT NULL,
    [ComplementoResposta] VARCHAR (150) NULL,
    [DataArquivo]         DATE          NULL,
    [Arquivo]             VARCHAR (100) NULL,
    CONSTRAINT [PK_PropostaCoberturaQuestionarioRisco] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaCoberturaQuestionarioRisco_Cobertura] FOREIGN KEY ([IDCobertura]) REFERENCES [Dados].[Cobertura] ([ID]),
    CONSTRAINT [FK_PropostaCoberturaQuestionarioRisco_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_QuestionarioPerguntaUnica] UNIQUE NONCLUSTERED ([IDProposta] ASC, [IDCobertura] ASC, [IDPerguntaRisco] ASC, [IDRespostaRisco] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

