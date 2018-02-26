CREATE TABLE [dbo].[Temp_ExtratoIndicadores] (
    [Matricula]             VARCHAR (20)    NULL,
    [NumeroApolice]         VARCHAR (20)    NULL,
    [NumeroTitulo]          VARCHAR (20)    NULL,
    [Data]                  DATE            NOT NULL,
    [CodigoProduto]         VARCHAR (5)     NOT NULL,
    [DsProduto]             VARCHAR (100)   NULL,
    [Grupo_Produtos]        VARCHAR (1)     NOT NULL,
    [TipoProduto]           VARCHAR (1)     NOT NULL,
    [CodigoAgencia]         SMALLINT        NOT NULL,
    [ValorLiquidoAnalitico] INT             NULL,
    [ValorBrutoAnalitico]   DECIMAL (19, 5) NULL,
    [Tipo]                  VARCHAR (2)     NOT NULL,
    [NumeroParcela]         INT             NULL
);

