﻿CREATE TABLE [dbo].[CCABASE] (
    [NUMPROPOSTA]         FLOAT (53)     NULL,
    [CodigoCCA]           FLOAT (53)     NULL,
    [PROP-ENDERECO]       NVARCHAR (255) NULL,
    [PROP-NOME]           NVARCHAR (255) NULL,
    [CNPJ__c]             NVARCHAR (20)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [PROP-BAIRRO]         NVARCHAR (255) NULL,
    [PROP-CIDADE]         NVARCHAR (255) NULL,
    [PROP-UF]             NVARCHAR (255) NULL,
    [PROP-CEP]            NVARCHAR (255) NULL,
    [PROP-CNPJ]           NVARCHAR (255) NULL,
    [TELEFONE]            VARCHAR (8000) NULL,
    [FAX]                 VARCHAR (8000) NULL,
    [EMAIL]               NVARCHAR (255) NULL,
    [CLASSE]              NVARCHAR (255) NULL,
    [SOCIO-NOME]          NVARCHAR (255) NULL,
    [SOCIO-CPF]           NVARCHAR (255) NULL,
    [SOCIO-ENDERECO]      NVARCHAR (255) NULL,
    [SOCIO-BAIRRO]        NVARCHAR (255) NULL,
    [SOCIO-CIDADE]        NVARCHAR (255) NULL,
    [SOCIO-UF]            NVARCHAR (255) NULL,
    [SOCIO-CEP]           NVARCHAR (255) NULL,
    [SOCIO-DDD]           NVARCHAR (255) NULL,
    [SOCIO-TELEFONE]      NVARCHAR (255) NULL,
    [SOCIO-DDDFAX]        NVARCHAR (255) NULL,
    [SOCIO-FAX]           NVARCHAR (255) NULL,
    [TELEFONESOCIO]       VARCHAR (8000) NULL,
    [FAXSOCIO]            VARCHAR (8000) NULL,
    [SOCIO-EMAIL]         NVARCHAR (255) NULL,
    [DTINIVIGENCIA]       DATETIME       NULL,
    [DTFIMVIGENCIA]       DATETIME       NULL,
    [PREMIOTAR]           FLOAT (53)     NULL,
    [PREMIOLIQUIDO]       FLOAT (53)     NULL,
    [PREMIOTOTAL]         FLOAT (53)     NULL,
    [NUMEROPARCELAS]      FLOAT (53)     NULL,
    [VLPRIMEIRAPARCELA]   FLOAT (53)     NULL,
    [DEMAISPARCELAS]      FLOAT (53)     NULL,
    [DATAPRIMEIRAPARCELA] DATETIME       NULL,
    [FORMAPAGAMENTO]      NVARCHAR (255) NULL,
    [APOLICE]             FLOAT (53)     NULL,
    [Tipo]                NVARCHAR (255) NULL,
    [SITUAÇÃO]            NVARCHAR (255) NULL,
    [AGENCIA]             FLOAT (53)     NULL
);

