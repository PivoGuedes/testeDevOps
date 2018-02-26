CREATE TABLE [dbo].[ClientesMagnus] (
    [id]              INT           NULL,
    [nome]            VARCHAR (150) NULL,
    [cpf]             VARCHAR (50)  NULL,
    [carteira]        VARCHAR (50)  NULL,
    [asvex]           VARCHAR (50)  NULL,
    [cargo]           VARCHAR (150) NULL,
    [estadocivil]     VARCHAR (50)  NULL,
    [sexo]            VARCHAR (50)  NULL,
    [datanasc]        VARCHAR (50)  NULL,
    [email]           VARCHAR (50)  NULL,
    [numerodocumento] VARCHAR (50)  NULL,
    [orgaoexp]        VARCHAR (50)  NULL,
    [ufexped]         VARCHAR (50)  NULL,
    [dataexpedicao]   VARCHAR (50)  NULL,
    [empresa]         VARCHAR (150) NULL,
    [nivel_funcao]    VARCHAR (50)  NULL,
    [CPFFormatado]    VARCHAR (20)  NULL
);


GO
CREATE CLUSTERED INDEX [idxClienteMagnus]
    ON [dbo].[ClientesMagnus]([cpf] ASC) WITH (FILLFACTOR = 90);

