CREATE TABLE [Dados].[PropostaProduto] (
    [ID]             INT    IDENTITY (1, 1) NOT NULL,
    [IDProposta]     BIGINT NULL,
    [IDProduto]      INT    NULL,
    [DataReferencia] DATE   NULL,
    CONSTRAINT [PK_NCL_PropostaProduto] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_CL] UNIQUE CLUSTERED ([IDProposta] DESC, [DataReferencia] DESC, [IDProduto] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

