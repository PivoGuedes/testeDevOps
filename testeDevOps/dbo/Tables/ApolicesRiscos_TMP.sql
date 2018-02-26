CREATE TABLE [dbo].[ApolicesRiscos_TMP] (
    [NumeroApolice] VARCHAR (20) NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_NumeroApolice]
    ON [dbo].[ApolicesRiscos_TMP]([NumeroApolice] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

