CREATE TABLE [Dados].[PeriodoContratacao] (
    [ID]        TINYINT      NOT NULL,
    [Codigo]    CHAR (2)     NULL,
    [Descricao] VARCHAR (20) NULL,
    CONSTRAINT [PK_PeriodoContratacao] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PeriodoContratacao', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'PeriodoContratacao';

