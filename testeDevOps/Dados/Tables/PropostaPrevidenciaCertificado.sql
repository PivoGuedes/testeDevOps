CREATE TABLE [Dados].[PropostaPrevidenciaCertificado] (
    [ID]                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]         BIGINT          NOT NULL,
    [NumeroCertificado]  VARCHAR (20)    NOT NULL,
    [DataInicioVigencia] DATE            NULL,
    [DataFimVigencia]    DATE            NULL,
    [ValorReservaCotas]  DECIMAL (19, 2) NULL,
    [ValorRendaEstimada] DECIMAL (19, 2) NULL,
    [ValorContribuicao]  DECIMAL (19, 2) NULL,
    [IndicadorQuota]     VARCHAR (10)    NULL,
    [DataInicioSituacao] DATE            NULL,
    [IDSituacaoProposta] TINYINT         NULL,
    [IDMotivo]           SMALLINT        NULL,
    [TipoDado]           VARCHAR (30)    NULL,
    [DataArquivo]        DATE            NOT NULL,
    CONSTRAINT [PK_PROPOSTAPREVIDENCIACERTIFIC] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTA_PREV_SITUACAO] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PROPOSTA_PREV_TIPOMOTIVO] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PROPOSTA_PROPOSTAPREVCERTIF] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PROPOSTAPREVIDE_PROPOSTA] UNIQUE CLUSTERED ([IDProposta] ASC, [NumeroCertificado] ASC, [DataInicioSituacao] ASC, [DataArquivo] DESC, [IDSituacaoProposta] ASC, [ValorReservaCotas] ASC, [ValorContribuicao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

