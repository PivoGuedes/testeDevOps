CREATE TABLE [Marketing].[EmissaoMsSompo] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [Apolice]        VARCHAR (20)    NOT NULL,
    [InicioVigencia] DATE            NOT NULL,
    [FimVigencia]    DATE            NOT NULL,
    [NomeSegurado]   VARCHAR (200)   NOT NULL,
    [ValorPremio]    DECIMAL (18, 2) NULL,
    [Dataarquivo]    DATE            NULL,
    CONSTRAINT [PK_EmissaoSompo] PRIMARY KEY CLUSTERED ([ID] ASC)
);

