﻿CREATE TABLE [dbo].[Temp_Opportunity_RA2] (
    [AccountId]                                NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Agencia__c]                               DECIMAL (18)    NULL,
    [Agencia_apolice__c]                       NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [AgenciaIndiqueAqui__c]                    NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Amount]                                   DECIMAL (18, 2) NULL,
    [Ano_de_fabricacao__c]                     NVARCHAR (4)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Ano_do_modelo__c]                         NVARCHAR (4)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Ano_Modelo_de_Veiculo__c]                 NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Bairro__c]                                NVARCHAR (100)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CampaignId]                               NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Capital_segurado__c]                      DECIMAL (18, 2) NULL,
    [CEP__c]                                   NVARCHAR (9)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Chassi__c]                                NVARCHAR (17)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Cidade__c]                                NVARCHAR (100)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ClasseAtual__c]                           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Cliente_tem_conta_CAIXA_ativa__c]         VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CloseDate]                                DATETIME2 (7)   NOT NULL,
    [Complemento__c]                           NVARCHAR (50)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ContractId]                               NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Contratacao__c]                           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Contratacao_meses__c]                     DECIMAL (18, 2) NULL,
    [Contrato_anterior__c]                     NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CPF_CNPJ__c]                              NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CPF_do_conjuje__c]                        NVARCHAR (14)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CreatedById]                              NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CreatedDate]                              DATETIME2 (7)   NOT NULL,
    [Data_do_primeiro_pagamento__c]            DATETIME2 (7)   NULL,
    [DB_Competitor__c]                         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Desconto__c]                              DECIMAL (18, 2) NULL,
    [Description]                              NTEXT           COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Agencia_Indicacao__c]              NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Conta__c]                          NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Indicador_Caixa__c]                NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Marca__c]                          NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Modelo__c]                         NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Id_Oportunidade__c]                   NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Dev_Origem_Integracao__c]                 NVARCHAR (18)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devAnoModelo__c]                          DECIMAL (18)    NULL,
    [devCodigoDeBarrasBoleto__c]               NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devFase__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devModelo__c]                             NVARCHAR (100)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devPlaca__c]                              NVARCHAR (10)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devProduto__c]                            NVARCHAR (80)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devProdutoComercializado__c]              NVARCHAR (80)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [devRenovacaoAutomatica__c]                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Endereco__c]                              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Estado__c]                                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Existe_outro_seguro_vigente_no_imovel__c] VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ExpectedRevenue]                          DECIMAL (18, 2) NULL,
    [Fim_da_vigencia__c]                       DATETIME2 (7)   NULL,
    [Financiado__c]                            VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Fiscal]                                   NVARCHAR (6)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FiscalQuarter]                            INT             NULL,
    [FiscalYear]                               INT             NULL,
    [ForecastCategory]                         NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ForecastCategoryName]                     NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Forma_de_pagamento__c]                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Franquia__c]                              DECIMAL (18, 2) NULL,
    [HasOpenActivity]                          VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HasOpportunityLineItem]                   VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HasOverdueTask]                           VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Id]                                       NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Id_Ext_Prop_Situacao_IDConta__c]          NVARCHAR (80)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Indicador_CAIXA__c]                       NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Indicador_CAIXA_matricula__c]             NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inicio_da_vigencia__c]                    DATETIME2 (7)   NULL,
    [IsClosed]                                 VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsDeleted]                                VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsPrivate]                                VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsWon]                                    VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [LastActivityDate]                         DATETIME2 (7)   NULL,
    [LastModifiedById]                         NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [LastModifiedDate]                         DATETIME2 (7)   NOT NULL,
    [LastReferencedDate]                       DATETIME2 (7)   NULL,
    [LastViewedDate]                           DATETIME2 (7)   NULL,
    [LeadSource]                               NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Marca__c]                                 NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Matricula_do_indicador__c]                NVARCHAR (9)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Mini_Oportunidade__c]                     NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ModalidadeRenovacao__c]                   NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Modelo__c]                                NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_da_perda__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [N_da_proposta__c]                         NVARCHAR (14)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Name]                                     NVARCHAR (120)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [NextStep]                                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Nome_do_conjuje__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Nome_do_tipo_de_registro__c]              NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [NumeroApolice__c]                         NVARCHAR (20)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [NumeroApoliceAnterior__c]                 NVARCHAR (30)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Observacoes__c]                           NTEXT           COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [OwnerId]                                  NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Parcelas__c]                              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Placa__c]                                 NVARCHAR (7)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Premio__c]                                DECIMAL (18, 2) NULL,
    [Premio_liquido__c]                        DECIMAL (18, 2) NULL,
    [Pricebook2Id]                             NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Probability]                              DECIMAL (18)    NULL,
    [RecordTypeId]                             NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Renovacao__c]                             NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RenovacaoAtual__c]                        NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Seguradora__c]                            NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [StageName]                                NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Subfase__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [SyncedQuoteId]                            NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [SystemModstamp]                           DATETIME2 (7)   NOT NULL,
    [Tipo_cliente_simulador__c]                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_de_seguro__c]                        NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_de_Veiculo__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [TipoAdesao__c]                            NVARCHAR (30)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [TotalOpportunityQuantity]                 DECIMAL (18, 2) NULL,
    [Transbordo__c]                            NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Type]                                     NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [UF_de_emplacamento__c]                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ValorParcela__c]                          DECIMAL (18, 2) NULL,
    [ValorSinistro__c]                         DECIMAL (18, 2) NULL,
    [Vistoria__c]                              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [zero_km__c]                               VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);

