CREATE TABLE [Dados].[PropostaOperacaoContratual] (
    [ID]                   INT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]           BIGINT       NOT NULL,
    [IDOperacaoContratual] SMALLINT     NOT NULL,
    [DataOperacao]         DATE         NOT NULL,
    [LastValue]            BIT          CONSTRAINT [DF_PropostaOperacaoContratual_LastValue] DEFAULT ((0)) NOT NULL,
    [DataArquivo]          DATE         NOT NULL,
    [TipoDado]             VARCHAR (80) NOT NULL,
    CONSTRAINT [PK__Proposta__3214EC26709C83B4] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaOperacaoContratual_OperacaoContratual] FOREIGN KEY ([IDOperacaoContratual]) REFERENCES [Dados].[OperacaoContratual] ([ID]),
    CONSTRAINT [FK_PropostaOperacaoContratual_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [idx_UNQ_NCLPropostaOperacaoContratual]
    ON [Dados].[PropostaOperacaoContratual]([IDProposta] ASC, [DataOperacao] DESC, [IDOperacaoContratual] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_UNQ_NCLPropostaOperacaoContratual_LastValue]
    ON [Dados].[PropostaOperacaoContratual]([IDProposta] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

