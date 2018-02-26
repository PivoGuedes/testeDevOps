CREATE TABLE [dbo].[ClienteRESPF] (
    [CPF]            VARCHAR (18)  NULL,
    [FirstName]      VARCHAR (MAX) NULL,
    [LastName]       VARCHAR (MAX) NULL,
    [Nome]           VARCHAR (140) NULL,
    [DataNascimento] DATE          NULL,
    [Bairro]         VARCHAR (80)  NULL,
    [Cidade]         VARCHAR (80)  NULL,
    [Endereco]       VARCHAR (150) NULL,
    [UF]             CHAR (2)      NULL,
    [TelCelular]     VARCHAR (25)  NULL,
    [TelResidencial] VARCHAR (25)  NULL,
    [TelComercial]   VARCHAR (25)  NULL,
    [Sexo]           VARCHAR (20)  NULL,
    [EstadoCivil]    VARCHAR (30)  NULL,
    [CEP]            VARCHAR (9)   NULL,
    [Email]          VARCHAR (80)  NULL,
    [Emailcomercial] VARCHAR (80)  NULL,
    [ORDEM]          BIGINT        NULL
);

