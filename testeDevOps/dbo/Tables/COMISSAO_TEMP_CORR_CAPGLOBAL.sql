﻿CREATE TABLE [dbo].[COMISSAO_TEMP_CORR_CAPGLOBAL] (
    [CodigoFilialCA]           SMALLINT        NULL,
    [CodigoFilialPropostaCA]   SMALLINT        NULL,
    [CodigoSubgrupoRamoVidaCA] INT             NULL,
    [CodigoPontoVendaCA]       SMALLINT        NULL,
    [DataCalculoCA]            DATE            NULL,
    [NomeSeguradoCA]           VARCHAR (40)    NULL,
    [NumeroParcelaCA]          SMALLINT        NULL,
    [DataReciboCA]             DATE            NULL,
    [NumeroPropostaCA]         NUMERIC (16)    NULL,
    [NumeroReciboCA]           NUMERIC (9)     NULL,
    [PercentualCorretagemCA]   NUMERIC (5, 2)  NULL,
    [TipoCorretagemCA]         SMALLINT        NULL,
    [ValorBaseCA]              NUMERIC (15, 2) NULL,
    [ValorCorretagemCA]        NUMERIC (15, 2) NULL,
    [CodigoProdutoCA]          SMALLINT        NULL,
    [NumeroApolice]            NUMERIC (13)    NOT NULL,
    [NumeroEndosso]            NUMERIC (9)     NOT NULL,
    [NumeroCertificado]        NUMERIC (15)    NOT NULL,
    [NumeroParcela]            SMALLINT        NOT NULL,
    [CodigoSubgrupo]           INT             NULL,
    [CodigoProduto]            SMALLINT        NULL,
    [CodigoPontoVenda]         SMALLINT        NULL,
    [NomeSegurado]             VARCHAR (40)    NULL,
    [ValorPremioVG]            NUMERIC (20, 6) NULL,
    [ValorPremioAP]            NUMERIC (20, 6) NULL,
    [CodigoOperacao]           SMALLINT        NULL,
    [CodigoRamoFracionado]     SMALLINT        NULL,
    [PercentualCorretagem]     NUMERIC (5, 2)  NULL,
    [ValorCorretagem]          NUMERIC (20, 6) NULL,
    [DataPagamentoParcela]     DATE            NULL,
    [ValorBase]                NUMERIC (20, 6) NULL,
    [CodigoProdutor]           INT             NULL,
    [NumeroRecibo]             NUMERIC (9)     NULL,
    [DataArquivo]              DATE            NULL,
    [NomeArquivo]              NVARCHAR (100)  NULL,
    [DataHoraProcessamento]    DATETIME2 (7)   NOT NULL,
    [Codigo]                   BIGINT          NOT NULL
);

