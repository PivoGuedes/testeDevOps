CREATE TABLE [dbo].[Sheet1$] (
    [CPF]                   VARCHAR (255)  NULL,
    [Nome]                  VARCHAR (255)  NULL,
    [PIS]                   VARCHAR (255)  NULL,
    [Banco]                 VARCHAR (255)  NOT NULL,
    [Operacao]              VARCHAR (255)  NOT NULL,
    [ContaCorrente]         VARCHAR (255)  NOT NULL,
    [ValorBruto]            VARCHAR (255)  NOT NULL,
    [ValorISS]              VARCHAR (255)  NOT NULL,
    [ValorIRF]              NVARCHAR (255) NOT NULL,
    [ValorLiquido]          NVARCHAR (255) NOT NULL,
    [ValorINSS]             NVARCHAR (255) NOT NULL,
    [ValorINSSRecolhidoCEF] NVARCHAR (255) NOT NULL,
    [NomeArquivo]           NVARCHAR (255) NOT NULL,
    [DataArquivo]           NVARCHAR (255) NOT NULL,
    [DataReferencia]        NVARCHAR (255) NOT NULL,
    [IDLote]                NVARCHAR (255) NOT NULL
);

