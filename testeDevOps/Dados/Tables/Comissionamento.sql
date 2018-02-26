CREATE TABLE [Dados].[Comissionamento] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [TP]               VARCHAR (2)     NULL,
    [CodUnidadeVenda]  INT             NULL,
    [VlrAprovisionado] DECIMAL (18, 2) NULL,
    [MatrGestor ]      INT             NULL,
    [MesRef]           VARCHAR (50)    NULL,
    [DataArquivo]      DATETIME        NULL,
    [NomeArquivo]      VARCHAR (50)    NULL
);

