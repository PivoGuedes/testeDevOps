CREATE TABLE [dbo].[Funcionarios_FENAE] (
    [MATRICULA]      NVARCHAR (255) NULL,
    [NOME]           NVARCHAR (255) NULL,
    [DATANASCIMENTO] DATETIME       NULL,
    [CPF]            NVARCHAR (255) NULL,
    [EMAIL]          NVARCHAR (255) NULL,
    [TELEFONE]       NVARCHAR (255) NULL,
    [id]             INT            IDENTITY (1, 1) NOT NULL
);

