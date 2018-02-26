CREATE TABLE [Dados].[TelefoneContatoPessoa] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IDContatoPessoa]     BIGINT        NULL,
    [IDOrigemDadoContato] INT           NOT NULL,
    [Telefone]            VARCHAR (20)  NOT NULL,
    [Ordem]               INT           NULL,
    [DataAtualizacao]     DATETIME2 (7) NULL,
    [IsMobile]            BIT           NULL,
    [DataInsercao]        DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_TelefoneContatoPessoa_Contato] FOREIGN KEY ([IDContatoPessoa]) REFERENCES [Dados].[ContatoPessoa] ([ID]),
    CONSTRAINT [FK_TelefoneContatoPessoa_OrigemDado] FOREIGN KEY ([IDOrigemDadoContato]) REFERENCES [Dados].[OrigemDadoContato] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_telefone_contatopessoa]
    ON [Dados].[TelefoneContatoPessoa]([IDContatoPessoa] ASC, [IsMobile] ASC, [Ordem] DESC)
    INCLUDE([Telefone]) WITH (FILLFACTOR = 100);

