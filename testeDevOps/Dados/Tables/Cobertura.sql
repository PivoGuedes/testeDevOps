CREATE TABLE [Dados].[Cobertura] (
    [ID]     SMALLINT     IDENTITY (1, 1) NOT NULL,
    [IDRamo] SMALLINT     NULL,
    [Codigo] SMALLINT     NOT NULL,
    [Nome]   VARCHAR (70) NOT NULL,
    CONSTRAINT [PK_Cobertura] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Cobertura_Ramo] FOREIGN KEY ([IDRamo]) REFERENCES [Dados].[Ramo] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_cobertura_ramo]
    ON [Dados].[Cobertura]([Codigo] ASC, [IDRamo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

