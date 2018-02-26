﻿CREATE TABLE [PowerBI].[HomologacaoRealizeDMSF] (
    [IDRealizeDMSF]            INT             IDENTITY (1, 1) NOT NULL,
    [ChaveUnicaREA]            VARCHAR (200)   NULL,
    [IDREA]                    VARCHAR (18)    NULL,
    [CodigoAgencia]            VARCHAR (10)    NULL,
    [Agencia]                  VARCHAR (255)   NULL,
    [TipoUnidade]              VARCHAR (20)    NULL,
    [Ano]                      INT             NULL,
    [Mes]                      INT             NULL,
    [DataReferencia]           DATE            NULL,
    [TotalRealizado_DM]        DECIMAL (18, 2) NULL,
    [TotalRealizado_SF]        DECIMAL (18, 2) NULL,
    [VerificaTotalRealizado]   INT             NULL,
    [TotalMeta_DM]             DECIMAL (18, 2) NULL,
    [TotalMeta_SF]             DECIMAL (18, 2) NULL,
    [VerificaTotalMeta]        INT             NULL,
    [QtdRegistro_DM]           INT             NULL,
    [QtdRegistro_SF]           INT             NULL,
    [VerificaQtdRegistro]      INT             NULL,
    [DataArquivo]              DATE            NULL,
    [ImagemValidacao]          VARCHAR (200)   NULL,
    [StatusValidacao]          VARCHAR (20)    NULL,
    [DataAtualizacaoValidador] DATETIME        NULL,
    [DataFimEnvio]             DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([IDRealizeDMSF] ASC) ON [PRIMARY]
);

