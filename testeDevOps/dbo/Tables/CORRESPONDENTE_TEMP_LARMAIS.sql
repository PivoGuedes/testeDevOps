CREATE TABLE [dbo].[CORRESPONDENTE_TEMP_LARMAIS] (
    [Codigo]               BIGINT          NOT NULL,
    [NomeArquivo]          NVARCHAR (100)  NULL,
    [DataArquivo]          DATE            NULL,
    [ControleVersao]       DECIMAL (16, 8) NULL,
    [NumeroMatricula]      NUMERIC (15)    NULL,
    [CPFCNPJ]              VARCHAR (20)    NULL,
    [Nome]                 VARCHAR (140)   NULL,
    [CodigoBanco]          SMALLINT        NULL,
    [CodigoAgencia]        SMALLINT        NULL,
    [CodigoOperacao]       SMALLINT        NULL,
    [NumeroConta]          VARCHAR (22)    NULL,
    [Cidade]               VARCHAR (70)    NULL,
    [UF]                   VARCHAR (2)     NULL,
    [IDTipoCorrespondente] AS              (case when charindex('/',[CPFCNPJ])>(1) then (1) else (2) end) PERSISTED NOT NULL,
    [IDTipoProduto]        TINYINT         DEFAULT ((2)) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_CORRESPONDENTE_LARMAIS_TEMP_NumeroPropost]
    ON [dbo].[CORRESPONDENTE_TEMP_LARMAIS]([NumeroMatricula] ASC, [DataArquivo] DESC);


GO
CREATE NONCLUSTERED INDEX [IDX_CORRESPONDENTE_LARMAIS_TEMP_PontoVenda]
    ON [dbo].[CORRESPONDENTE_TEMP_LARMAIS]([CodigoAgencia] ASC);

