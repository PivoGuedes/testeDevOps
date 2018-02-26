CREATE TABLE [dbo].[PRP_RES] (
    [IDProposta]        BIGINT NULL,
    [IDContrato]        BIGINT NULL,
    [ContratoEndosso]   BIT    NULL,
    [PropostaSIGPF]     BIT    NULL,
    [PropostaRES]       BIT    NULL,
    [StatusParcelaCan]  BIT    NULL,
    [StatusPropCan]     BIT    NULL,
    [StatusContratoCan] BIT    NULL,
    [StatusEndossoCan]  BIT    NULL,
    [IDProduto]         INT    NULL
);


GO
CREATE CLUSTERED INDEX [IDX_CL_IDContrato_IDProposta]
    ON [dbo].[PRP_RES]([IDContrato] ASC, [IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

