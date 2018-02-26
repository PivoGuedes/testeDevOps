CREATE TABLE [ControleDados].[AuxiliarFTPDiretorio] (
    [Codigo]               SMALLINT      IDENTITY (1, 1) NOT NULL,
    [LikeParaBuscaSQL]     VARCHAR (200) NOT NULL,
    [FileSpecParaBuscaDir] VARCHAR (100) NOT NULL,
    [BolCopiaArquivo]      BIT           NULL
) ON [PRIMARY];

