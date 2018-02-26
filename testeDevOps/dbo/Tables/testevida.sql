CREATE TABLE [dbo].[testevida] (
    [numeroproposta] VARCHAR (20) NULL
);


GO
CREATE CLUSTERED INDEX [cl_ix_testevida]
    ON [dbo].[testevida]([numeroproposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

