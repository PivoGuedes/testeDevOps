CREATE TABLE [FinanceiroPessoal].[FuncionarioFolha] (
    [IDEmpresa]            INT             NULL,
    [NomeEmpresa]          VARCHAR (100)   NULL,
    [Matricula]            VARCHAR (20)    NULL,
    [NomeFuncionario]      VARCHAR (100)   NULL,
    [Salario]              DECIMAL (20, 2) NULL,
    [IDCentroCusto]        VARCHAR (20)    NULL,
    [DescricaoCentroCusto] VARCHAR (150)   NULL,
    [DataSituacao]         DATETIME        NULL,
    [Situacao]             VARCHAR (70)    NULL,
    [DataVigencia]         DATETIME        NULL,
    [DataProcessamento]    DATETIME        NULL,
    [Cargo]                VARCHAR (40)    NULL
);

