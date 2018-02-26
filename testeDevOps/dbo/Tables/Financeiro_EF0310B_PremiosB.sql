CREATE TABLE [dbo].[Financeiro_EF0310B_PremiosB] (
    [IDProposta]         BIGINT       NOT NULL,
    [NumeroContratoVar]  VARCHAR (30) NULL,
    [DataContrato]       DATE         NULL,
    [DataInicioVigencia] DATE         NULL,
    [DataFimVigencia]    DATE         NULL
);


GO
CREATE CLUSTERED INDEX [NCL_IDX_Financeiro_EF0310B_PremiosB]
    ON [dbo].[Financeiro_EF0310B_PremiosB]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

