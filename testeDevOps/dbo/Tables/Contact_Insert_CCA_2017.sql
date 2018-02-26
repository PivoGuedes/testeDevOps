CREATE TABLE [dbo].[Contact_Insert_CCA_2017] (
    [Name]                 NVARCHAR (255) NULL,
    [MailingAddress]       NVARCHAR (513) NULL,
    [MailingCity]          NVARCHAR (255) NULL,
    [UF__c]                NVARCHAR (255) NULL,
    [MailingPostalCode]    NVARCHAR (255) NULL,
    [MailingPostalCode__c] NVARCHAR (255) NULL,
    [BillingPostalCode]    NVARCHAR (255) NULL,
    [MobilePhone]          VARCHAR (8000) NULL,
    [Phone]                VARCHAR (8000) NULL,
    [Email]                NVARCHAR (255) NULL,
    [RecordTypeId]         VARCHAR (18)   NOT NULL,
    [id_contato_Dev__c]    VARCHAR (36)   NULL,
    [AccountId]            NCHAR (18)     NULL
);

