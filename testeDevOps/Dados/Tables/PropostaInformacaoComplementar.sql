CREATE TABLE [Dados].[PropostaInformacaoComplementar] (
    [ID]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]             BIGINT        NOT NULL,
    [InformacaoComplementar] VARCHAR (200) NULL,
    [DataArquivo]            DATETIME      NOT NULL,
    [Arquivo]                VARCHAR (120) NOT NULL,
    CONSTRAINT [PK_PropostaInformacaoComplementar_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaInformacaoComplementar_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idxNCL_PropostaInformacaoComplementar_PropostaDataArquivo]
    ON [Dados].[PropostaInformacaoComplementar]([IDProposta] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

