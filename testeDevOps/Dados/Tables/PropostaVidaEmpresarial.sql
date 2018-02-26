CREATE TABLE [Dados].[PropostaVidaEmpresarial] (
    [ID]                         BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]                 BIGINT          NULL,
    [IDTipoCapital]              TINYINT         NULL,
    [CapitalSeguradoBasicoTotal] DECIMAL (19, 2) NULL,
    [IDPeriodicidadePagamento]   TINYINT         NULL,
    [ValorFatura]                DECIMAL (19, 2) NULL,
    [TotalDeVidas]               INT             NULL,
    [CodigoCNAE]                 VARCHAR (10)    NULL,
    [IDPorteEmpresa]             TINYINT         NULL,
    [QuantidadeOcorrencias]      TINYINT         NULL,
    [TipoDado]                   VARCHAR (50)    NULL,
    [DataArquivo]                DATE            NULL,
    [LastValue]                  BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PROPOSTAVIDAEMPRESARIAL] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAVIDAEMPR_PORTEEMPRESA] FOREIGN KEY ([IDPorteEmpresa]) REFERENCES [Dados].[PorteEmpresa] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPR_TIPOCAPITAL] FOREIGN KEY ([IDTipoCapital]) REFERENCES [Dados].[TipoCapital] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIAL_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PROPOSTA_VIDAEMPRESARIAL] UNIQUE CLUSTERED ([IDProposta] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IND_NCL_PropostaVidaEmpresarial_IDProposta]
    ON [Dados].[PropostaVidaEmpresarial]([IDProposta] ASC)
    INCLUDE([IDTipoCapital], [CapitalSeguradoBasicoTotal], [IDPeriodicidadePagamento], [ValorFatura], [TotalDeVidas], [IDPorteEmpresa]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IND_NCL_PropostaVidaEmpresarial_LastValue]
    ON [Dados].[PropostaVidaEmpresarial]([IDProposta] ASC, [DataArquivo] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

