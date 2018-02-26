CREATE TABLE [dbo].[Temp_Contrato_Renovacao] (
    [ID]                 BIGINT IDENTITY (1, 1) NOT NULL,
    [IDContratoAnterior] BIGINT NULL
);


GO
CREATE CLUSTERED INDEX [PK_IDX_Temp_Contrato_Renovacao]
    ON [dbo].[Temp_Contrato_Renovacao]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

