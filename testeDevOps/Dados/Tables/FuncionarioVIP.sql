CREATE TABLE [Dados].[FuncionarioVIP] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [Empresa]           VARCHAR (200) NULL,
    [CPF]               VARCHAR (20)  NULL,
    [NomeFuncionario]   VARCHAR (200) NULL,
    [DataNascimento]    DATE          NULL,
    [NivelFuncao]       VARCHAR (100) NULL,
    [DataBaseVip]       DATE          NULL,
    [EmailProfissional] VARCHAR (200) NULL,
    [SituacaoVip]       VARCHAR (20)  NULL,
    [NomeArquivo]       VARCHAR (200) NULL,
    [DataArquivo]       DATE          NULL,
    CONSTRAINT [pkFuncionarioVIP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

