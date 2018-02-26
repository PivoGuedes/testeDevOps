CREATE TABLE [Dados].[BeneficioPrevBemFamilia] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

