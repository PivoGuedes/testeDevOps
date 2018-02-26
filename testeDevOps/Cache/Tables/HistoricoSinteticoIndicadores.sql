CREATE TABLE [Cache].[HistoricoSinteticoIndicadores] (
    [AnoMes]             INT             NULL,
    [CPF]                VARCHAR (50)    NULL,
    [Conta]              VARCHAR (50)    NULL,
    [Matricula]          VARCHAR (50)    NULL,
    [MatriculaDV]        VARCHAR (50)    NULL,
    [Nome]               VARCHAR (200)   NULL,
    [ValorComissao]      DECIMAL (19, 2) NULL,
    [ValorINS]           VARCHAR (50)    NULL,
    [ValorINSSemp]       DECIMAL (19, 2) NULL,
    [ValorIRPF]          DECIMAL (19, 2) NULL,
    [ValorISS]           DECIMAL (19, 2) NULL,
    [ValorPontosEnv]     VARCHAR (50)    NULL,
    [ValorPontosINS]     VARCHAR (50)    NULL,
    [ValorPontosINSSemp] VARCHAR (50)    NULL,
    [ValorPontosIRPF]    VARCHAR (50)    NULL,
    [ValorPontosISS]     VARCHAR (50)    NULL
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_HistoricoSinteticoIndicadores_CPF]
    ON [Cache].[HistoricoSinteticoIndicadores]([CPF] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_HistoricoSinteticoIndicadores_Matricula]
    ON [Cache].[HistoricoSinteticoIndicadores]([Matricula] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

