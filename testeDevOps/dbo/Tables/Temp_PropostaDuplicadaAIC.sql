CREATE TABLE [dbo].[Temp_PropostaDuplicadaAIC] (
    [NumeroProposta] VARCHAR (20) NOT NULL
);


GO
CREATE CLUSTERED INDEX [CL_IDX_PropostaDuplicadaAIC]
    ON [dbo].[Temp_PropostaDuplicadaAIC]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

