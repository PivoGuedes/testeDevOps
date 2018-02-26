CREATE TABLE [ControleDados].[LoteProtheus] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Tipo]        VARCHAR (2)  NOT NULL,
    [Codigo]      VARCHAR (10) NULL,
    [Status]      VARCHAR (50) NULL,
    [Ano]         VARCHAR (4)  NULL,
    [Mes]         VARCHAR (2)  NULL,
    [Processado]  BIT          CONSTRAINT [DF_LoteProtheus_Processado] DEFAULT ((0)) NOT NULL,
    [DataArquivo] DATE         NULL,
    CONSTRAINT [PK_LoteProtheus] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_LoteProtheus]
    ON [ControleDados].[LoteProtheus]([Tipo] ASC, [DataArquivo] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

