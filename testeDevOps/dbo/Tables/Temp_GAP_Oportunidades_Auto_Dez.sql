CREATE TABLE [dbo].[Temp_GAP_Oportunidades_Auto_Dez] (
    [NumeroProposta]   VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [nuproposta_]      VARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Coluna 0]         VARCHAR (100) NULL,
    [nuproposta]       VARCHAR (100) NULL,
    [cdcliente]        VARCHAR (100) NULL,
    [dtproposta]       VARCHAR (100) NULL,
    [dtefetivacao]     VARCHAR (100) NULL,
    [DtEmissao]        VARCHAR (100) NULL,
    [DsStatus]         VARCHAR (100) NULL,
    [FlNova]           VARCHAR (100) NULL,
    [mes]              VARCHAR (100) NULL,
    [NumeroProposta_c] AS            ([NumeroProposta] collate SQL_Latin1_General_CP1_CI_AI)
);

