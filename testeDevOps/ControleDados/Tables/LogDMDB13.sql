CREATE TABLE [ControleDados].[LogDMDB13] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [DataGravacao]            DATETIME2 (7)   NOT NULL,
    [DataRestore]             DATETIME2 (7)   NULL,
    [NomeArquivo]             VARCHAR (100)   NOT NULL,
    [ProcessouArquivo]        BIT             NOT NULL,
    [DataFimProcessamento]    DATETIME2 (7)   NULL,
    [DataInicioProcessamento] DATETIME2 (7)   NULL,
    [TamanhoArquivo]          DECIMAL (18, 4) NULL,
    [DataArquivo]             AS              (CONVERT([datetime],(((left(right([NomeArquivo],(12)),(4))+'-')+left(right([NomeArquivo],(8)),(2)))+'-')+left(right([NomeArquivo],(6)),(2)),(101))) PERSISTED,
    CONSTRAINT [PK_LogDMDB13] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

