CREATE TABLE [Dados].[Dados_FinanciamentoCliente] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [IDFinanciamento] INT           NOT NULL,
    [CPFCNPJ]         VARCHAR (18)  NULL,
    [NomeCliente]     VARCHAR (140) NULL,
    [Endereco]        VARCHAR (40)  NULL,
    [Bairro]          VARCHAR (20)  NULL,
    [Complamento]     VARCHAR (50)  NULL,
    [UF]              CHAR (2)      NULL,
    [CEP]             CHAR (9)      NULL,
    [DDD]             VARCHAR (4)   NULL,
    [Telefone]        VARCHAR (10)  NULL,
    [DataArquivo]     DATE          NOT NULL,
    [Arquivo]         VARCHAR (80)  NOT NULL,
    [IDSexo]          TINYINT       NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

