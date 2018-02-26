CREATE TABLE [dbo].[ContratoClienteExcluidos] (
    [IDContrato]    BIGINT        NOT NULL,
    [TipoPessoa]    VARCHAR (15)  NULL,
    [CPFCNPJ]       VARCHAR (18)  NULL,
    [NomeCliente]   VARCHAR (140) NULL,
    [CodigoCliente] VARCHAR (9)   NULL,
    [Endereco]      VARCHAR (40)  NULL,
    [Bairro]        VARCHAR (20)  NULL,
    [Cidade]        VARCHAR (20)  NULL,
    [UF]            CHAR (2)      NULL,
    [CEP]           CHAR (9)      NULL,
    [DDD]           VARCHAR (4)   NULL,
    [Telefone]      VARCHAR (10)  NULL,
    [LastValue]     BIT           NULL,
    [DataArquivo]   DATE          NOT NULL,
    [Arquivo]       VARCHAR (80)  NULL
);

