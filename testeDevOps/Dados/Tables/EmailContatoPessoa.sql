CREATE TABLE [Dados].[EmailContatoPessoa] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IDContatoPessoa]     BIGINT        NULL,
    [IDOrigemDadoContato] INT           NOT NULL,
    [Email]               VARCHAR (300) NOT NULL,
    [Ordem]               INT           NULL,
    [DataAtualizacao]     DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_EmailContatoPessoa_Contato] FOREIGN KEY ([IDContatoPessoa]) REFERENCES [Dados].[ContatoPessoa] ([ID]),
    CONSTRAINT [FK_EmailContatoPessoa_OrigemDado] FOREIGN KEY ([IDOrigemDadoContato]) REFERENCES [Dados].[OrigemDadoContato] ([ID])
);


GO
ALTER TABLE [Dados].[EmailContatoPessoa] NOCHECK CONSTRAINT [FK_EmailContatoPessoa_Contato];


GO
ALTER TABLE [Dados].[EmailContatoPessoa] NOCHECK CONSTRAINT [FK_EmailContatoPessoa_OrigemDado];


GO
CREATE NONCLUSTERED INDEX [ncl_idx_email_contatopessoa]
    ON [Dados].[EmailContatoPessoa]([IDContatoPessoa] ASC, [Ordem] DESC)
    INCLUDE([Email]) WITH (FILLFACTOR = 100);

