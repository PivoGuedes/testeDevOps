CREATE TABLE [ControleDados].[LogRelatorio] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [NomeArquivo]       VARCHAR (100) NOT NULL,
    [QtdRegistros]      INT           NOT NULL,
    [Requerente]        VARCHAR (100) NOT NULL,
    [DataArquivo]       DATE          NOT NULL,
    [DataProcessamento] DATETIME      NOT NULL,
    [Enviado]           BIT           CONSTRAINT [DF_LogRelatorio_Enviado] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LogRelatorio] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

