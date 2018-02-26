CREATE TABLE [Transacao].[DimProduto] (
    [CdPRoduto]               INT           NULL,
    [DsProduto]               VARCHAR (200) NULL,
    [CdRamoCS]                INT           NULL,
    [DsRamoCS]                VARCHAR (200) NULL,
    [CdRamoPAR]               INT           NULL,
    [DsRamosPAR]              VARCHAR (200) NULL,
    [CdRamoPARSup]            INT           NULL,
    [DSRamoPARSup]            VARCHAR (200) NULL,
    [CdRamoPARTot]            INT           NULL,
    [DsRamoPARTot]            VARCHAR (200) NULL,
    [CdProdutoSIGPF]          VARCHAR (2)   NULL,
    [DsProdutoSIGPF]          VARCHAR (200) NULL,
    [FlExclusivo]             INT           NULL,
    [DtFimComercializacao]    DATE          NULL,
    [TpPessoaProduto]         VARCHAR (100) NULL,
    [DsProdutoGrupo]          VARCHAR (200) NULL,
    [CdPeriodoPagamento]      VARCHAR (2)   NULL,
    [DsPeriodoPagamento]      VARCHAR (200) NULL,
    [DsPeriodoPagamentoGrupo] VARCHAR (200) NULL
);

