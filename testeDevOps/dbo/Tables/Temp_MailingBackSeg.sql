CREATE TABLE [dbo].[Temp_MailingBackSeg] (
    [AGENCIA]             VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [NOME_AGENCIA]        VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [FILIAL]              VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [NOME_FILIAL]         VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [ESCRIT]              VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [NOME_ESCRIT]         VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [TER_VIG]             VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [APOLICE]             VARCHAR (20)   NULL,
    [CPFCNPJ]             VARCHAR (20)   NULL,
    [SEGURADO]            VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [ENDERECO]            VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [BAIRRO]              VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [CIDADE]              VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [UF]                  VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [CEP]                 VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [DDD]                 VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [FONE]                VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [EMAIL]               VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [VEICULO]             VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [ANO_MOD]             VARCHAR (200)  COLLATE Latin1_General_CI_AS NULL,
    [PLACA]               VARCHAR (200)  COLLATE Latin1_General_CI_AS NULL,
    [CHASSI]              VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [FORMA_COBR]          VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [CONTA_DEBITO]        VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [PRODUTO]             VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [CL_BONUS_A_CONCEDER] VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [APP]                 VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [RCDM]                VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [RCDP]                VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [VL_MERCADO]          VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [ECONOMIARIO]         VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [MATRICULA]           VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [DDD_UNIDADE]         VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [FONE_UNIDADE]        VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [TEM_SINISTRO]        VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [TP_FRANQUIA]         VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [TEM_ENDOSSO]         VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [TEM_PARC_PEND]       VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [DDD_CELULAR]         VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [CELULAR]             VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [DDD_COMERCIAL]       VARCHAR (8000) COLLATE Latin1_General_CI_AS NULL,
    [TEL_COMERCIAL]       VARCHAR (8000) COLLATE Latin1_General_CI_AS NULL,
    [DDD_RES_1]           VARCHAR (2)    COLLATE Latin1_General_CI_AS NULL,
    [TEL_RES_1]           VARCHAR (9)    COLLATE Latin1_General_CI_AS NULL,
    [DDD_RES_2]           VARCHAR (2)    COLLATE Latin1_General_CI_AS NULL,
    [TEL_RES_2]           VARCHAR (9)    COLLATE Latin1_General_CI_AS NULL,
    [DDD_COM_1]           VARCHAR (3)    COLLATE Latin1_General_CI_AS NULL,
    [TEL_COM_1]           VARCHAR (9)    COLLATE Latin1_General_CI_AS NULL,
    [DDD_COM_2]           VARCHAR (2)    COLLATE Latin1_General_CI_AS NULL,
    [TEL_COM_2]           VARCHAR (9)    COLLATE Latin1_General_CI_AS NULL,
    [EMAIL_1]             NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [ELEGIVEL_DESCONTO]   VARCHAR (4)    COLLATE Latin1_General_CI_AS NULL,
    [VALOR_PARA_DESCONTO] FLOAT (53)     NULL,
    [FLAG_VIP]            VARCHAR (4)    COLLATE Latin1_General_CI_AS NULL,
    [TIPO_CONTATO]        VARCHAR (15)   COLLATE Latin1_General_CI_AS NOT NULL,
    [FAIXA]               NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [OBJETIVO]            VARCHAR (20)   COLLATE Latin1_General_CI_AS NULL,
    [NOME_CAMPANHA]       VARCHAR (100)  COLLATE Latin1_General_CI_AS NULL,
    [COD_CAMPANHA]        VARCHAR (16)   COLLATE Latin1_General_CI_AS NULL,
    [COD_MAILING]         VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [DataMailing]         VARCHAR (MAX)  COLLATE Latin1_General_CI_AS NULL,
    [CPFCNPJ_Format]      VARCHAR (20)   NULL,
    [TER_VIG_DATE]        DATE           NULL
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_Temp_MailingBackSeg_APOLICE]
    ON [dbo].[Temp_MailingBackSeg]([APOLICE] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_Temp_MailingBackSeg_CPFCNPJ]
    ON [dbo].[Temp_MailingBackSeg]([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_Temp_MailingBackSeg_CPFCNPJ_FORMAT]
    ON [dbo].[Temp_MailingBackSeg]([CPFCNPJ_Format] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

