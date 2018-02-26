CREATE TABLE [Transacao].[TipoPessoa] (
    [ID]        INT       IDENTITY (1, 1) NOT NULL,
    [Codigo]    INT       NOT NULL,
    [Descricao] CHAR (10) NOT NULL,
    CONSTRAINT [PK_TIPOPESSOA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

