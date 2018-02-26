CREATE TABLE [Dados].[BlackListTelefone] (
    [CPFContato] VARCHAR (30) NULL,
    [Telefone]   VARCHAR (30) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_CPFTel]
    ON [Dados].[BlackListTelefone]([CPFContato] ASC, [Telefone] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON);

