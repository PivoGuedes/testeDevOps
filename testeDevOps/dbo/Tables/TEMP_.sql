CREATE TABLE [dbo].[TEMP#] (
    [IDFuncionario]  INT             NOT NULL,
    [IDUnidade]      SMALLINT        NULL,
    [CPF]            VARCHAR (20)    NULL,
    [NomeIndicador]  VARCHAR (100)   NULL,
    [Banco]          VARCHAR (3)     NOT NULL,
    [ContaCorrente]  INT             NOT NULL,
    [OperacaoConta]  INT             NOT NULL,
    [ValorBruto]     DECIMAL (38, 2) NULL,
    [ValorINSS]      DECIMAL (38, 2) NULL,
    [ValorIRF]       DECIMAL (38, 2) NULL,
    [ValorISS]       DECIMAL (38, 2) NULL,
    [ValorLiquido]   DECIMAL (38, 2) NULL,
    [DataArquivo]    DATE            NULL,
    [NomeArquivo]    VARCHAR (300)   NULL,
    [DataReferencia] DATE            NULL,
    [Gerente]        BIT             NULL
);

