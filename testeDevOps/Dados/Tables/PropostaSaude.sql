CREATE TABLE [Dados].[PropostaSaude] (
    [ID]                   BIGINT       IDENTITY (1, 1) NOT NULL,
    [CodigoSubestipulante] VARCHAR (9)  NULL,
    [Coparticipacao]       BIT          NULL,
    [IDTipoAdesao]         INT          NOT NULL,
    [IDPropostaOrigem]     BIGINT       NULL,
    [IDProposta]           BIGINT       NULL,
    [NomeCanal]            VARCHAR (16) NOT NULL,
    [IDCanalVendaPARSaude] INT          NOT NULL,
    CONSTRAINT [PK_PROPOSTASAUDE] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_TIPOADES] FOREIGN KEY ([IDTipoAdesao]) REFERENCES [Dados].[TipoAdesao] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141112-172328]
    ON [Dados].[PropostaSaude]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141112-172352]
    ON [Dados].[PropostaSaude]([IDPropostaOrigem] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

