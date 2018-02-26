CREATE TABLE [PowerBI].[FluxoComissaoSAF_Pagamento] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [AnoMes]        VARCHAR (6)     NOT NULL,
    [CNPJ]          VARCHAR (20)    NULL,
    [Nome]          VARCHAR (120)   NULL,
    [DocEmpresa]    VARCHAR (10)    NULL,
    [Banco]         VARCHAR (10)    NULL,
    [Agencia]       VARCHAR (6)     NULL,
    [Conta]         VARCHAR (15)    NULL,
    [ValorPago]     DECIMAL (12, 2) NULL,
    [ValorBox]      DECIMAL (12, 2) NULL,
    [Ocorrencia]    VARCHAR (120)   NULL,
    [CodOcorrencia] VARCHAR (6)     NULL,
    [PagamentoOk]   BIT             NOT NULL,
    [Publicado]     BIT             NOT NULL,
    CONSTRAINT [PK_FluxoComissaoSAF_Pagamento] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

