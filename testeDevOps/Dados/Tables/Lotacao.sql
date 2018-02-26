CREATE TABLE [Dados].[Lotacao] (
    [ID]           SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Descricao]    VARCHAR (70) NULL,
    [DataCadastro] DATETIME     DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_DadosLotacao_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

