CREATE TABLE [Dados].[AtendimentoContatosPARIndica] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [TelefoneEmail] VARCHAR (80) NOT NULL,
    [TipoContato]   AS           (case when charindex('@',[TelefoneEmail])>(0) then 'Email' else 'Telefone' end) PERSISTED NOT NULL,
    CONSTRAINT [PK_AtendimentoContatosPARIndica_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

