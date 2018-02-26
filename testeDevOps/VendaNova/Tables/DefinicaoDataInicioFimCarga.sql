CREATE TABLE [VendaNova].[DefinicaoDataInicioFimCarga] (
    [IDDataCarga]     INT  IDENTITY (1, 1) NOT NULL,
    [DataInicioCarga] DATE NOT NULL,
    [DataFimCarga]    DATE NOT NULL,
    PRIMARY KEY CLUSTERED ([IDDataCarga] ASC) WITH (FILLFACTOR = 90) ON [PRIMARY]
);

