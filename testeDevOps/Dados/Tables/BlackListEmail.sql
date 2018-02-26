CREATE TABLE [Dados].[BlackListEmail] (
    [NomeEmail] VARCHAR (100) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_NomeEmail]
    ON [Dados].[BlackListEmail]([NomeEmail] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON);

