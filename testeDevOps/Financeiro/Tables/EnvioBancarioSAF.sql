CREATE TABLE [Financeiro].[EnvioBancarioSAF] (
    [ID]         INT             IDENTITY (1, 1) NOT NULL,
    [Nome]       VARCHAR (30)    NULL,
    [CNPJ]       VARCHAR (14)    NULL,
    [Banco]      VARCHAR (4)     NULL,
    [Agencia]    VARCHAR (5)     NULL,
    [Conta]      VARCHAR (15)    NULL,
    [DocEmpresa] INT             NULL,
    [Valor]      DECIMAL (12, 2) NULL,
    [AnoMes]     VARCHAR (6)     NULL,
    CONSTRAINT [PK_EntradaBancarioSAF] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

