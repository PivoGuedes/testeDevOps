CREATE TABLE [dbo].[STAFCAP_TP8_TEMP] (
    [Codigo]               BIGINT          NOT NULL,
    [TipoRegistro]         CHAR (2)        NULL,
    [NumeroPlano]          SMALLINT        NULL,
    [SerieTitulo]          CHAR (2)        NULL,
    [NumeroTitulo]         CHAR (7)        NULL,
    [DigitoNumeroTitulo]   CHAR (1)        NULL,
    [NumeroParcela]        INT             NULL,
    [MotivoSituacaoTitulo] INT             NULL,
    [ValorTitulo]          NUMERIC (13, 2) NULL,
    [DataArquivo]          DATE            NULL,
    [NomeArquivo]          VARCHAR (130)   NULL,
    [IDSeguradora]         SMALLINT        DEFAULT ((3)) NULL
);


GO
CREATE CLUSTERED INDEX [idx_STASASSE_TP8_TEMP]
    ON [dbo].[STAFCAP_TP8_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 90);

