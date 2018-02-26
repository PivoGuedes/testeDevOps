CREATE TABLE [dbo].[CorrespondentesExcluidos] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [Matricula]            BIGINT        NOT NULL,
    [CPFCNPJ]              VARCHAR (18)  NULL,
    [Nome]                 VARCHAR (140) NULL,
    [IDTipoCorrespondente] TINYINT       NULL,
    [IDUnidade]            SMALLINT      NULL,
    [UF]                   CHAR (2)      NULL,
    [Cidade]               VARCHAR (70)  NULL,
    [NomeArquivo]          VARCHAR (100) NOT NULL,
    [DataArquivo]          DATE          NULL
);

