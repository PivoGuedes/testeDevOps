CREATE TABLE [dbo].[Producao_Final_CCA] (
    [APOLICE      ]                            VARCHAR (50)  NULL,
    [RAZAO SOCIAL                            ] VARCHAR (200) NULL,
    [CODIGO   ]                                VARCHAR (50)  NULL,
    [ApoliceCollate]                           AS            ([Apolice] collate SQL_Latin1_General_CP1_CI_AS)
);


GO
CREATE CLUSTERED INDEX [cl_ix_apolicecollate]
    ON [dbo].[Producao_Final_CCA]([ApoliceCollate] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

