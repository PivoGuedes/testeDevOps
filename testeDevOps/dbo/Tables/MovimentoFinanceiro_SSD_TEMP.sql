CREATE TABLE [dbo].[MovimentoFinanceiro_SSD_TEMP] (
    [TIPO_DADO]                  VARCHAR (30)     DEFAULT ('SSD.MOVFIN') NOT NULL,
    [ID_SEGURADORA]              SMALLINT         DEFAULT ((1)) NULL,
    [SUK_ENDOSSO_FINANCEIRO]     INT              NULL,
    [NUM_ENDOSSO]                INT              NULL,
    [DTH_EMISSAO_ENDOSSO]        DATE             NULL,
    [COD_TIPO_ENDOSSO]           CHAR (1)         NULL,
    [COD_TIPO_MOVIMENTO_EF]      SMALLINT         NULL,
    [COD_RAMO_EMISSOR_EF]        SMALLINT         NULL,
    [DTH_INI_VIGENCIA_EF]        DATE             NULL,
    [DTH_FIM_VIGENCIA_EF]        DATE             NULL,
    [VLR_PREMIO_TARIFARIO_EF]    DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_LIQUIDO_EF]      DECIMAL (15, 2)  NULL,
    [VLR_IOF_EF]                 DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_BRUTO_EF]        DECIMAL (15, 2)  NULL,
    [DTH_OPERACAO_EF]            DATE             NULL,
    [COD_OPERACAO_EF]            SMALLINT         NULL,
    [COD_SUBGRUPO_EF]            SMALLINT         NULL,
    [COD_FILIAL]                 SMALLINT         NULL,
    [COD_MODALIDADE_EF]          SMALLINT         NULL,
    [DTH_ATUALIZACAO_MV]         DATE             NOT NULL,
    [VLR_PREMIO_BRUTO_MV]        DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_LIQUIDO_MV]      DECIMAL (21, 8)  NULL,
    [VLR_IOF_MV]                 DECIMAL (15, 10) NULL,
    [NUM_BIL_CERTIF]             VARCHAR (20)     NULL,
    [NUM_PROPOSTA_SIVPF]         VARCHAR (20)     NULL,
    [NUM_APOLICE]                VARCHAR (20)     NULL,
    [NUM_PROPOSTA_TRATADO]       AS               (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra](isnull([NUM_PROPOSTA_SIVPF],'SN'+[NUM_BIL_CERTIF])))) PERSISTED,
    [NUM_CERTIFICADO_TRATADO]    AS               (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NUM_BIL_CERTIF]))) PERSISTED,
    [COD_SUBGRUPO]               SMALLINT         NULL,
    [IND_ORIGEM_REGISTRO]        CHAR (1)         NULL,
    [NUM_PARCELA]                INT              NULL,
    [VLR_PREMIO_PARCELA]         DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_LIQUIDO_PARCELA] DECIMAL (21, 8)  NULL,
    [VLR_IOF_PARCELA]            DECIMAL (15, 10) NULL,
    [VLR_PREMIO_VG]              DECIMAL (15, 2)  NULL,
    [VLR_PREMIO_AP]              DECIMAL (15, 2)  NULL,
    [VLR_TARIFA]                 DECIMAL (15, 2)  NULL,
    [VLR_BALCAO]                 DECIMAL (15, 2)  NULL,
    [DTH_BAIXA_PARCELA]          DATE             NULL,
    [NUM_TITULO]                 DECIMAL (13)     NULL,
    [COD_TIPO_MOVIMENTO]         SMALLINT         NULL,
    [COD_ORIGEM_PAGAMENTO]       CHAR (1)         NULL,
    [COD_PRODUTO_SIAS]           VARCHAR (5)      NULL
);


GO
CREATE CLUSTERED INDEX [idx_SituacaoPagamento_STAFPREV_TEMP]
    ON [dbo].[MovimentoFinanceiro_SSD_TEMP]([SUK_ENDOSSO_FINANCEIRO] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_MovimentoFinanceiro_SSD_CodigoSIAS_TEMP]
    ON [dbo].[MovimentoFinanceiro_SSD_TEMP]([COD_PRODUTO_SIAS] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_MovimentoFinanceiro_SSD_NUM_APOLICE_TEMP]
    ON [dbo].[MovimentoFinanceiro_SSD_TEMP]([NUM_APOLICE] ASC)
    INCLUDE([TIPO_DADO], [ID_SEGURADORA], [DTH_ATUALIZACAO_MV]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_MovimentoFinanceiro_SSD_NUM_PROPOSTA_TRATADO_TEMP]
    ON [dbo].[MovimentoFinanceiro_SSD_TEMP]([NUM_PROPOSTA_TRATADO] ASC)
    INCLUDE([TIPO_DADO], [ID_SEGURADORA], [DTH_ATUALIZACAO_MV]) WITH (FILLFACTOR = 90);

