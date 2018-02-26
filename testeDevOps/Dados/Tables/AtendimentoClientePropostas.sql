CREATE TABLE [Dados].[AtendimentoClientePropostas] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [IDAtendimento] INT      NOT NULL,
    [IDProposta]    INT      NOT NULL,
    [DataCadastro]  DATETIME DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AtendimentoClientePropostas_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_DadosAtendimento_AtendimentoClientePropostas_IDAtendimento] FOREIGN KEY ([IDAtendimento]) REFERENCES [Dados].[Atendimento] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_AtendimentoClienteProposta_IDAtendimento]
    ON [Dados].[AtendimentoClientePropostas]([IDAtendimento] ASC)
    INCLUDE([IDProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

