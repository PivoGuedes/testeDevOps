CREATE TABLE [Dados].[Comissionamento_BKP] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [TP]               VARCHAR (2)  NULL,
    [CodUnidadeVenda]  VARCHAR (4)  NULL,
    [VlrAprovisionado] VARCHAR (20) NULL,
    [MatrGestor ]      VARCHAR (50) NULL,
    [MesRef]           VARCHAR (50) NULL,
    [DataArquivo]      DATETIME     NULL,
    [NomeArquivo]      VARCHAR (50) NULL
);

