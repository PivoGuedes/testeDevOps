CREATE TABLE [Financeiro].[RetornoProtheus] (
    [Codigo]            INT             IDENTITY (1, 1) NOT NULL,
    [Matricula]         VARCHAR (50)    NULL,
    [Valor]             DECIMAL (18, 2) NULL,
    [NumeroBanco]       VARCHAR (50)    NULL,
    [Nome]              VARCHAR (100)   NULL,
    [Banco]             VARCHAR (20)    NULL,
    [Agencia]           VARCHAR (50)    NULL,
    [DVAgencia]         VARCHAR (10)    NULL,
    [Conta]             VARCHAR (50)    NULL,
    [DVConta]           VARCHAR (50)    NULL,
    [Operacao]          VARCHAR (50)    NULL,
    [Municipio]         VARCHAR (50)    NULL,
    [Estado]            VARCHAR (50)    NULL,
    [CPFCNPJ]           VARCHAR (50)    NULL,
    [DataArquivo]       DATE            NULL,
    [DataProcessamento] DATE            NULL,
    [NumeroProposta]    BIGINT          NULL,
    [NumeroContrato]    VARCHAR (50)    NULL
);

