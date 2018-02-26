CREATE TABLE [Financeiro].[Cadastro_Consorcio] (
    [Matricula]             BIGINT        NULL,
    [RazaoSocial]           VARCHAR (140) NULL,
    [NumeroCNPJ]            VARCHAR (100) NULL,
    [CodigoBanco]           INT           NULL,
    [CodigoAgencia]         BIGINT        NULL,
    [CodigoOperacao]        INT           NULL,
    [NumeroConta]           BIGINT        NULL,
    [DigitoConta]           BIGINT        NULL,
    [Cidade]                VARCHAR (50)  NULL,
    [UF]                    VARCHAR (2)   NULL,
    [Operacao]              VARCHAR (50)  NULL,
    [DescricaoBOX]          VARCHAR (100) NULL,
    [Producao]              VARCHAR (2)   NULL,
    [DataArquivo]           DATE          NULL,
    [NomeArquivo]           VARCHAR (50)  NULL,
    [DataHoraprocessamento] DATE          NULL,
    [Banco]                 INT           NULL,
    [Agencia]               INT           NULL
);

