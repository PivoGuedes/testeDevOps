﻿CREATE TABLE [dbo].[Temp_BaseCCA_TO_Producao] (
    [Código CCA]                          VARCHAR (26)    NULL,
    [CNPJ]                                VARCHAR (20)    NULL,
    [IDSalesForce]                        VARCHAR (52)    NULL,
    [Pedra]                               VARCHAR (8000)  NULL,
    [Nome]                                VARCHAR (8000)  NULL,
    [SobreNome]                           VARCHAR (8000)  NULL,
    [Nome2]                               VARCHAR (8000)  NULL,
    [Nome3]                               VARCHAR (8000)  NULL,
    [Email]                               VARCHAR (257)   NULL,
    [Email2]                              VARCHAR (257)   NULL,
    [Email3]                              VARCHAR (257)   NULL,
    [Telefone]                            NVARCHAR (264)  NULL,
    [Telefone2]                           NVARCHAR (264)  NULL,
    [Telefone3]                           NVARCHAR (264)  NULL,
    [Empresa]                             VARCHAR (8000)  NULL,
    [Status do lead]                      VARCHAR (1)     NOT NULL,
    [RazaoSocial]                         VARCHAR (8000)  NULL,
    [Cidade]                              VARCHAR (8000)  NULL,
    [Rua]                                 VARCHAR (8000)  NULL,
    [CEP]                                 VARCHAR (11)    NULL,
    [Estado/Província]                    VARCHAR (8000)  NULL,
    [País]                                VARCHAR (8)     NOT NULL,
    [Código Agência]                      VARCHAR (8)     NULL,
    [Agência Caixa]                       VARCHAR (8000)  NULL,
    [Nome GG da Agência]                  VARCHAR (8000)  NULL,
    [Superintendência Regional Caixa]     VARCHAR (8000)  NULL,
    [SUAT]                                VARCHAR (8000)  NULL,
    [Qtd Crédito Consignado (média 2015)] DECIMAL (19, 2) NULL,
    [Vol Crédito Consignado (média 2015)] DECIMAL (19, 2) NULL,
    [Qtd Seguro Prestamista (média 2015)] DECIMAL (19, 2) NULL,
    [Vol Seguro Prestamista (média 2015)] DECIMAL (19, 2) NULL,
    [Qtd Vida da Gente(média 2015)]       DECIMAL (19, 2) NULL,
    [% Penetração Física(média 2015)]     DECIMAL (19, 2) NULL,
    [Qtd Crédito Consignado(média 2016)]  DECIMAL (19, 2) NULL,
    [Vol Crédito Consignado (média 2016)] DECIMAL (19, 2) NULL,
    [Qtd Seguro Prestamista(média 2016)]  DECIMAL (19, 2) NULL,
    [Vol Seguro Prestamista (média 2016)] DECIMAL (19, 2) NULL,
    [Qtd Vida da Gente(média 2016)]       DECIMAL (19, 2) NULL,
    [% Penetração Física(média 2016)]     DECIMAL (19, 2) NULL,
    [Proprietário do lead]                VARCHAR (20)    NOT NULL
);
