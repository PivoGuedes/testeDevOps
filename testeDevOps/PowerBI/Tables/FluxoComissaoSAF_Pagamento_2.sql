CREATE TABLE [PowerBI].[FluxoComissaoSAF_Pagamento_2] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [AnoMes]        INT             NOT NULL,
    [CNPJ]          BIGINT          NULL,
    [Nome]          VARCHAR (120)   NULL,
    [DocEmpresa]    INT             NULL,
    [Banco]         INT             NULL,
    [Agencia]       VARCHAR (6)     NULL,
    [Conta]         VARCHAR (15)    NULL,
    [ValorPago]     DECIMAL (12, 2) NULL,
    [ValorBox]      DECIMAL (12, 2) NULL,
    [Ocorrencia]    VARCHAR (120)   NULL,
    [CodOcorrencia] VARCHAR (6)     NULL,
    [PagamentoOk]   BIT             NOT NULL,
    [Publicado]     BIT             NOT NULL,
    CONSTRAINT [PK_FluxoComissaoSAF_Pagamento_2] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

