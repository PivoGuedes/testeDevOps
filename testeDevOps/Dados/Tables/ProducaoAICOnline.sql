CREATE TABLE [Dados].[ProducaoAICOnline] (
    [ANO_MES_COMPETENCIA] NVARCHAR (4000) NOT NULL,
    [DATA_VENDA_AIC]      DATE            NULL,
    [DIA]                 INT             NULL,
    [HORA]                INT             NULL,
    [MINUTO]              INT             NULL,
    [AGENCIA]             SMALLINT        NOT NULL,
    [COD_PROPOSTA]        BIGINT          NULL,
    [PRODUTO]             VARCHAR (50)    NULL,
    [EMITIDO]             INT             NOT NULL
);

