CREATE TABLE [Dados].[PropostaMergeDados] (
    [ID]                 BIGINT   NOT NULL,
    [DataInicioVigencia] DATE     NULL,
    [DataFimVigencia]    DATE     NULL,
    [DataSituacao]       DATE     NULL,
    [IDSituacaoProposta] TINYINT  NULL,
    [IDTipoMotivo]       SMALLINT NULL,
    [DataArquivo]        DATE     NOT NULL
);

