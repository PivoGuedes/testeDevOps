CREATE TABLE [ControleDados].[IndicadoresAjustes] (
    [DataAjuste]    DATE NOT NULL,
    [ExibirExtrato] BIT  CONSTRAINT [DF_IndicadoresAjustes_ExibirExtrato] DEFAULT ((0)) NULL,
    [IDLote]        INT  NULL,
    CONSTRAINT [PK_IndicadoresAjustes] PRIMARY KEY CLUSTERED ([DataAjuste] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_IndicadoresAjustes_LoteProtheus] FOREIGN KEY ([IDLote]) REFERENCES [ControleDados].[LoteProtheus] ([ID])
);

