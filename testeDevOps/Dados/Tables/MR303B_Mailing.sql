﻿CREATE TABLE [Dados].[MR303B_Mailing] (
    [ID]                       INT             NOT NULL,
    [DataArquivo]              DATETIME        NULL,
    [NomeArquivo]              NVARCHAR (100)  NULL,
    [Nome]                     VARCHAR (300)   NULL,
    [CPF]                      CHAR (20)       NULL,
    [RG]                       VARCHAR (15)    NULL,
    [OrgaoExpedidor]           VARCHAR (8)     NULL,
    [Complemento]              VARCHAR (150)   NULL,
    [Endereco]                 VARCHAR (150)   NULL,
    [Bairro]                   VARCHAR (150)   NULL,
    [Cidade]                   VARCHAR (150)   NULL,
    [Estado]                   CHAR (8)        NULL,
    [CEP]                      NCHAR (12)      NULL,
    [DDD]                      NVARCHAR (5)    NULL,
    [Telefone]                 NVARCHAR (20)   NULL,
    [DDDComercial]             NVARCHAR (5)    NULL,
    [TelefoneComercial]        NVARCHAR (20)   NULL,
    [DDDCelular]               NVARCHAR (5)    NULL,
    [TelefoneCelular]          NVARCHAR (20)   NULL,
    [Email]                    NVARCHAR (200)  NULL,
    [NumeroAgencia]            VARCHAR (50)    NULL,
    [NomeAgencia]              VARCHAR (50)    NULL,
    [EmpregadoCaixa]           VARCHAR (30)    NULL,
    [ApoliceAnterior]          VARCHAR (30)    NULL,
    [Bonus_Renovacao]          DECIMAL (12, 2) NULL,
    [Desconto_Fidelidade]      DECIMAL (12, 2) NULL,
    [Desconto_Publico]         DECIMAL (12, 2) NULL,
    [Desconto_Agrupamento]     DECIMAL (12, 2) NULL,
    [Total_Desconto]           DECIMAL (12, 2) NULL,
    [Total_Desconto_Concebido] DECIMAL (12, 2) NULL,
    [Premio_Total]             DECIMAL (12, 2) NULL,
    [Termino_Vigencia]         DATE            NULL,
    [QuantidadeParcelas]       INT             NULL,
    [Mala_Direta]              VARCHAR (100)   NULL,
    [Valor_Primeira_Parcela]   DECIMAL (12, 2) NULL,
    [Valor_Demais_Parcelas]    DECIMAL (12, 2) NULL,
    [IS_Total]                 DECIMAL (12, 2) NULL,
    [Cobertura_I]              VARCHAR (50)    NULL,
    [IS_I]                     DECIMAL (12, 2) NULL,
    [Premio_I]                 DECIMAL (12, 2) NULL,
    [Cobertura_II]             VARCHAR (50)    NULL,
    [IS_II]                    DECIMAL (12, 2) NULL,
    [Premio_II]                DECIMAL (12, 2) NULL,
    [Cobertura_III]            VARCHAR (50)    NULL,
    [IS_III]                   DECIMAL (12, 2) NULL,
    [Premio_III]               DECIMAL (12, 2) NULL,
    [Cobertura_IV]             VARCHAR (50)    NULL,
    [IS_IV]                    DECIMAL (12, 2) NULL,
    [Premio_IV]                DECIMAL (12, 2) NULL,
    [Cobertura_V]              VARCHAR (50)    NULL,
    [IS_V]                     DECIMAL (12, 2) NULL,
    [Premio_V]                 DECIMAL (12, 2) NULL,
    [Cobertura_VI]             VARCHAR (50)    NULL,
    [IS_VI]                    DECIMAL (12, 2) NULL,
    [Premio_VI]                DECIMAL (12, 2) NULL,
    [Cobertura_VII]            VARCHAR (50)    NULL,
    [IS_VII]                   DECIMAL (12, 2) NULL,
    [Premio_VII]               DECIMAL (12, 2) NULL,
    [Cobertura_VIII]           VARCHAR (50)    NULL,
    [IS_VIII]                  DECIMAL (12, 2) NULL,
    [Premio_VIII]              DECIMAL (12, 2) NULL,
    [Cobertura_IX]             VARCHAR (50)    NULL,
    [IS_IX]                    DECIMAL (12, 2) NULL,
    [Premio_IX]                DECIMAL (12, 2) NULL
);
