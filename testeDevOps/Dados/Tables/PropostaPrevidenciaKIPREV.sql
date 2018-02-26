CREATE TABLE [Dados].[PropostaPrevidenciaKIPREV] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]              BIGINT          NULL,
    [IDFilialPrevidencia]     INT             NULL,
    [IDProdutoKIPREV]         INT             NOT NULL,
    [CodigoConta]             VARCHAR (20)    NULL,
    [IDAgencia]               INT             NULL,
    [SOBREVIDA_CONTRATADO_PM] DECIMAL (19, 2) NULL,
    [RISCO_CONTRATADO_PM]     DECIMAL (19, 2) NULL,
    [SOBREVIDA_CONTRATADO_PU] DECIMAL (19, 2) NULL,
    [RISCO_CONTRATADO_PU]     DECIMAL (19, 2) NULL,
    [PRAZO]                   VARCHAR (50)    NULL,
    [SEXO]                    VARCHAR (5)     NULL,
    [DATA_NASCIMENTO]         DATE            NULL,
    [RENDA_PARTICIPANTE]      DECIMAL (19, 2) NULL,
    [DataArquivo]             DATE            NULL,
    [NomeArquivo]             VARCHAR (200)   NULL,
    [DataCancelamentoPAR]     DATE            NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaPrevidenciaKIPREV_Filial] FOREIGN KEY ([IDFilialPrevidencia]) REFERENCES [Dados].[FilialPrevidencia] ([ID]),
    CONSTRAINT [FK_PropostaPrevidenciaKIPREV_Produto] FOREIGN KEY ([IDProdutoKIPREV]) REFERENCES [Dados].[ProdutoKIPREV] ([ID]),
    CONSTRAINT [FK_PropostaPrevidenciaKIPREV_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);

