CREATE TABLE [Dados].[SegmentoSaude] (
    [ID]                 SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Codigo]             CHAR (5)     NOT NULL,
    [Nome]               VARCHAR (50) NULL,
    [IDTipoSegmento]     INT          NULL,
    [IDTipoClienteSaude] INT          NULL,
    [IDTipoEmpresaSaude] INT          NULL,
    CONSTRAINT [PK_SegmentoSaude_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

