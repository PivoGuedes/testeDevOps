CREATE TABLE [Mailing].[BASE_HIST_RESIDENCIAL] (
    [MES_REF]              VARCHAR (6)     NOT NULL,
    [APOLICE]              VARCHAR (20)    NULL,
    [CPFCNPJ]              VARCHAR (18)    NULL,
    [AGENCIA_VENDA]        SMALLINT        NULL,
    [PRODUTO]              VARCHAR (100)   NULL,
    [TIPOSEGURO]           VARCHAR (35)    NULL,
    [VALOR_PREMIO_TOT]     DECIMAL (19, 2) NULL,
    [IND_RENOV_AUTOMATICA] BIT             NULL,
    [DATA_EMISSAO]         DATE            NULL,
    [DATA_FIM_VIGENCIA]    DATE            NULL
);

