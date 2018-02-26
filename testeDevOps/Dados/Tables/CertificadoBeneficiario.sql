CREATE TABLE [Dados].[CertificadoBeneficiario] (
    [ID]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [IDCertificado]       INT            NOT NULL,
    [Nome]                VARCHAR (40)   NULL,
    [Numero]              TINYINT        NULL,
    [Parentesco]          VARCHAR (20)   NULL,
    [PercentualBeneficio] DECIMAL (5, 2) NULL,
    [DataInclusao]        DATE           NULL,
    [DataExclusao]        DATE           NULL,
    [Arquivo]             VARCHAR (100)  NULL,
    [DataArquivo]         DATE           NULL,
    CONSTRAINT [PK_BeneficiarioCertificado] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BeneficiarioCertificado_Certificado] FOREIGN KEY ([IDCertificado]) REFERENCES [Dados].[Certificado] ([ID]),
    CONSTRAINT [UNQ_CertificadoBeneficiario] UNIQUE NONCLUSTERED ([IDCertificado] ASC, [Numero] ASC, [Nome] ASC, [DataExclusao] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

