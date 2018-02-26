﻿CREATE TABLE [dbo].[Temp_Comissao_ApagarAte_30092015] (
    [ID]                     BIGINT          NOT NULL,
    [IDRamo]                 SMALLINT        NULL,
    [PercentualCorretagem]   DECIMAL (5, 2)  NULL,
    [ValorCorretagem]        DECIMAL (38, 6) NULL,
    [ValorBase]              DECIMAL (38, 6) NULL,
    [ValorComissaoPAR]       DECIMAL (38, 6) NULL,
    [ValorRepasse]           DECIMAL (38, 6) NULL,
    [DataCompetencia]        DATE            NULL,
    [DataRecibo]             DATE            NULL,
    [NumeroRecibo]           INT             NULL,
    [NumeroEndosso]          INT             NULL,
    [NumeroParcela]          SMALLINT        NULL,
    [DataCalculo]            DATE            NULL,
    [DataQuitacaoParcela]    DATE            NULL,
    [TipoCorretagem]         TINYINT         NULL,
    [IDContrato]             BIGINT          NULL,
    [IDCertificado]          INT             NULL,
    [IDOperacao]             TINYINT         NULL,
    [IDProdutor]             INT             NULL,
    [IDFilialFaturamento]    SMALLINT        NULL,
    [CodigoSubgrupoRamoVida] INT             NULL,
    [IDProduto]              INT             NULL,
    [IDUnidadeVenda]         SMALLINT        NULL,
    [IDProposta]             BIGINT          NULL,
    [IDCanalVendaPAR]        INT             NULL,
    [NumeroProposta]         VARCHAR (20)    NULL,
    [CodigoProduto]          VARCHAR (5)     NULL,
    [LancamentoManual]       BIT             NULL,
    [Repasse]                BIT             NULL,
    [Arquivo]                VARCHAR (80)    NULL,
    [DataArquivo]            DATE            NULL,
    [IDEmpresa]              SMALLINT        NOT NULL,
    [CodigoComercializado]   VARCHAR (5)     NOT NULL,
    [Descricao]              VARCHAR (100)   NULL,
    [NumeroContrato]         VARCHAR (24)    NULL
);

