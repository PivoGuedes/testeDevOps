CREATE TABLE [Marketing].[EmissaoMsAllianz] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [CPF]                   VARCHAR (20)    NOT NULL,
    [Apolice]               VARCHAR (50)    NOT NULL,
    [Item]                  INT             NOT NULL,
    [Nome]                  VARCHAR (200)   NOT NULL,
    [Filler]                VARCHAR (200)   NULL,
    [Ramo]                  INT             NOT NULL,
    [FimVigencia]           DATE            NOT NULL,
    [PrazoRenovacao]        DATE            NOT NULL,
    [PremioAtual]           DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [PremioLiquidoAnterior] DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [Dataarquivo]           DATE            NULL,
    CONSTRAINT [PK_EmissaoAllianz] PRIMARY KEY CLUSTERED ([ID] ASC)
);

