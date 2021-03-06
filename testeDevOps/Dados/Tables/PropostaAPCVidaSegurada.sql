﻿CREATE TABLE [Dados].[PropostaAPCVidaSegurada] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]                  BIGINT          NULL,
    [CPFCNPJ]                     VARCHAR (18)    NULL,
    [Nome]                        VARCHAR (140)   NULL,
    [DataNascimento]              DATE            NULL,
    [Idade]                       VARCHAR (5)     NULL,
    [IDSexo]                      TINYINT         NULL,
    [IDEstadoCivil]               TINYINT         NULL,
    [Identidade]                  VARCHAR (15)    NULL,
    [OrgaoExpedidor]              VARCHAR (5)     NULL,
    [UFOrgaoExpedidor]            VARCHAR (2)     NULL,
    [DataEmissaoRG]               DATE            NULL,
    [DDD]                         VARCHAR (3)     NULL,
    [Telefone]                    VARCHAR (9)     NULL,
    [CodigoProfissao]             VARCHAR (5)     NULL,
    [NivelCargo]                  VARCHAR (60)    NULL,
    [IndicadorRepresentante]      VARCHAR (20)    NULL,
    [IndicadorImpressaoDPS]       VARCHAR (20)    NULL,
    [Endereco]                    VARCHAR (100)   NULL,
    [Bairro]                      VARCHAR (80)    NULL,
    [Cidade]                      VARCHAR (80)    NULL,
    [UF]                          CHAR (2)        NULL,
    [CEP]                         VARCHAR (9)     NULL,
    [ValorSalario]                DECIMAL (19, 2) NULL,
    [QuantidadeSalario]           INT             NULL,
    [ValorImportanciaSegurada]    DECIMAL (19, 2) NULL,
    [ValorPremio]                 DECIMAL (19, 2) NULL,
    [NumeroCertificadoIndividual] VARCHAR (45)    NULL,
    [DataInicioVigencia]          DATE            NULL,
    [DataFimVigencia]             DATE            NULL,
    [TipoDado]                    VARCHAR (30)    NULL,
    [DataArquivo]                 DATE            NULL,
    CONSTRAINT [PK_PropostaVidaSegurada] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAVIDASEGURADA_ESTADOCIVIL] FOREIGN KEY ([IDEstadoCivil]) REFERENCES [Dados].[EstadoCivil] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDASEGURADA_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PROPOSTAVIDASEGURADA_SEXO] FOREIGN KEY ([IDSexo]) REFERENCES [Dados].[Sexo] ([ID])
);

