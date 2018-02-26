CREATE TABLE [Dados].[Usuario] (
    [ID]                  INT              IDENTITY (1, 1) NOT NULL,
    [Nome]                VARCHAR (100)    NULL,
    [CPF]                 CHAR (14)        NULL,
    [Email]               VARCHAR (100)    NULL,
    [IDUser]              UNIQUEIDENTIFIER NULL,
    [Login]               VARCHAR (50)     NULL,
    [SituacaoFuncionario] BIT              NULL,
    [Perfil]              TINYINT          NULL,
    [DataCriacao]         DATE             NULL,
    [AcessoFull]          BIT              NULL,
    CONSTRAINT [PK_USUARIO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

