﻿CREATE TABLE [Qlikview].[StageDMFinanceiro_Actual_Produtos] (
    [IDSTGDMFIN_Actual_Prod]      INT             IDENTITY (1, 1) NOT NULL,
    [ANO_MES_COMPETENCIA]         INT             NULL,
    [CD_PLANO_CONTAS]             BIGINT          NULL,
    [CD_CENTRO_CUSTO]             BIGINT          NULL,
    [CD_EMPRESA_ORIGEM]           VARCHAR (2)     NULL,
    [CD_EMPRESA]                  VARCHAR (2)     NULL,
    [CD_AGRUPAMENTO_AREA_VG1]     VARCHAR (6)     NULL,
    [CD_AGRUPAMENTO_DESPESA_VG2]  VARCHAR (6)     NULL,
    [CD_AGRUPAMENTO_PACOTE_VG3]   VARCHAR (6)     NULL,
    [CD_AGRUPAMENTO_BALANCO_VG4]  VARCHAR (6)     NULL,
    [CD_PRODUTOS_N1]              VARCHAR (10)    NULL,
    [DS_PRODUTOS_N1]              VARCHAR (100)   NULL,
    [CD_PRODUTOS_N2]              VARCHAR (10)    NULL,
    [DS_PRODUTOS_N2]              VARCHAR (100)   NULL,
    [CD_PRODUTOS_N3]              VARCHAR (10)    NULL,
    [DS_PRODUTOS_N3]              VARCHAR (100)   NULL,
    [CD_PRODUTOS_COMERCIALIZADOS] VARCHAR (10)    NULL,
    [DS_PRODUTOS_COMERCIALIZADOS] VARCHAR (100)   NULL,
    [VL_REALIZADO_CREDITO]        DECIMAL (19, 2) NULL,
    [VL_REALIZADO_DEBITO]         DECIMAL (19, 2) NULL,
    PRIMARY KEY CLUSTERED ([IDSTGDMFIN_Actual_Prod] ASC) ON [PRIMARY]
);
