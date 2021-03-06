﻿CREATE TABLE [Dados].[Veiculo] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Codigo] INT           NULL,
    [Nome]   VARCHAR (100) NULL,
    CONSTRAINT [PK_Veiculo] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQNomeVeiculo] UNIQUE NONCLUSTERED ([Nome] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [idx_CL_Veiculo_Codigo]
    ON [Dados].[Veiculo]([Codigo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLVeiculo_Nome]
    ON [Dados].[Veiculo]([Nome] ASC)
    INCLUDE([Codigo], [ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_unq_Veiculo_Codigo]
    ON [Dados].[Veiculo]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

