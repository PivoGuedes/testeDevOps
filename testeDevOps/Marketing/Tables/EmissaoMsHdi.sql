CREATE TABLE [Marketing].[EmissaoMsHdi] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Nome]           VARCHAR (200) NOT NULL,
    [InicioVigencia] DATE          NOT NULL,
    [FimVigencia]    DATE          NOT NULL,
    [Emissao]        DATE          NOT NULL,
    [Operacao]       VARCHAR (100) NOT NULL,
    [ModeloLocal]    VARCHAR (100) NOT NULL,
    [Chassi]         VARCHAR (50)  NOT NULL,
    [Placa]          VARCHAR (20)  NOT NULL,
    [UF]             VARCHAR (2)   NOT NULL,
    [AnoFabricacao]  INT           NOT NULL,
    [AnoModelo]      INT           NOT NULL,
    [Dataarquivo]    DATE          NULL,
    CONSTRAINT [PK_EmissaoHdi] PRIMARY KEY CLUSTERED ([ID] ASC)
);

