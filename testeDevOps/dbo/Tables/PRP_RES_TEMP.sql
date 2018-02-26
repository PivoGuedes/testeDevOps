CREATE TABLE [dbo].[PRP_RES_TEMP] (
    [IDProposta]        BIGINT DEFAULT ((0)) NULL,
    [IDContrato]        BIGINT DEFAULT ((0)) NULL,
    [ContratoEndosso]   BIT    DEFAULT ((0)) NULL,
    [PropostaSIGPF]     BIT    DEFAULT ((0)) NULL,
    [PropostaRES]       BIT    DEFAULT ((0)) NULL,
    [StatusParcelaCan]  BIT    DEFAULT ((0)) NULL,
    [StatusPropCan]     BIT    DEFAULT ((0)) NULL,
    [StatusContratoCan] BIT    DEFAULT ((0)) NULL,
    [StatusEndossoCan]  BIT    DEFAULT ((0)) NULL,
    [IDProduto]         INT    NULL
);


GO
CREATE CLUSTERED INDEX [IDX_CL_IDContrato_IDProposta]
    ON [dbo].[PRP_RES_TEMP]([IDContrato] ASC, [IDProposta] ASC) WITH (FILLFACTOR = 90);

