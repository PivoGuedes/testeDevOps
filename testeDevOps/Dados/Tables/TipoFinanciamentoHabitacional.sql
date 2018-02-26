CREATE TABLE [Dados].[TipoFinanciamentoHabitacional] (
    [ID]        SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Codigo]    SMALLINT     NULL,
    [Descricao] VARCHAR (10) NULL,
    CONSTRAINT [pk_OrigemHabitacional] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

