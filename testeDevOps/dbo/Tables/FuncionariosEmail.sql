CREATE TABLE [dbo].[FuncionariosEmail] (
    [IDFuncionarioEmail] TINYINT        NOT NULL,
    [IDGrupoEmail]       TINYINT        NOT NULL,
    [NomesEmail]         VARCHAR (1000) NOT NULL,
    [DataCadastro]       DATETIME       DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_FuncionariosEmail_ID] PRIMARY KEY CLUSTERED ([IDFuncionarioEmail] ASC, [IDGrupoEmail] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_FuncionariosEmail_ID_IDGrupoEmail] FOREIGN KEY ([IDGrupoEmail]) REFERENCES [dbo].[GrupoRecebimentoEmail] ([ID])
);

