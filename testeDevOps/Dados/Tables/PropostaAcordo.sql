CREATE TABLE [Dados].[PropostaAcordo] (
    [ID]                             INT            IDENTITY (1, 1) NOT NULL,
    [IDProposta]                     BIGINT         NOT NULL,
    [IDProdutor]                     INT            NOT NULL,
    [PercentualParticipacaoProdutor] DECIMAL (8, 2) NOT NULL,
    [PercentualComissaoProdutor]     DECIMAL (8, 2) NOT NULL,
    [DataArquivo]                    DATE           NOT NULL,
    [NomeArquivo]                    VARCHAR (60)   NOT NULL,
    [DataFimVigencia]                DATETIME       NOT NULL,
    [DataInicioVigencia]             DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_AcordoProdutor] FOREIGN KEY ([IDProdutor]) REFERENCES [Dados].[Produtor] ([ID]),
    CONSTRAINT [fk_AcordoProposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IND_NCL_UNQ_PropostaAcordo_IDProposta_IdProdutor_Vigencia]
    ON [Dados].[PropostaAcordo]([IDProposta] ASC, [IDProdutor] ASC, [DataInicioVigencia] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

