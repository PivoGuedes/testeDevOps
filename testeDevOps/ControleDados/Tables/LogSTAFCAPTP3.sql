CREATE TABLE [ControleDados].[LogSTAFCAPTP3] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [NumeroProposta]          VARCHAR (20)    NULL,
    [CodigoPlano]             SMALLINT        NULL,
    [NumeroSerie]             CHAR (2)        NULL,
    [NumeroTitulo]            CHAR (7)        NULL,
    [DigitoTitulo]            CHAR (1)        NULL,
    [NumeroParcela]           SMALLINT        NULL,
    [ValorJurosAtraso]        NUMERIC (13, 2) NULL,
    [ValorProvisaoMatematica] NUMERIC (13, 2) NULL,
    [DataReferenciaProvisao]  DATE            NULL,
    [NossoNumeroComDV]        NUMERIC (14)    NULL,
    [ValorEmAtraso]           NUMERIC (13, 2) NULL,
    [DataValidadeValorAtraso] DATE            NULL,
    [DataVencimento]          DATE            NULL,
    [ValorParcela]            NUMERIC (13, 2) NULL,
    [NomeArquivo]             VARCHAR (130)   NULL,
    [DataArquivo]             DATE            NULL,
    [FlagCadastrado]          BIT             NULL,
    CONSTRAINT [PK_LogSTAFCAPTP3_1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [PK_LogSTAFCAPTP3] UNIQUE NONCLUSTERED ([NumeroProposta] ASC, [NumeroTitulo] ASC, [NumeroSerie] ASC, [DigitoTitulo] ASC, [NumeroParcela] ASC, [CodigoPlano] ASC, [NossoNumeroComDV] ASC, [DataReferenciaProvisao] ASC, [DataArquivo] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [idxNCL_LogSTAFCAPTP3]
    ON [ControleDados].[LogSTAFCAPTP3]([CodigoPlano] ASC, [NumeroSerie] ASC, [NumeroTitulo] ASC, [DigitoTitulo] ASC, [NossoNumeroComDV] ASC, [DataReferenciaProvisao] ASC, [DataArquivo] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

