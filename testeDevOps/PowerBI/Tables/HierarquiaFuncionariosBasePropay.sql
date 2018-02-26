CREATE TABLE [PowerBI].[HierarquiaFuncionariosBasePropay] (
    [IDHieFuncBasePropay] INT           IDENTITY (1, 1) NOT NULL,
    [CodEmpresa]          SMALLINT      NULL,
    [CodHierarquia]       VARCHAR (MAX) NULL,
    [CodigoCargo]         VARCHAR (260) NULL,
    [Cargo]               VARCHAR (260) NULL,
    PRIMARY KEY CLUSTERED ([IDHieFuncBasePropay] ASC) ON [PRIMARY]
) TEXTIMAGE_ON [PRIMARY];

