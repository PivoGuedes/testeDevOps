CREATE TABLE [dbo].[Comissionamento_TEMP] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [TP]               VARCHAR (50)  NULL,
    [CodUnidadeVenda]  VARCHAR (50)  NULL,
    [VlrAprovisionado] VARCHAR (50)  NULL,
    [MatrGestor]       INT           NULL,
    [MesRef]           VARCHAR (50)  NULL,
    [DataArquivo]      DATETIME      NULL,
    [NomeArquivo]      VARCHAR (200) NULL
);


GO
CREATE CLUSTERED INDEX [idx_Comissionamento_TEMP_ID]
    ON [dbo].[Comissionamento_TEMP]([ID] ASC);

