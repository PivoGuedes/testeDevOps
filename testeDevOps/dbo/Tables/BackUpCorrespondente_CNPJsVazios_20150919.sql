CREATE TABLE [dbo].[BackUpCorrespondente_CNPJsVazios_20150919] (
    [IDErrado]             INT           NOT NULL,
    [CPFCNPJErrado]        VARCHAR (18)  NULL,
    [ID]                   INT           NOT NULL,
    [Matricula]            BIGINT        NOT NULL,
    [CPFCNPJ]              VARCHAR (18)  NULL,
    [Nome]                 VARCHAR (140) NULL,
    [IDTipoCorrespondente] TINYINT       NULL,
    [IDUnidade]            SMALLINT      NULL,
    [UF]                   CHAR (2)      NULL,
    [Cidade]               VARCHAR (70)  NULL,
    [NomeArquivo]          VARCHAR (100) NOT NULL,
    [DataArquivo]          DATE          NULL,
    [MatriculaErrada]      BIGINT        NULL,
    [ORDEM]                INT           NOT NULL
);

