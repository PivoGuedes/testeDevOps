CREATE TABLE [Dados].[PropostaOdontoSubestipulante] (
    [ID]   INT           IDENTITY (1, 1) NOT NULL,
    [Nome] VARCHAR (100) NULL,
    CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_Nome]
    ON [Dados].[PropostaOdontoSubestipulante]([Nome] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

