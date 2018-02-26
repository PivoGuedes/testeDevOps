CREATE TABLE [Dados].[TipoSubAcao] (
    [ID]           TINYINT      IDENTITY (1, 1) NOT NULL,
    [Nome]         VARCHAR (80) NOT NULL,
    [DataCadastro] DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TipoSubAcao_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

