CREATE TABLE [dbo].[SSDConferenciaParcela] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [NomeArquivo]       VARCHAR (100)   NULL,
    [DataArquivo]       DATE            NULL,
    [BILHETE]           VARCHAR (200)   NULL,
    [PROPOSTA]          VARCHAR (100)   NULL,
    [TABELA]            VARCHAR (50)    NULL,
    [APOLICE]           VARCHAR (50)    NULL,
    [PRODUTO_SIVPF]     VARCHAR (10)    NULL,
    [PRODUTO_SIAS]      VARCHAR (10)    NULL,
    [DataEmissao]       DATETIME        NULL,
    [DataVenda]         DATETIME        NULL,
    [ValorODS]          DECIMAL (24, 4) NULL,
    [ValorSSD]          DECIMAL (24, 4) NULL,
    [IDProposta]        BIGINT          NULL,
    [SUK_CONTRATOVIDA]  INT             NULL,
    [DTH_BAIXA_PARCELA] DATE            NULL,
    [NUM_PARCELA]       INT             NULL
);

