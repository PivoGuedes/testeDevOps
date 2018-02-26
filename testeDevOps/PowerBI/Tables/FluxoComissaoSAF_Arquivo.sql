CREATE TABLE [PowerBI].[FluxoComissaoSAF_Arquivo] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [CodigoBU]        VARCHAR (6)   NULL,
    [CodigoProduto]   VARCHAR (10)  NULL,
    [NumeroRecibo]    VARCHAR (30)  NULL,
    [DataArquivo]     VARCHAR (11)  NULL,
    [AnoMes]          VARCHAR (6)   NOT NULL,
    [NumeroMatricula] VARCHAR (30)  NULL,
    [NumeroContrato]  VARCHAR (30)  NULL,
    [NumeroProposta]  VARCHAR (30)  NULL,
    [NumeroParcela]   VARCHAR (3)   NULL,
    [ValorCorretagem] FLOAT (53)    NULL,
    [NomeArquivo]     VARCHAR (300) NULL,
    [Tipo]            VARCHAR (10)  NOT NULL,
    [FluxoCompleto]   VARCHAR (3)   NOT NULL,
    [Motivo]          VARCHAR (150) NULL,
    [Nome]            VARCHAR (150) NULL,
    [CPFCNPJ]         VARCHAR (14)  NULL,
    [Publicado]       BIT           NULL,
    CONSTRAINT [PK_FluxoComissaoSAF_Arquivo] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

