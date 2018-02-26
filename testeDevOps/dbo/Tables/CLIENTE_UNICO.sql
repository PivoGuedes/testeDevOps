CREATE TABLE [dbo].[CLIENTE_UNICO] (
    [ID_PESSOA]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [NM_PESSOA]               VARCHAR (200) NOT NULL,
    [NM_PESSOA_SOBRENOME]     VARCHAR (200) NULL,
    [NM_PESSOA_COMPLETO]      VARCHAR (200) NOT NULL,
    [AccountType]             VARCHAR (60)  NOT NULL,
    [RecordType]              VARCHAR (60)  NOT NULL,
    [Title]                   VARCHAR (20)  NULL,
    [NU_CPF]                  VARCHAR (12)  NOT NULL,
    [DT_NASCIMENTO]           DATE          NOT NULL,
    [NU_TELEFONE_CELULAR]     BIGINT        NULL,
    [NU_TELEFONE_RESIDENCIAL] BIGINT        NULL,
    [NU_TELEFONE_COMERCIAL]   BIGINT        NULL,
    [DS_ENDERECO]             VARCHAR (150) NULL,
    [NM_CIDADE]               VARCHAR (150) NULL,
    [NM_ESTADO]               VARCHAR (60)  NULL,
    [NM_PAIS]                 VARCHAR (60)  NULL,
    [NU_CEP]                  VARCHAR (12)  NULL,
    [DS_EMAIL]                VARCHAR (60)  NULL,
    [NU_RG]                   VARCHAR (30)  NULL,
    [ST_SEXO]                 CHAR (1)      NOT NULL,
    [DT_CARGA]                DATETIME      NULL,
    [DES_ORIGEM]              VARCHAR (20)  NULL,
    [PropostaClienteID]       BIGINT        NULL,
    CONSTRAINT [PK_CLIENTE_UNICO] PRIMARY KEY CLUSTERED ([ID_PESSOA] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NU_CPF]
    ON [dbo].[CLIENTE_UNICO]([NU_CPF] ASC) WITH (FILLFACTOR = 90);

