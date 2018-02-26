CREATE TABLE [Dados].[EscolaAmpliarCentroCusto] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [IDCentroCusto] SMALLINT NULL,
    [DataInclusão]  DATE     CONSTRAINT [DF_EscolaAmpliarCadastro_DataInclusão] DEFAULT (getdate()) NULL,
    [DataExclusão]  DATE     NULL,
    CONSTRAINT [PK_EscolaAmpliarCadastro] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_EscolaAmpliarCadastro_CentroCusto] FOREIGN KEY ([IDCentroCusto]) REFERENCES [Dados].[CentroCusto] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_EscolaAmplicarCentroCusto_Filtered]
    ON [Dados].[EscolaAmpliarCentroCusto]([IDCentroCusto] ASC) WHERE ([DataExclusao] IS NULL) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_EscolaAmplicarCentroCusto]
    ON [Dados].[EscolaAmpliarCentroCusto]([IDCentroCusto] ASC, [DataInclusão] ASC, [DataExclusão] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

