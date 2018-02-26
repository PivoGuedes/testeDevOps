CREATE TABLE [dbo].[LarMais_ODS_TEMP] (
    [ID]                   INT           NOT NULL,
    [idContrato]           VARCHAR (50)  NULL,
    [CPFCGCMutuario]       VARCHAR (70)  NULL,
    [nomeMutuario]         VARCHAR (250) NULL,
    [idCodigoCCA]          VARCHAR (50)  NULL,
    [idUnidadeOperacional] VARCHAR (80)  NULL,
    [idApoliceSeguro]      VARCHAR (50)  NULL,
    [dscApoliceSeguro]     VARCHAR (60)  NULL,
    [idSolicitante]        VARCHAR (50)  NULL,
    [DataArquivo]          DATE          NULL,
    [NomeArquivo]          VARCHAR (150) NULL,
    [CPFTRATADO]           VARCHAR (50)  NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_LarMaisCPFSegurado_TEMP]
    ON [dbo].[LarMais_ODS_TEMP]([CPFTRATADO] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

