CREATE TABLE [dbo].[prd_pagamento_temp] (
    [ID]                    BIGINT           NOT NULL,
    [NumeroContrato]        VARCHAR (24)     NULL,
    [NumeroProposta]        VARCHAR (20)     NOT NULL,
    [CodigoProduto]         VARCHAR (5)      NOT NULL,
    [PremioLiquido]         DECIMAL (26, 10) NULL,
    [PremioLiquidoAtrasado] INT              NULL,
    [DataArquivo]           DATE             NULL
);

