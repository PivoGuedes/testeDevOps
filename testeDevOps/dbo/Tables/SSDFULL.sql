﻿CREATE TABLE [dbo].[SSDFULL] (
    [SUK_ENDOSSO_FINANCEIRO]     INT              NOT NULL,
    [NUM_ENDOSSO]                INT              NOT NULL,
    [DTH_EMISSAO_ENDOSSO]        DATETIME         NOT NULL,
    [COD_TIPO_ENDOSSO]           CHAR (1)         COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [COD_TIPO_MOVIMENTO_EF]      SMALLINT         NOT NULL,
    [COD_RAMO_EMISSOR_EF]        SMALLINT         NOT NULL,
    [DTH_INI_VIGENCIA_EF]        DATETIME         NOT NULL,
    [DTH_FIM_VIGENCIA_EF]        DATETIME         NOT NULL,
    [VLR_PREMIO_TARIFARIO_EF]    DECIMAL (15, 2)  NOT NULL,
    [VLR_PREMIO_LIQUIDO_EF]      DECIMAL (15, 2)  NOT NULL,
    [VLR_IOF_EF]                 DECIMAL (15, 2)  NOT NULL,
    [VLR_PREMIO_BRUTO_EF]        DECIMAL (15, 2)  NOT NULL,
    [DTH_OPERACAO_EF]            DATETIME         NOT NULL,
    [COD_OPERACAO_EF]            SMALLINT         NOT NULL,
    [COD_SUBGRUPO_EF]            SMALLINT         NOT NULL,
    [COD_FILIAL]                 SMALLINT         NOT NULL,
    [COD_MODALIDADE_EF]          SMALLINT         NOT NULL,
    [DTH_ATUALIZACAO_MV]         DATETIME         NOT NULL,
    [VLR_PREMIO_BRUTO_MV]        DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_LIQUIDO_MV]      DECIMAL (21, 8)  NULL,
    [VLR_IOF_MV]                 DECIMAL (15, 10) NULL,
    [NUM_BIL_CERTIF]             DECIMAL (15)     NULL,
    [NUM_PROPOSTA_SIVPF]         NVARCHAR (4000)  NULL,
    [NUM_APOLICE]                DECIMAL (15)     NULL,
    [COD_SUBGRUPO]               SMALLINT         NULL,
    [IND_ORIGEM_REGISTRO]        CHAR (1)         COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [STA_ANTECIPACAO]            INT              NULL,
    [STA_MUDANCA_PLANO]          INT              NULL,
    [NUM_PARCELA]                INT              NULL,
    [VLR_PREMIO_PARCELA]         DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_LIQUIDO_PARCELA] DECIMAL (21, 8)  NULL,
    [VLR_IOF_PARCELA]            DECIMAL (15, 10) NULL,
    [VLR_PREMIO_VG]              DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_AP]              DECIMAL (15, 2)  NULL,
    [VLR_TARIFA]                 DECIMAL (15, 2)  NULL,
    [VLR_BALCAO]                 DECIMAL (15, 2)  NULL,
    [DTH_BAIXA_PARCELA]          DATETIME         NULL,
    [NUM_TITULO]                 DECIMAL (13)     NULL,
    [COD_TIPO_MOVIMENTO]         SMALLINT         NULL,
    [COD_ORIGEM_PAGAMENTO]       CHAR (1)         COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [COD_PRODUTO_SIAS]           SMALLINT         NULL
);

