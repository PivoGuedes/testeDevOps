CREATE TABLE [dbo].[PDCA] (
    [CodigoComercializado]   VARCHAR (5)     NULL,
    [Produto]                VARCHAR (100)   NULL,
    [Ano]                    INT             NULL,
    [Mes]                    INT             NULL,
    [Problema]               VARCHAR (2)     NULL,
    [Agencia]                SMALLINT        NOT NULL,
    [NomeMunicipio]          VARCHAR (35)    NULL,
    [NomeUnidadeSuperior]    VARCHAR (100)   NULL,
    [NomeFilialPARCorretora] VARCHAR (100)   NULL,
    [Qtd]                    INT             NULL,
    [Valor]                  DECIMAL (38, 4) NULL,
    [UF]                     CHAR (2)        NULL
);

