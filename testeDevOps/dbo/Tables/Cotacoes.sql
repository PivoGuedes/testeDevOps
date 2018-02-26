CREATE TABLE [dbo].[Cotacoes] (
    [CreatedById]                   NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CreatedDate]                   DATETIME2 (7)   NOT NULL,
    [Data_do_primeiro_pagamento__c] DATETIME2 (7)   NULL,
    [Desconto__c]                   DECIMAL (18, 2) NULL,
    [DevDataVencimentoBoleto__c]    DATETIME2 (7)   NULL,
    [DevDiasVencimentoBoleto__c]    DECIMAL (18)    NULL,
    [DevFormaPagamento__c]          NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DevNumeroProposta__c]          NVARCHAR (30)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DevPrecisaVistoria__c]         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DevSituacaoCalculo__c]         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Fase__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Fim_da_vigencia__c]            DATETIME2 (7)   NULL,
    [Forma_de_pagamento__c]         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Franquia__c]                   DECIMAL (18, 2) NULL,
    [Ganha__c]                      VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [HoraRelatorio__c]              NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Id]                            NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Inicio_da_vigencia__c]         DATETIME2 (7)   NULL,
    [IsDeleted]                     VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [LastActivityDate]              DATETIME2 (7)   NULL,
    [LastModifiedById]              NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [LastModifiedDate]              DATETIME2 (7)   NOT NULL,
    [LastReferencedDate]            DATETIME2 (7)   NULL,
    [LastViewedDate]                DATETIME2 (7)   NULL,
    [N_Cotacao__c]                  DECIMAL (18)    NULL,
    [N_da_proposta__c]              NVARCHAR (14)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Name]                          NVARCHAR (80)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Oportunidade__c]               NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Parcelas__c]                   NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Premio__c]                     DECIMAL (18, 2) NULL,
    [RecordTypeId]                  NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [SystemModstamp]                DATETIME2 (7)   NOT NULL,
    [Tipo_cliente_simulador__c]     NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Transbordo__c]                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Vistoria__c]                   NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);


GO
CREATE CLUSTERED INDEX [cl_id_cota]
    ON [dbo].[Cotacoes]([Oportunidade__c] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

