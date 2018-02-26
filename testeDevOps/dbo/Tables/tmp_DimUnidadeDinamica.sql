CREATE TABLE [dbo].[tmp_DimUnidadeDinamica] (
    [PVCodigo] SMALLINT     NULL,
    [NmAsVen]  VARCHAR (50) NULL
);


GO
CREATE CLUSTERED INDEX [IDX_CL_tmp_DimUnidadeDinamica]
    ON [dbo].[tmp_DimUnidadeDinamica]([PVCodigo] ASC) WITH (FILLFACTOR = 90);

