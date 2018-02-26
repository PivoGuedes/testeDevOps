CREATE TABLE [dbo].[MR0009B] (
    [NumeroProposta] VARCHAR (20) NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_Proposta_MR]
    ON [dbo].[MR0009B]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

