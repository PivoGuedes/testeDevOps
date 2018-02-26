CREATE TABLE [ControleDados].[AtividadeGeracaoMailing] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [Descricao]          VARCHAR (50)  NOT NULL,
    [NomeArquivo]        VARCHAR (50)  NULL,
    [PrefixoNomeArquivo] VARCHAR (100) NULL,
    [SufixoNomeArquivo]  VARCHAR (100) NULL,
    [DigitosAno]         INT           NULL,
    [CodigoCampanha]     VARCHAR (50)  NULL,
    [OrdemTarefa]        INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

