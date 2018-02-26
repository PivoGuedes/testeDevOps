CREATE TABLE [Dados].[RegiaoRede] (
    [ID]           INT          NOT NULL,
    [Nome]         VARCHAR (50) NULL,
    [IDTipoRegiao] SMALLINT     NOT NULL,
    CONSTRAINT [PK_IDRegiaoRede] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

