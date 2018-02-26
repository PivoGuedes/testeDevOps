﻿CREATE TABLE [dbo].[Temp_PlanilhaApolicesRE] (
    [Seguradora]         NVARCHAR (255)  NULL,
    [Cliente]            NVARCHAR (255)  NULL,
    [DtProposta]         DATETIME        NULL,
    [Apolice]            FLOAT (53)      NULL,
    [Endosso]            INT             NULL,
    [Produto]            NVARCHAR (255)  NULL,
    [TipoNegocio]        NVARCHAR (255)  NULL,
    [QtdItens]           FLOAT (53)      NULL,
    [DtInicioVigencia]   DATETIME        NULL,
    [DtTerminoVigencia]  DATETIME        NULL,
    [QtdParcelas]        FLOAT (53)      NULL,
    [Premio]             FLOAT (53)      NULL,
    [Porcentagem]        FLOAT (53)      NULL,
    [Comissao]           FLOAT (53)      NULL,
    [Ramo]               NVARCHAR (255)  NULL,
    [DtEmissao]          DATETIME        NULL,
    [DtEntrada]          DATETIME        NULL,
    [DtCancelamento]     NVARCHAR (255)  NULL,
    [NumeroContrato]     VARCHAR (20)    NULL,
    [ValorPremioLiquido] DECIMAL (19, 2) NULL,
    [DataInicioVigencia] DATE            NULL,
    [DataFimVigencia]    DATE            NULL,
    [DataEmissao]        DATE            NULL
);

