CREATE TABLE [Dados].[PropostaVidaEmpresarialHistorico] (
    [ID]                       BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]               BIGINT        NULL,
    [IDTipoCapital]            TINYINT       NULL,
    [IDPeriodicidadePagamento] TINYINT       NULL,
    [TotalDeVidas]             INT           NULL,
    [IDPorteEmpresa]           TINYINT       NULL,
    [TipoDado]                 VARCHAR (100) NULL,
    [DataArquivo]              DATE          NULL,
    [LastValue]                BIT           NULL,
    CONSTRAINT [PK_PPropostaVidaEmpresarialHistorico] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIALHISTORICO_PORTEEMPRESA] FOREIGN KEY ([IDPorteEmpresa]) REFERENCES [Dados].[PorteEmpresa] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIALHISTORICO_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIALHISTORICO_TIPOCAPITAL] FOREIGN KEY ([IDTipoCapital]) REFERENCES [Dados].[TipoCapital] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PropostaVidaEmpresarialHistorico_LastValue]
    ON [Dados].[PropostaVidaEmpresarialHistorico]([IDProposta] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaVidaEmpresarialHistorico_IDProposta]
    ON [Dados].[PropostaVidaEmpresarialHistorico]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

