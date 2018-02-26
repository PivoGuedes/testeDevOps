CREATE TABLE [Dados].[Plano] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [CodigoPlano]     VARCHAR (20) NULL,
    [VersaoPlano]     VARCHAR (3)  NULL,
    [FormaDeCobranca] INT          NULL,
    [NomePlano]       VARCHAR (60) NULL,
    [NumAns]          INT          NULL,
    [PlanoAns]        VARCHAR (30) NULL,
    [IDSeguradora]    INT          NOT NULL,
    [Empresa]         VARCHAR (2)  NOT NULL,
    CONSTRAINT [PK_PLANO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [ncl_Idx_Codigo]
    ON [Dados].[Plano]([CodigoPlano] ASC)
    INCLUDE([NomePlano]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

