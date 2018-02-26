CREATE TABLE [PowerBI].[FluxoComissaoSAF_Arquivo_2] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [CodigoBU]        INT           NULL,
    [CodigoProduto]   INT           NULL,
    [NumeroRecibo]    BIGINT        NULL,
    [DataArquivo]     VARCHAR (11)  NULL,
    [AnoMes]          INT           NOT NULL,
    [NumeroMatricula] BIGINT        NULL,
    [NumeroContrato]  BIGINT        NULL,
    [NumeroProposta]  BIGINT        NULL,
    [NumeroParcela]   INT           NULL,
    [ValorCorretagem] FLOAT (53)    NULL,
    [NomeArquivo]     VARCHAR (300) NULL,
    [Tipo]            VARCHAR (10)  NOT NULL,
    [FluxoCompleto]   VARCHAR (3)   NOT NULL,
    [Motivo]          VARCHAR (150) NULL,
    [Nome]            VARCHAR (150) NULL,
    [CPFCNPJ]         VARCHAR (14)  NULL,
    [Publicado]       BIT           NULL,
    CONSTRAINT [PK_FluxoComissaoSAF_Arquivo_2] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

