CREATE TABLE [Dados].[Status_Final] (
    [ID]           TINYINT       IDENTITY (1, 1) NOT NULL,
    [Nome]         VARCHAR (300) NOT NULL,
    [DataCadastro] DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Status_Final] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

