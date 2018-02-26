CREATE TABLE [Dados].[MKDRERES20160615_6_TMP] (
    [CPF]                  VARCHAR (11)    COLLATE Latin1_General_CI_AS NULL,
    [APOLICE]              VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [CPFCNPJ]              VARCHAR (8000)  COLLATE Latin1_General_CI_AS NULL,
    [NOME_CLIENTE]         VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [DATA_NASC]            DATE            NULL,
    [AGENCIA_VENDA]        SMALLINT        NULL,
    [DATA_FIM_VIGENCIA]    DATE            NULL,
    [PRODUTO]              VARCHAR (100)   COLLATE Latin1_General_CI_AS NULL,
    [COD_COMERCIALIZADO]   INT             NOT NULL,
    [TIPO_SEGURO]          VARCHAR (35)    COLLATE Latin1_General_CI_AS NULL,
    [VALOR_PREMIO_LIQ]     NUMERIC (19, 2) NULL,
    [FLAG_EXCLUSIVO]       VARCHAR (21)    COLLATE Latin1_General_CI_AS NOT NULL,
    [PROPOSTA]             VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [PREMIO]               VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [PARCELAS]             VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [VALOR_PARCELA]        VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL,
    [CODIGO_DE_BARRAS]     VARCHAR (100)   COLLATE Latin1_General_CI_AS NULL,
    [VALOR_BOLETO]         VARCHAR (100)   COLLATE Latin1_General_CI_AS NULL,
    [PARCELAS_BOLETO]      BIGINT          NULL,
    [VALOR_PARCELA_BOLETO] VARCHAR (100)   COLLATE Latin1_General_CI_AS NULL,
    [TIPO_RENOV]           VARCHAR (15)    COLLATE Latin1_General_CI_AS NOT NULL,
    [COD_CAMPANHA]         VARCHAR (20)    COLLATE Latin1_General_CI_AS NULL,
    [NOME_CAMPANHA]        VARCHAR (100)   COLLATE Latin1_General_CI_AS NULL,
    [COD_MAILING]          VARCHAR (MAX)   COLLATE Latin1_General_CI_AS NULL,
    [PRODUTO_1]            VARCHAR (30)    COLLATE Latin1_General_CI_AS NULL,
    [OBJETIVO]             VARCHAR (20)    COLLATE Latin1_General_CI_AS NULL,
    [PRODUTO_OFERTA]       VARCHAR (30)    COLLATE Latin1_General_CI_AS NULL,
    [DATA_VENCIMENTO]      VARCHAR (1)     COLLATE Latin1_General_CI_AS NOT NULL,
    [DATA_MAILING]         DATETIME        NOT NULL,
    [DATA_NASCIMENTO]      DATE            NULL,
    [TELL_1F]              VARCHAR (MAX)   COLLATE Latin1_General_CI_AI NULL,
    [EMAIL_1F]             NVARCHAR (MAX)  COLLATE Latin1_General_CI_AI NULL,
    [DDD_TELEFONE_1]       VARCHAR (MAX)   COLLATE Latin1_General_CI_AI NULL,
    [PRIMEIRO_NOME]        VARCHAR (255)   COLLATE Latin1_General_CI_AS NULL
);


GO
CREATE CLUSTERED INDEX [idx_Alice]
    ON [Dados].[MKDRERES20160615_6_TMP]([APOLICE] ASC, [CPF] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_Vigencia]
    ON [Dados].[MKDRERES20160615_6_TMP]([DATA_FIM_VIGENCIA] ASC) WITH (FILLFACTOR = 90);

