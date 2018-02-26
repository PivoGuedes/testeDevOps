CREATE TABLE [dbo].[Temp_Prop_STASASSE] (
    [IDContrato]         BIGINT   NULL,
    [IDProposta]         BIGINT   NOT NULL,
    [IDSituacaoProposta] TINYINT  NULL,
    [DataSituacao]       DATE     NULL,
    [IDTipoMotivo]       SMALLINT NULL,
    [DataArquivo]        DATE     NOT NULL,
    [ORDER]              BIGINT   NULL
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_Temp_Prop_STASASSE]
    ON [dbo].[Temp_Prop_STASASSE]([IDContrato] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [CL_IDX_Temp_Prop_STASASSE_IDContrato_IDProposta]
    ON [dbo].[Temp_Prop_STASASSE]([IDContrato] ASC, [IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

