CREATE TABLE [Dados].[PremiacaoIndicadoresTeto] (
    [ID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [ValorTeto]  DECIMAL (19, 4) NULL,
    [DataInicio] DATE            NOT NULL,
    [Tipo]       VARCHAR (2)     NULL,
    CONSTRAINT [PK_PremiacaoIndicadoresTeto] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_CNT_PremiacaoIndicadoresTeto] UNIQUE NONCLUSTERED ([DataInicio] ASC, [Tipo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

