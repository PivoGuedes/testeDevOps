﻿CREATE TABLE [Financeiro].[CadastroEmpresario_SAF] (
    [Matricula]                   BIGINT          NULL,
    [Empresario]                  VARCHAR (140)   NULL,
    [CNPJ]                        VARCHAR (18)    NULL,
    [CodigoProduto]               BIGINT          NULL,
    [Apolice]                     BIGINT          NULL,
    [Parcela]                     INT             NULL,
    [Proposta]                    BIGINT          NULL,
    [Bilhete]                     BIGINT          NULL,
    [Producao]                    VARCHAR (10)    NULL,
    [Valor]                       DECIMAL (18, 2) NULL,
    [CodigoFilialProposta]        BIGINT          NULL,
    [NomeFilial]                  VARCHAR (50)    NULL,
    [IDTipoCorrespondente]        INT             NULL,
    [Descricao]                   VARCHAR (100)   NULL,
    [TotalRecebidoPelaSeguradora] DECIMAL (18, 2) NULL,
    [TotalPagoProdutor]           DECIMAL (18, 2) NULL,
    [Diferenca]                   DECIMAL (18, 2) NULL,
    [Mes]                         VARCHAR (4)     NULL,
    [Premiacao_Empresario]        VARCHAR (100)   NULL,
    [DataArquivo]                 DATE            NULL,
    [DataProcessamento]           VARCHAR (100)   NULL,
    [NomeArquivo]                 VARCHAR (100)   NULL,
    [Proposta_Paga]               VARCHAR (50)    NULL,
    [UF]                          VARCHAR (2)     NULL,
    [Ano]                         VARCHAR (4)     NULL
);

