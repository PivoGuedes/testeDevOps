CREATE TABLE [Dados].[PropostaPrevidenciaInfoComplementar] (
    [ID]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]       BIGINT          NULL,
    [InfoComplementar] VARCHAR (246)   NULL,
    [ValorAdesao]      DECIMAL (19, 2) NULL,
    [ValorAporte]      DECIMAL (19, 2) NULL,
    [ValorRisco]       DECIMAL (19, 2) NULL,
    [DataArquivo]      DATE            NULL,
    [TipoDado]         VARCHAR (30)    NULL,
    CONSTRAINT [PK_PROPOSTAPREVIDENCIAINFOCOMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAPREVINFOCOMP_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PROPOSTAPREVINFOCOMPL] UNIQUE NONCLUSTERED ([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

