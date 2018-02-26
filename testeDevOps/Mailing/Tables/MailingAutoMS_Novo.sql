﻿CREATE TABLE [Mailing].[MailingAutoMS_Novo] (
    [ID]                        BIGINT          IDENTITY (1, 1) NOT NULL,
    [NOME_CAMPANHA]             VARCHAR (24)    NOT NULL,
    [CODIGO_CAMPANHA]           VARCHAR (8)     NOT NULL,
    [CODIGO_MAILING]            VARCHAR (17)    NOT NULL,
    [NOME_CLIENTE]              VARCHAR (150)   NULL,
    [CPF]                       VARCHAR (18)    NOT NULL,
    [DDDTelefone1]              VARCHAR (2)     NULL,
    [Telefone1]                 VARCHAR (20)    NULL,
    [DDDTelefone2]              VARCHAR (2)     NULL,
    [Telefone2]                 VARCHAR (20)    NULL,
    [DDDTelefone3]              VARCHAR (2)     NULL,
    [Telefone3]                 VARCHAR (20)    NULL,
    [DDDTelefone4]              VARCHAR (2)     NULL,
    [Telefone4]                 VARCHAR (20)    NULL,
    [COD_TIPO_CLIENTE]          VARCHAR (10)    NULL,
    [TIPO_CLIENTE]              VARCHAR (60)    NULL,
    [ORIGEM_CLIENTE]            VARCHAR (29)    NOT NULL,
    [DATA_CONTATO_CS]           DATETIME        NULL,
    [DATA_COTACAO_CS]           DATETIME        NULL,
    [MODELO_VEICULO]            VARCHAR (100)   NULL,
    [PLACA_VEICULO]             VARCHAR (10)    NULL,
    [VALOR_PREMIO_BRUTO]        DECIMAL (19, 2) NULL,
    [MOTIVO_RECUSA]             VARCHAR (100)   NULL,
    [TIPO_SEGURO]               VARCHAR (35)    NULL,
    [DATA_INICIO_VIGENCIA]      DATE            NULL,
    [AGENCIA_COTACAO_CS]        SMALLINT        NULL,
    [NUMERO_COTACAO_CS]         INT             NULL,
    [ValorFIPE]                 DECIMAL (19, 2) NULL,
    [TipoPessoa]                CHAR (1)        NULL,
    [Sexo]                      VARCHAR (20)    NULL,
    [BONUS]                     INT             NULL,
    [CEP]                       VARCHAR (10)    NULL,
    [ESTADO_CIVIL]              VARCHAR (30)    NULL,
    [Email]                     VARCHAR (80)    NULL,
    [TIPO_COND_SEGURADO]        VARCHAR (60)    NULL,
    [DATA_NASC]                 DATE            NULL,
    [ANO_MODELO]                SMALLINT        NULL,
    [COD_FIPE]                  INT             NULL,
    [USO_VEICULO]               VARCHAR (60)    NULL,
    [BLINDADO]                  VARCHAR (50)    NULL,
    [CHASSI]                    VARCHAR (18)    NULL,
    [FORMA_CONTRATACAO]         VARCHAR (60)    NULL,
    [TIPO_FRANQUIA]             VARCHAR (15)    NULL,
    [DANOS_MATERIAIS]           DECIMAL (19, 2) NULL,
    [DANOS_MORAIS]              DECIMAL (19, 2) NULL,
    [DANOS_CORPORAIS]           DECIMAL (19, 2) NULL,
    [ASSIS_24_HRS]              TINYINT         NULL,
    [CARRO_RESERVA]             TINYINT         NULL,
    [GARANTIA_CARRO_RESERVA]    VARCHAR (60)    NULL,
    [APP_PASSAGEIRO]            DECIMAL (19, 2) NULL,
    [DESP_MEDICO_HOSP]          DECIMAL (19, 2) NULL,
    [LANT_FAROIS_RETROVIS]      VARCHAR (50)    NULL,
    [VIDROS]                    VARCHAR (50)    NULL,
    [DESP_EXTRAORDINARIAS]      VARCHAR (50)    NULL,
    [ESTENDER_COB_PARA_MENORES] VARCHAR (1)     NULL,
    [DataRefMailing]            DATE            NOT NULL,
    [DataEnvioMailing]          DATE            NULL,
    [CPF_NOFORMAT]              VARCHAR (18)    NULL,
    [RegraAplicada]             VARCHAR (100)   NULL,
    [MailingAtendente]          BIT             NULL
);

