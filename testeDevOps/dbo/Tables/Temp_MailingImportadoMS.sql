CREATE TABLE [dbo].[Temp_MailingImportadoMS] (
    [NOME_CAMPANHA]             VARCHAR (50)  NULL,
    [CODIGO_CAMPANHA]           VARCHAR (50)  NULL,
    [CODIGO_MAILING]            VARCHAR (50)  NULL,
    [NOME_CLIENTE]              VARCHAR (200) NULL,
    [CPF_CNPJ_CLIENTE]          VARCHAR (50)  NULL,
    [DDD1]                      VARCHAR (50)  NULL,
    [FONE1]                     VARCHAR (50)  NULL,
    [DDD2]                      VARCHAR (50)  NULL,
    [FONE2]                     VARCHAR (50)  NULL,
    [DDD3]                      VARCHAR (50)  NULL,
    [FONE3]                     VARCHAR (50)  NULL,
    [DDD4]                      VARCHAR (50)  NULL,
    [FONE4]                     VARCHAR (50)  NULL,
    [TIPO_CLIENTE]              VARCHAR (50)  NULL,
    [ORIGEM_CLIENTE]            VARCHAR (50)  NULL,
    [DATA_CONTATO_CS]           VARCHAR (50)  NULL,
    [DATA_COTACAO_CS]           VARCHAR (50)  NULL,
    [MODELO_VEICULO]            VARCHAR (150) NULL,
    [PLACA_VEICULO]             VARCHAR (50)  NULL,
    [VALOR_PREMIO_BRUTO]        VARCHAR (50)  NULL,
    [MOTIVO_RECUSA]             VARCHAR (250) NULL,
    [TIPO_SEGURO]               VARCHAR (50)  NULL,
    [DATA_INICIO_VIGENCIA]      VARCHAR (50)  NULL,
    [AGENCIA_COTACAO_CS]        VARCHAR (50)  NULL,
    [NUMERO_COTACAO_CS]         VARCHAR (50)  NULL,
    [VALOR_FIPE]                VARCHAR (50)  NULL,
    [TIPO_PESSOA]               VARCHAR (50)  NULL,
    [SEXO]                      VARCHAR (50)  NULL,
    [BONUS_ANTERIOR]            VARCHAR (50)  NULL,
    [CEP]                       VARCHAR (50)  NULL,
    [ESTADO_CIVIL]              VARCHAR (50)  NULL,
    [E-MAIL]                    VARCHAR (200) NULL,
    [RELACAO_COND_SEGURADO]     VARCHAR (50)  NULL,
    [DATA_NASC]                 VARCHAR (50)  NULL,
    [ANO_MODELO]                VARCHAR (50)  NULL,
    [COD_FIPE]                  VARCHAR (50)  NULL,
    [USO_VEICULO]               VARCHAR (50)  NULL,
    [BLINDADO]                  VARCHAR (50)  NULL,
    [CHASSI]                    VARCHAR (50)  NULL,
    [FORMA_CONTRATAÇÃO]         VARCHAR (50)  NULL,
    [FRANQUIA]                  VARCHAR (50)  NULL,
    [DANOS_MATERIAIS]           VARCHAR (50)  NULL,
    [DANOS_MORAIS]              VARCHAR (50)  NULL,
    [DANOS_CORPORAIS]           VARCHAR (50)  NULL,
    [ASSIS_24_HRS]              VARCHAR (50)  NULL,
    [CARRO_RESERVA]             VARCHAR (50)  NULL,
    [GARANTIA_CARRO_RESERVA]    VARCHAR (50)  NULL,
    [APP_PASSAGEIRO]            VARCHAR (50)  NULL,
    [DESP_MEDICO_HOSP]          VARCHAR (50)  NULL,
    [LANT_FAROIS_RETROVIS]      VARCHAR (50)  NULL,
    [VIDROS]                    VARCHAR (50)  NULL,
    [DESP_EXTRAORDINÁRIAS]     VARCHAR (50)  NULL,
    [ESTENDER_COB_PARA_MENORES] VARCHAR (50)  NULL,
    [NomeArquivo]               VARCHAR (300) NULL,
    [DataRefMailing]            DATE          NULL
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_MailingImportados_CPF]
    ON [dbo].[Temp_MailingImportadoMS]([CPF_CNPJ_CLIENTE] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_MailingImportados_CODIGOM]
    ON [dbo].[Temp_MailingImportadoMS]([CODIGO_MAILING] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_MailingImportados_DataRefMailing]
    ON [dbo].[Temp_MailingImportadoMS]([DataRefMailing] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

