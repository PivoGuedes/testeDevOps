CREATE TABLE [dbo].[Temp_ValidacaoMailing_2] (
    [ID]                       INT            NOT NULL,
    [CPF]                      VARCHAR (18)   NOT NULL,
    [CPF_NOFORMAT]             VARCHAR (8000) NULL,
    [DataNascimento]           DATE           NULL,
    [Nome]                     VARCHAR (150)  NULL,
    [IDTelefoneEfetivo]        INT            NULL,
    [IDAgenciaIndicacao]       SMALLINT       NULL,
    [DateTime_Contato_Efetivo] DATETIME       NULL,
    [IDTipoCliente]            TINYINT        NULL,
    [CotacaoRealizada]         CHAR (2)       NULL,
    [N]                        BIGINT         NULL,
    [Arquivo]                  VARCHAR (60)   NULL,
    [IDStatus_Final]           TINYINT        NULL,
    [IDStatus_Ligacao]         TINYINT        NULL
);

