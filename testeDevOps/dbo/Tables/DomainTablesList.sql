CREATE TABLE [dbo].[DomainTablesList] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [IDGrupoEmail] TINYINT      NOT NULL,
    [Nome]         VARCHAR (40) NOT NULL,
    [DataCadastro] DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_DomainTablesList_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_DomainTablesList_ID_IDGrupoEmail] FOREIGN KEY ([IDGrupoEmail]) REFERENCES [dbo].[GrupoRecebimentoEmail] ([ID])
);

