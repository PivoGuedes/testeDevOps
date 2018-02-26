CREATE TABLE [dbo].[SQGImob_TEMP] (
    [Codigo]                 BIGINT          NOT NULL,
    [Grupo]                  VARCHAR (6)     NULL,
    [Cota]                   VARCHAR (9)     NULL,
    [Prazo]                  INT             NULL,
    [Assembleia]             VARCHAR (3)     NULL,
    [InicioVigencia]         DATE            NULL,
    [Nome]                   VARCHAR (35)    NULL,
    [Sexo]                   VARCHAR (1)     NULL,
    [DataNascimeto]          DATE            NULL,
    [CPFCNPJ]                VARCHAR (20)    NULL,
    [TipoMovimento]          VARCHAR (1)     NULL,
    [Beneficiario]           VARCHAR (35)    NULL,
    [Bem]                    VARCHAR (35)    NULL,
    [TipoCobertura]          VARCHAR (2)     NULL,
    [Capital]                DECIMAL (18, 2) NULL,
    [NumeroPrestacaoPaga]    INT             NULL,
    [AnoMes]                 INT             NULL,
    [PrestacaoPagaRemessa]   INT             NULL,
    [AnoMesPrestacao]        INT             NULL,
    [DataPagamentoPremio]    DATE            NULL,
    [PremioSqg]              DECIMAL (18, 2) NULL,
    [PrazoGrupo]             INT             NULL,
    [Contrato]               VARCHAR (15)    NULL,
    [PercentualTA]           DECIMAL (18, 4) NULL,
    [PercentualFundoReserva] DECIMAL (18, 4) NULL,
    [ValorPagoSemMulta]      DECIMAL (18, 2) NULL,
    [ValorParcela]           DECIMAL (18, 2) NULL,
    [PercentualSqg]          DECIMAL (18, 4) NULL,
    [DataArquivo]            DATE            NOT NULL,
    [NomeArquivo]            VARCHAR (250)   NOT NULL
);


GO
CREATE CLUSTERED INDEX [idxSqlImob_Temp]
    ON [dbo].[SQGImob_TEMP]([Contrato] ASC) WITH (FILLFACTOR = 90);

