﻿CREATE TABLE [Fenae].[DC0701_CBN_Empresario] (
    [Codigo_BU]            VARCHAR (20)  NULL,
    [CodigoProduto]        VARCHAR (20)  NULL,
    [CodigoFilial]         VARCHAR (20)  NULL,
    [CodigoProdutor]       VARCHAR (20)  NULL,
    [NumeroRecibo]         VARCHAR (50)  NULL,
    [DataProcessamento]    VARCHAR (20)  NULL,
    [CodigoTipoDespesa]    VARCHAR (20)  NULL,
    [NumeroMatricula]      VARCHAR (20)  NULL,
    [NumeroApolice]        VARCHAR (20)  NULL,
    [NumeroCertificado]    VARCHAR (20)  NULL,
    [NumeroTitulo]         VARCHAR (20)  NULL,
    [NumeroParcela]        VARCHAR (20)  NULL,
    [NumeroBilhete]        VARCHAR (20)  NULL,
    [NumeroProposta]       VARCHAR (20)  NULL,
    [CodigoOperacao]       VARCHAR (20)  NULL,
    [ValorCorretagem]      VARCHAR (20)  NULL,
    [CodigoFilialProposta] VARCHAR (20)  NULL,
    [Filler]               VARCHAR (200) NULL,
    [NomeArquivo]          VARCHAR (300) NULL,
    [DataHoraSistema]      DATETIME2 (7) NULL,
    [Codigo]               INT           NOT NULL,
    [DataArquivo]          VARCHAR (11)  NULL,
    [AreaCEP]              VARCHAR (20)  NULL,
    [Erro]                 VARCHAR (50)  NULL,
    [NumeroApoliceINT]     BIGINT        NULL
);

