CREATE TABLE [Dados].[EmpresaContabil] (
    [ID]             SMALLINT     IDENTITY (1, 1) NOT NULL,
    [CodigoPROTHEUS] VARCHAR (2)  NOT NULL,
    [CNPJ]           VARCHAR (20) NULL,
    [NomeFantasia]   VARCHAR (50) NULL,
    [RazaoSocial]    VARCHAR (50) NULL,
    CONSTRAINT [PK_EmpresaContabil] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

