CREATE TABLE [Dados].[PropostaSaudeFamilia] (
    [ID]                       BIGINT IDENTITY (1, 1) NOT NULL,
    [IDPropostaSaude]          BIGINT NOT NULL,
    [MatriculaFamiliaProtheus] INT    NOT NULL,
    [IDPlano]                  INT    NOT NULL,
    CONSTRAINT [PK_PROPOSTASAUDEFAMILIA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_PROPOSTA_REFERENCE_PLANO] FOREIGN KEY ([IDPlano]) REFERENCES [Dados].[Plano] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20140422-162516]
    ON [Dados].[PropostaSaudeFamilia]([IDPropostaSaude] ASC)
    INCLUDE([MatriculaFamiliaProtheus], [IDPlano]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

