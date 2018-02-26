CREATE TABLE [dbo].[Teste] (
    [Matricula]         BIGINT          NOT NULL,
    [Nome]              VARCHAR (140)   NULL,
    [ID]                BIGINT          NOT NULL,
    [ARQUIVO]           VARCHAR (80)    NOT NULL,
    [IDCorrespondente]  INT             NOT NULL,
    [ValorCorretagem]   DECIMAL (19, 2) NULL,
    [DataProcessamento] DATE            NULL
);

