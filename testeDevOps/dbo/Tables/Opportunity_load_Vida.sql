﻿CREATE TABLE [dbo].[Opportunity_load_Vida] (
    [Id]                                 NCHAR (18)      NULL,
    [AccountId]                          NCHAR (18)      NULL,
    [Description]                        NTEXT           NULL,
    [devRenovacaoAutomatica__c]          NVARCHAR (255)  NULL,
    [Name]                               NVARCHAR (120)  NULL,
    [NumeroApoliceAnterior__c]           NVARCHAR (30)   NULL,
    [Numero_Certificado__c]              NVARCHAR (14)   NULL,
    [StageName]                          NVARCHAR (40)   NULL,
    [CloseDate]                          DATETIME2 (7)   NULL,
    [ERROR]                              NVARCHAR (1000) NULL,
    [devProduto__c]                      NVARCHAR (100)  NULL,
    [devProdutoComercializado__c]        NVARCHAR (80)   NULL,
    [RecordTypeId]                       NCHAR (18)      NULL,
    [Tipo_de_seguro__c]                  NVARCHAR (255)  NULL,
    [N_da_proposta__c]                   NVARCHAR (14)   NULL,
    [Fim_da_vigencia__c]                 DATETIME2 (7)   NULL,
    [Inicio_da_vigencia__c]              DATETIME2 (7)   NULL,
    [Parcelas__c]                        NVARCHAR (255)  NULL,
    [Premio_liquido__c]                  DECIMAL (18, 2) NULL,
    [Premio__c]                          DECIMAL (18, 2) NULL,
    [NumeroApolice__c]                   NVARCHAR (255)  NULL,
    [Agencia__c]                         DECIMAL (18)    NULL,
    [Matricula_do_indicador__c]          NVARCHAR (9)    NULL,
    [Indicador_CAIXA__c.id_conta_dev__c] NVARCHAR (60)   NULL,
    [Tipo_de_Veiculo__c]                 NVARCHAR (30)   NULL,
    [Endereco__c]                        NVARCHAR (255)  NULL,
    [Bairro__c]                          NVARCHAR (100)  NULL,
    [Cidade__c]                          NVARCHAR (100)  NULL,
    [Estado__c]                          NVARCHAR (255)  NULL,
    [CEP__c]                             NVARCHAR (9)    NULL,
    [Produto__c]                         NVARCHAR (100)  NULL,
    [Sort]                               INT             IDENTITY (1, 1) NOT NULL,
    [Importancia_Segurada__c]            DECIMAL (18, 2) NULL,
    [Contratacao__c]                     NVARCHAR (255)  NULL,
    [Contratacao_meses__c]               INT             NULL,
    [Periodicidade_pagamento__c]         NVARCHAR (255)  NULL,
    [Capital_segurado__c]                DECIMAL (18, 2) NULL,
    [Periodicidade_do_pagamento__c]      NVARCHAR (255)  NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
