CREATE TABLE [Dados].[ProspectOferta] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Nome]         VARCHAR (60) NOT NULL,
    [DataCadastro] DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ProspectOferta_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

