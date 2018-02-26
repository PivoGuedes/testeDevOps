CREATE TABLE [PowerBI].[HomologacaoProducaoAICDMQVSF] (
    [IDHMLProducaoAIC_DMQVSF] INT          IDENTITY (1, 1) NOT NULL,
    [ANO_MES_COMPETENCIA]     INT          NOT NULL,
    [DATA_VENDA_AIC]          DATE         NULL,
    [DIA]                     INT          NULL,
    [HORA]                    INT          NULL,
    [MINUTO]                  INT          NULL,
    [AGENCIA]                 SMALLINT     NOT NULL,
    [COD_PROPOSTA]            BIGINT       NULL,
    [PRODUTO]                 VARCHAR (50) NULL,
    [EMITIDO_DM]              INT          NOT NULL,
    [EMITIDO_SF]              INT          NULL,
    [VERIFICA_EMITIDOS]       INT          NOT NULL,
    [DATA_COMPLETA_AIC]       DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([IDHMLProducaoAIC_DMQVSF] ASC) ON [PRIMARY]
);

