CREATE TABLE [Indicadores].[Unidades_tmp] (
    [Codigo]        SMALLINT      NOT NULL,
    [Nome]          VARCHAR (100) NOT NULL,
    [Data]          DATE          NOT NULL,
    [ASVEN]         BIT           NOT NULL,
    [CLassePV]      CHAR (1)      NULL,
    [UFMunicipio]   CHAR (2)      NULL,
    [NomeMunicipio] VARCHAR (35)  NULL,
    [CodigoSR]      SMALLINT      NOT NULL,
    [NomeSR]        VARCHAR (100) NOT NULL,
    [CodigoSUAT]    SMALLINT      NOT NULL,
    [NomeSUAT]      VARCHAR (6)   NOT NULL,
    [Porte]         TINYINT       NULL,
    [TipoPV]        VARCHAR (200) NULL
);

