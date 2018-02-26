CREATE TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP_2] (
    [IDFuncionario]  INT             NOT NULL,
    [IDUnidade]      SMALLINT        NOT NULL,
    [CPF]            VARCHAR (20)    NOT NULL,
    [NomeIndicador]  VARCHAR (100)   NOT NULL,
    [Banco]          VARCHAR (3)     NOT NULL,
    [ContaCorrente]  VARCHAR (21)    NULL,
    [OperacaoConta]  VARCHAR (10)    NULL,
    [ValorBruto]     DECIMAL (19, 2) NULL,
    [ValorINSS]      DECIMAL (19, 2) NOT NULL,
    [ValorIRF]       DECIMAL (19, 2) NOT NULL,
    [ValorISS]       DECIMAL (19, 2) NOT NULL,
    [ValorLiquido]   DECIMAL (19, 2) NULL,
    [DataArquivo]    DATE            NULL,
    [NomeArquivo]    VARCHAR (300)   NULL,
    [DataReferencia] DATE            NULL,
    [Gerente]        BIT             NULL,
    [ORDEM]          BIGINT          NULL
);

