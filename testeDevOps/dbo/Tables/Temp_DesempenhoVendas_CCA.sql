CREATE TABLE [dbo].[Temp_DesempenhoVendas_CCA] (
    [CodigoCorrepondente]              VARCHAR (8)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Name]                             VARCHAR (61)    NULL,
    [Mes_Desem_Venda__c]               INT             NULL,
    [Ano_Desem_Venda__c]               INT             NULL,
    [Quantidade_Credito_Consignado__c] INT             NULL,
    [Volume_Credito_Consignado__c]     DECIMAL (38, 2) NULL,
    [Qtd_Seguro_Prestamista__c]        INT             NULL,
    [Volume_Seguro_Prestamista__c]     DECIMAL (38, 2) NULL,
    [Qtd_Vida_da_Gente__c]             INT             NULL,
    [Penetracao_Fisica__c]             DECIMAL (19, 2) NULL
);

