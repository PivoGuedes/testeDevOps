CREATE TABLE [dbo].[HB_GESTAO_PRODUTIVIDADE_tmp] (
    [ID]                              BIGINT        NOT NULL,
    [NU_CONTRATO]                     VARCHAR (50)  NULL,
    [CO_UNIDADE_OPERACIONAL]          VARCHAR (50)  NULL,
    [IC_CCA]                          VARCHAR (50)  NULL,
    [CO_PRODUTO_GESTAO_PRODUTIVIDADE] VARCHAR (50)  NULL,
    [DT_CONTRATACAO_ORIGINAL]         VARCHAR (50)  NULL,
    [VR_FINANCIAMENTO]                VARCHAR (50)  NULL,
    [IC_OUTLIER]                      VARCHAR (50)  NULL,
    [NO_UNIDADE]                      VARCHAR (50)  NULL,
    [CO_SR]                           VARCHAR (50)  NULL,
    [NO_SR]                           VARCHAR (50)  NULL,
    [CO_SUAT]                         VARCHAR (50)  NULL,
    [NO_SUAT]                         VARCHAR (50)  NULL,
    [CO_CCA]                          VARCHAR (50)  NULL,
    [NU_CNPJ_CCA]                     VARCHAR (50)  NULL,
    [NO_CCA]                          VARCHAR (50)  NULL,
    [CPF]                             VARCHAR (350) NULL,
    [DataArquivo]                     DATE          NULL,
    [NomeArquivo]                     VARCHAR (150) NULL
);

