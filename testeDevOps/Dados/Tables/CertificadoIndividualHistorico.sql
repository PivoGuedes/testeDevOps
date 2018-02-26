CREATE TABLE [Dados].[CertificadoIndividualHistorico] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDCertificadoIndividual]  BIGINT          NULL,
    [Identidade]               VARCHAR (15)    NULL,
    [OrgaoExpedidor]           VARCHAR (5)     NULL,
    [UFOrgaoExpedidor]         VARCHAR (2)     NULL,
    [DataEmissaoRG]            DATE            NULL,
    [DDD]                      VARCHAR (3)     NULL,
    [Telefone]                 VARCHAR (9)     NULL,
    [CodigoProfissao]          VARCHAR (5)     NULL,
    [NivelCargo]               VARCHAR (60)    NULL,
    [IndicadorRepresentante]   VARCHAR (20)    NULL,
    [IndicadorImpressaoDPS]    VARCHAR (20)    NULL,
    [Endereco]                 VARCHAR (100)   NULL,
    [Bairro]                   VARCHAR (80)    NULL,
    [Cidade]                   VARCHAR (80)    NULL,
    [UF]                       CHAR (2)        NULL,
    [CEP]                      VARCHAR (9)     NULL,
    [ValorSalario]             DECIMAL (19, 2) NULL,
    [QuantidadeSalario]        INT             NULL,
    [ValorImportanciaSegurada] DECIMAL (19, 2) NULL,
    [ValorPremio]              DECIMAL (19, 2) NULL,
    [TipoDado]                 VARCHAR (100)   NULL,
    [DataArquivo]              DATE            NULL,
    [FlagAtivo]                BIT             NULL,
    CONSTRAINT [PK_CertificadoIndividualHistorico] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [Dados],
    CONSTRAINT [FK_CertificadoIndividualHistorico_PROPOSTA] FOREIGN KEY ([IDCertificadoIndividual]) REFERENCES [Dados].[CertificadoIndividual] ([ID])
);


GO
CREATE CLUSTERED INDEX [INX_CL_CertificadoIndividualHistorico]
    ON [Dados].[CertificadoIndividualHistorico]([IDCertificadoIndividual] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_CertificadoIndividualHistorico_FlagAtivo]
    ON [Dados].[CertificadoIndividualHistorico]([IDCertificadoIndividual] ASC, [FlagAtivo] ASC)
    INCLUDE([ID], [DataArquivo]) WHERE ([FlagAtivo]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

