﻿CREATE TABLE [dbo].[Produto_20140731] (
    [ID]                        INT           IDENTITY (1, 1) NOT NULL,
    [CodigoComercializado]      VARCHAR (5)   NOT NULL,
    [IDRamoPrincipal]           SMALLINT      NULL,
    [IDRamoSUSEP]               SMALLINT      NULL,
    [IDRamoPAR]                 SMALLINT      NULL,
    [IDProdutoSIGPF]            TINYINT       NULL,
    [Descricao]                 VARCHAR (100) NULL,
    [DataInicioComercializacao] DATE          NULL,
    [DataFimComercializacao]    DATE          NULL,
    [IDSeguradora]              SMALLINT      NULL,
    [Exclusivo]                 BIT           NOT NULL,
    [LancamentoManual]          BIT           NOT NULL,
    [IDPeriodoPagamento]        TINYINT       NULL
);

