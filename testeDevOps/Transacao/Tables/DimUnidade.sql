CREATE TABLE [Transacao].[DimUnidade] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [CdAgencia]          INT           NOT NULL,
    [NmAgencia]          VARCHAR (400) NOT NULL,
    [CdSR]               INT           NOT NULL,
    [DsSR]               VARCHAR (400) NULL,
    [CdDire]             INT           NOT NULL,
    [DsDire]             VARCHAR (400) NULL,
    [DsGerenteVendas]    VARCHAR (400) NULL,
    [DsGerenciaVendas]   VARCHAR (400) NULL,
    [DsGerenteRegional]  VARCHAR (400) NULL,
    [DsGerenciaRegional] VARCHAR (400) NULL,
    [DsGerenteNacional]  VARCHAR (400) NULL,
    [DsGerenciaNacional] VARCHAR (400) NULL,
    [FlAsven]            VARCHAR (50)  NOT NULL,
    [FlAsven2]           VARCHAR (50)  NOT NULL,
    [NmAsven]            VARCHAR (400) NULL,
    [Ativo]              BIT           DEFAULT ((1)) NOT NULL,
    [DtVigenciaInicio]   DATETIME      NOT NULL,
    [DtVigenciaFim]      DATETIME      NOT NULL,
    [DataAtualizacao]    DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_DimUnidade] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_dataUnidade]
    ON [Transacao].[DimUnidade]([CdAgencia] ASC, [DtVigenciaInicio] ASC, [DtVigenciaFim] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_codigoUnidade]
    ON [Transacao].[DimUnidade]([CdAgencia] ASC) WITH (FILLFACTOR = 90);

