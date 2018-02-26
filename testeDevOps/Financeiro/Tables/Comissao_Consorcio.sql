CREATE TABLE [Financeiro].[Comissao_Consorcio] (
    [Matricula]             INT             NULL,
    [NumeroContrato]        INT             NULL,
    [Grupo]                 INT             NULL,
    [Cota]                  INT             NULL,
    [NumeroParcela]         INT             NULL,
    [ValorComissao]         DECIMAL (18, 2) NULL,
    [UF]                    VARCHAR (2)     NULL,
    [DataArquivo]           DATE            NULL,
    [NomeArquivo]           VARCHAR (50)    NULL,
    [Producao]              INT             NULL,
    [Operacao]              VARCHAR (50)    NULL,
    [ValorRecebido]         DECIMAL (18, 2) NULL,
    [ValorPago]             DECIMAL (18, 2) NULL,
    [Diferenca]             DECIMAL (18, 2) NULL,
    [Codigo]                INT             NULL,
    [DataHoraprocessamento] DATE            NULL,
    [Observacao]            VARCHAR (150)   NULL,
    [Correspondente]        VARCHAR (100)   NULL,
    [CNPJ]                  VARCHAR (50)    NULL,
    [AnoProducao]           VARCHAR (4)     NULL
);

