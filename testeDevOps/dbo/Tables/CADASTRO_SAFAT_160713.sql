CREATE TABLE [dbo].[CADASTRO_SAFAT_160713] (
    [NumeroMatricula]       NUMERIC (15)   NULL,
    [NumeroCNPJ]            NUMERIC (15)   NULL,
    [RazaoSocial]           VARCHAR (40)   NULL,
    [CodigoBanco]           SMALLINT       NULL,
    [CodigoAgencia]         SMALLINT       NULL,
    [CodigoOperacao]        SMALLINT       NULL,
    [NumeroConta]           NUMERIC (15)   NULL,
    [DigitoConta]           VARCHAR (1)    NULL,
    [Cidade]                VARCHAR (20)   NULL,
    [UF]                    VARCHAR (2)    NULL,
    [PontoVenda]            SMALLINT       NULL,
    [DataArquivo]           DATE           NULL,
    [NomeArquivo]           NVARCHAR (100) NULL,
    [DataHoraProcessamento] DATETIME2 (7)  NOT NULL,
    [Codigo]                BIGINT         NOT NULL
);

