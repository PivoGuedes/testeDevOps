CREATE TABLE [Marketing].[Assistencias] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [Ano]            NVARCHAR (4)   NULL,
    [Mes]            NVARCHAR (2)   NULL,
    [CNPJCPF]        NVARCHAR (15)  NULL,
    [Nome Titular]   NVARCHAR (120) NULL,
    [IDTipoCarteira] INT            NULL,
    [IDPlano]        INT            NULL
);

