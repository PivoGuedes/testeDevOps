CREATE TABLE [ControleDados].[LogPremiacaoINSS_INDICADORES] (
    [Codigo]             INT             IDENTITY (1, 1) NOT NULL,
    [ControleVersao]     DECIMAL (16, 8) NULL,
    [NomeArquivo]        VARCHAR (60)    NULL,
    [MatriculaIndicador] VARCHAR (8)     NULL,
    [CPF]                VARCHAR (20)    NULL,
    [PIS]                VARCHAR (20)    NULL,
    [CBO]                VARCHAR (7)     NULL,
    [ValorRubrica]       DECIMAL (19, 2) NULL,
    [DataArquivo]        DATE            NULL,
    [DataReferencia]     DATE            NULL,
    [TipoDado]           VARCHAR (60)    NULL
);


GO
CREATE CLUSTERED INDEX [IDX_CL_LOG_PremiacaoINSS_INDICADORES]
    ON [ControleDados].[LogPremiacaoINSS_INDICADORES]([DataReferencia] ASC, [CPF] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

