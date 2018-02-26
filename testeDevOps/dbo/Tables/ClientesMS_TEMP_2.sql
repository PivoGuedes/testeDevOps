CREATE TABLE [dbo].[ClientesMS_TEMP_2] (
    [ID]                       INT           NOT NULL,
    [CPF]                      VARCHAR (18)  NOT NULL,
    [CPF_NOFORMAT]             VARCHAR (18)  NULL,
    [DataNascimento]           DATE          NULL,
    [Nome]                     VARCHAR (150) NULL,
    [IDTelefoneEfetivo]        INT           NULL,
    [IDAgenciaIndicacao]       SMALLINT      NULL,
    [DateTime_Contato_Efetivo] DATETIME      NULL,
    [IDTipoCliente]            TINYINT       NULL,
    [CotacaoRealizada]         CHAR (2)      NULL,
    [ClassificaDataContato]    BIGINT        NULL,
    [Arquivo]                  VARCHAR (60)  NULL,
    [IDStatusFinal]            INT           NULL,
    [IDStatusLigacao]          INT           NULL,
    [RegraAplicada]            VARCHAR (100) NULL
);

