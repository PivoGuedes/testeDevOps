CREATE TABLE [Dados].[PropostaCertificado] (
    [ID]                  BIGINT       IDENTITY (1, 1) NOT NULL,
    [NumeroCertificado]   VARCHAR (20) NOT NULL,
    [IDSeguradora]        SMALLINT     NOT NULL,
    [IDPropostaPagamento] BIGINT       NULL,
    [IDPropostaComissao]  BIGINT       NULL,
    CONSTRAINT [PK_PropostaCertificado] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [CK_PropostaCertificado_NumeroCertificado] CHECK ([Dados].[fn_CertificadoExists]([NumeroCertificado],[IDSeguradora])=(1)),
    CONSTRAINT [FK_CERTIF_PROP_SEGURADORA] FOREIGN KEY ([IDSeguradora]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_CERTIF_PROPCOMISSAO] FOREIGN KEY ([IDPropostaComissao]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_CERTIF_PROPPAGAMENTO] FOREIGN KEY ([IDPropostaPagamento]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PropostaCertificado] UNIQUE NONCLUSTERED ([NumeroCertificado] ASC, [IDSeguradora] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaCertificado_IDProposta]
    ON [Dados].[PropostaCertificado]([IDPropostaComissao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaCertificado_IDPropostaPagamento]
    ON [Dados].[PropostaCertificado]([IDPropostaPagamento] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

