CREATE TABLE [dbo].[bkpEndossoCoberturaMRDelete] (
    [ID]                  INT             NOT NULL,
    [IDEndosso]           BIGINT          NOT NULL,
    [IDCobertura]         SMALLINT        NOT NULL,
    [NumeroItem]          SMALLINT        NOT NULL,
    [DataInicioVigencia]  DATE            NULL,
    [DataFimVigencia]     DATE            NULL,
    [ImportanciaSegurada] DECIMAL (19, 2) NULL,
    [LimiteIndenizacao]   DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]  DECIMAL (19, 2) NULL,
    [ValorFranquia]       DECIMAL (19, 2) NULL,
    [Arquivo]             VARCHAR (100)   NULL,
    [DataArquivo]         DATE            NULL,
    [FranquiaMinima]      VARCHAR (50)    NULL,
    [FranquiaMaxima]      VARCHAR (50)    NULL
);

