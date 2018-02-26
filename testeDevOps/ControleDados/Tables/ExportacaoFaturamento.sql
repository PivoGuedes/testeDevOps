CREATE TABLE [ControleDados].[ExportacaoFaturamento] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [DataRecibo]       DATE     NOT NULL,
    [NumeroRecibo]     BIGINT   NULL,
    [DataCompetencia]  DATE     NULL,
    [Autorizado]       BIT      CONSTRAINT [DF__Exportaca__Autor__3B16B004] DEFAULT ((0)) NOT NULL,
    [Processado]       BIT      CONSTRAINT [DF_ExportacaoFaturamento_Processado] DEFAULT ((0)) NOT NULL,
    [DataHoraRegistro] DATETIME CONSTRAINT [DF_ExportacaoFaturamento_DataHoraRegistro] DEFAULT (getdate()) NOT NULL,
    [IDEmpresa]        SMALLINT CONSTRAINT [DF_ExportacaoFaturamento_IDEmpresa] DEFAULT ((3)) NOT NULL,
    CONSTRAINT [PK_ExportacaoFaturamento_ID] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ExportacaoFaturamento_Empresa] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID]),
    CONSTRAINT [UNQ_ExportacaoFaturamento_DataRecibo] UNIQUE CLUSTERED ([DataRecibo] DESC, [NumeroRecibo] DESC, [DataCompetencia] DESC, [IDEmpresa] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

