CREATE TABLE [Dados].[PropostaVidaEmpresarial_bkp] (
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
    [NivelCargo]                 TINYINT         NULL,
    [ValorSeguradoCargo]         DECIMAL (19, 2) NULL,
    [QuantidadeVidasCargo]       INT             NULL,
    [TipoDado]                   VARCHAR (50)    NULL,
    [DataArquivo]                DATE            NULL,
    CONSTRAINT [PK_PROPOSTAVIDAEMPRESARIAL_bkp] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAVIDAEMPR_PORTEEMPRESA_bkp] FOREIGN KEY ([IDPorteEmpresa]) REFERENCES [Dados].[PorteEmpresa] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPR_TIPOCAPITAL_bkp] FOREIGN KEY ([IDTipoCapital]) REFERENCES [Dados].[TipoCapital] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIAL_PROPOSTA_bkp] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PROPOSTA_VIDAEMPRESARIAL_bkp] UNIQUE CLUSTERED ([IDProposta] ASC, [NivelCargo] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

