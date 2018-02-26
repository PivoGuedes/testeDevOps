CREATE TABLE [Dados].[Motivo_Contato] (
    [ID]           TINYINT       IDENTITY (1, 1) NOT NULL,
    [Nome]         VARCHAR (300) NOT NULL,
    [DataCadastro] DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Motivo_Contato_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

