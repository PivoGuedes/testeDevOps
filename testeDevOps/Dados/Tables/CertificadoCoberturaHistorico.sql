CREATE TABLE [Dados].[CertificadoCoberturaHistorico] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [IDCertificado]       INT             NOT NULL,
    [IDCobertura]         SMALLINT        NOT NULL,
    [DataInicioVigencia]  DATE            NULL,
    [DataFimVigencia]     DATE            NULL,
    [ImportanciaSegurada] DECIMAL (19, 2) NULL,
    [LimiteIndenizacao]   DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]  DECIMAL (19, 2) NULL,
    [Arquivo]             VARCHAR (100)   NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    CONSTRAINT [PK_CertificadoCobertura] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CertificadoCobertura_Certificado] FOREIGN KEY ([IDCertificado]) REFERENCES [Dados].[Certificado] ([ID]),
    CONSTRAINT [FK_CertificadoCobertura_Cobertura] FOREIGN KEY ([IDCobertura]) REFERENCES [Dados].[Cobertura] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [idxUNQCL_Certificado_Cobertura]
    ON [Dados].[CertificadoCoberturaHistorico]([IDCertificado] ASC, [IDCobertura] ASC, [DataInicioVigencia] DESC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idxUNQCL_Cobertura_Certificado]
    ON [Dados].[CertificadoCoberturaHistorico]([IDCobertura] ASC, [IDCertificado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idxTMP_CoberturaHistoricoID]
    ON [Dados].[CertificadoCoberturaHistorico]([IDCobertura] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

