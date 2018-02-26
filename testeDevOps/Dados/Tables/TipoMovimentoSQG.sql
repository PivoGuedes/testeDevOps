CREATE TABLE [Dados].[TipoMovimentoSQG] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Codigo]    VARCHAR (1)  NOT NULL,
    [Descricao] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TipoMovimentoSQG] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

