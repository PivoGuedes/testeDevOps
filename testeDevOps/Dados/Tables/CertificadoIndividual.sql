CREATE TABLE [Dados].[CertificadoIndividual] (
    [ID]                          BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]                  BIGINT        NULL,
    [CPFCNPJ]                     VARCHAR (18)  NULL,
    [Nome]                        VARCHAR (140) NULL,
    [DataNascimento]              DATE          NULL,
    [IDSexo]                      TINYINT       NULL,
    [IDEstadoCivil]               TINYINT       NULL,
    [NumeroCertificadoIndividual] VARCHAR (20)  NULL,
    [DataInicioVigencia]          DATE          NULL,
    [DataFimVigencia]             DATE          NULL,
    [TipoDado]                    VARCHAR (100) NULL,
    [DataArquivo]                 DATE          NULL,
    CONSTRAINT [PK_CertificadoIndividual] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CERTIFICADOINDIVIDUAL_ESTADOCIVIL] FOREIGN KEY ([IDEstadoCivil]) REFERENCES [Dados].[EstadoCivil] ([ID]),
    CONSTRAINT [FK_CERTIFICADOINDIVIDUAL_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_CERTIFICADOINDIVIDUAL_SEXO] FOREIGN KEY ([IDSexo]) REFERENCES [Dados].[Sexo] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_CertificadoIndividual_LayoutAte20130807]
    ON [Dados].[CertificadoIndividual]([IDProposta] ASC, [CPFCNPJ] ASC, [Nome] ASC, [DataNascimento] ASC, [NumeroCertificadoIndividual] ASC) WHERE ([DataArquivo]<'2013-08-08') WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_CetificadoIndividualProposta]
    ON [Dados].[CertificadoIndividual]([IDProposta] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

