CREATE TABLE [ControleDados].[LogSTAFCAPTP8] (
    [ID]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [NumeroProposta]        VARCHAR (20)    NULL,
    [TipoRegistro]          CHAR (2)        NULL,
    [NumeroPlano]           SMALLINT        NULL,
    [SerieTitulo]           CHAR (2)        NULL,
    [NumeroTitulo]          CHAR (7)        NULL,
    [DigitoNumeroTitulo]    CHAR (1)        NULL,
    [NumeroParcela]         TINYINT         NULL,
    [MotivoSituacaoTitulo]  INT             NULL,
    [ValorTitulo]           NUMERIC (13, 2) NULL,
    [DataHoraProcessamento] DATETIME        CONSTRAINT [DF_LogSTAFCAPTP8_DataHoraProcessamento] DEFAULT (getdate()) NOT NULL,
    [DataArquivo]           DATE            NULL,
    [NomeArquivo]           VARCHAR (130)   NULL,
    [FlagCadastrado]        BIT             NULL,
    CONSTRAINT [PK_LogSTAFCAPTP8_1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [PK_LogSTAFCAPTP8] UNIQUE NONCLUSTERED ([NumeroProposta] ASC, [NumeroTitulo] ASC, [SerieTitulo] ASC, [DigitoNumeroTitulo] ASC, [NumeroParcela] ASC, [NumeroPlano] ASC, [DataArquivo] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [idxNCL_LogSTAFCAPTP8]
    ON [ControleDados].[LogSTAFCAPTP8]([NumeroPlano] ASC, [SerieTitulo] ASC, [NumeroTitulo] ASC, [DigitoNumeroTitulo] ASC, [DataArquivo] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

