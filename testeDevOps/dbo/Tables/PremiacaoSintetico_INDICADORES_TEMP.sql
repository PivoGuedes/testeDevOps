CREATE TABLE [dbo].[PremiacaoSintetico_INDICADORES_TEMP] (
    [Codigo]             INT             NOT NULL,
    [ControleVersao]     DECIMAL (16, 8) NULL,
    [NomeArquivo]        VARCHAR (300)   NULL,
    [MatriculaIndicador] VARCHAR (8)     NULL,
    [CPF]                VARCHAR (20)    NOT NULL,
    [Nome]               VARCHAR (100)   NOT NULL,
    [CodigoAgencia]      SMALLINT        NULL,
    [OperacaoConta]      VARCHAR (10)    NULL,
    [DigitoConta]        VARCHAR (10)    NULL,
    [NumeroConta]        VARCHAR (12)    NULL,
    [ValorBrutoComissao] DECIMAL (19, 2) NULL,
    [ValorINSS]          DECIMAL (19, 2) NULL,
    [ValorIRF]           DECIMAL (19, 2) NULL,
    [ValorISS]           DECIMAL (19, 2) NULL,
    [ValorLiquido]       DECIMAL (19, 2) NULL,
    [DataArquivo]        DATE            NULL,
    [TipoDado]           AS              (CONVERT([varchar](30),case when charindex('ODONTO',[NomeArquivo])>(1) then 'ODONTO' else 'CO318B' end)) PERSISTED,
    [TipoAcordo]         VARCHAR (2)     NULL,
    [Gerente]            AS              (CONVERT([bit],case when [TipoAcordo]='I' then (0) else (1) end)) PERSISTED,
    [MesReferencia]      DATE            NULL
);

