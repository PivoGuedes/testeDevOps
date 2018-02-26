CREATE TABLE [Dados].[AtendimentoContatos] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [TelefoneEmail] VARCHAR (300) NULL,
    [TipoContato]   AS            (case when charindex('@',[TelefoneEmail])>(0) then 'Email' else 'Telefone' end),
    CONSTRAINT [PK_AtendimentoContatos_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_TelefoneEmail_AtendimentoContatos]
    ON [Dados].[AtendimentoContatos]([TelefoneEmail] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

