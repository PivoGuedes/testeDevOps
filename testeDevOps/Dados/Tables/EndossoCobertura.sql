CREATE TABLE [Dados].[EndossoCobertura] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [IDEndosso]           BIGINT          NOT NULL,
    [IDCobertura]         SMALLINT        NOT NULL,
    [NumeroItem]          SMALLINT        CONSTRAINT [DF_ContratoCobertura_NumeroItem] DEFAULT ((0)) NOT NULL,
    [DataInicioVigencia]  DATE            NULL,
    [DataFimVigencia]     DATE            NULL,
    [ImportanciaSegurada] DECIMAL (19, 2) NULL,
    [LimiteIndenizacao]   DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]  DECIMAL (19, 2) NULL,
    [ValorFranquia]       DECIMAL (19, 2) NULL,
    [Arquivo]             VARCHAR (100)   NULL,
    [DataArquivo]         DATE            NULL,
    [FranquiaMinima]      VARCHAR (50)    NULL,
    [FranquiaMaxima]      VARCHAR (50)    NULL,
    CONSTRAINT [PK_SeguroCobertura] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_ENDOSSOC_COBERTURA] FOREIGN KEY ([IDCobertura]) REFERENCES [Dados].[Cobertura] ([ID]),
    CONSTRAINT [FK_EndossoCobertura] FOREIGN KEY ([IDEndosso]) REFERENCES [Dados].[Endosso] ([ID])
);


GO
CREATE CLUSTERED INDEX [IDX_CL_Endosso]
    ON [Dados].[EndossoCobertura]([DataInicioVigencia] DESC, [LimiteIndenizacao] DESC, [IDEndosso] DESC, [IDCobertura] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_UNQ_NCLEndossoCobertura]
    ON [Dados].[EndossoCobertura]([IDEndosso] ASC, [IDCobertura] ASC, [NumeroItem] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

