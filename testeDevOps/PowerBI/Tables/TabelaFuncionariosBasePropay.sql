CREATE TABLE [PowerBI].[TabelaFuncionariosBasePropay] (
    [IDFuncionariosBasePropay] INT           IDENTITY (1, 1) NOT NULL,
    [Empresa]                  VARCHAR (20)  NULL,
    [Matricula]                INT           NOT NULL,
    [NomeCompleto]             VARCHAR (100) NULL,
    [CPF]                      FLOAT (53)    NULL,
    [Email]                    VARCHAR (MAX) NULL,
    [CodHierarquiaSup1]        VARCHAR (MAX) NULL,
    [CodHierarquiaSup2]        VARCHAR (MAX) NULL,
    [CodHierarquiaSup3]        VARCHAR (MAX) NULL,
    [CodHierarquiaSup4]        VARCHAR (MAX) NULL,
    [CodHierarquiaSup5]        VARCHAR (MAX) NULL,
    [CodEmpresa]               SMALLINT      NULL,
    [FUCODSITU]                SMALLINT      NULL,
    [CodigoCargo]              VARCHAR (260) NULL,
    [Cargo]                    VARCHAR (260) NULL,
    [SituacaoFuncionario]      VARCHAR (100) NULL,
    [DataSituacao]             DATE          NULL,
    [CodigoCentroCusto]        VARCHAR (100) NULL,
    [CentroCusto]              VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([IDFuncionariosBasePropay] ASC) ON [PRIMARY]
) TEXTIMAGE_ON [PRIMARY];

