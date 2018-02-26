CREATE TABLE [ControleDados].[LogAcordo] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [DataGravacao]            DATETIME2 (7) NOT NULL,
    [DataRestore]             DATETIME2 (7) NULL,
    [NomeArquivo]             VARCHAR (100) NOT NULL,
    [ProcessouArquivo]        BIT           NOT NULL,
    [DataFimProcessamento]    DATETIME2 (7) NULL,
    [DataInicioProcessamento] DATETIME2 (7) NULL
);

