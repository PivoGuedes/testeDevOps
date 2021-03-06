﻿CREATE TABLE [Dados].[funcionariohist_bkp_fabio] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]               INT             NOT NULL,
    [IDFuncao]                    SMALLINT        NULL,
    [IDUnidade]                   SMALLINT        NULL,
    [IDSituacaoFuncionario]       SMALLINT        NULL,
    [DataSituacao]                DATE            NULL,
    [CodigoOcupacao]              VARCHAR (7)     NULL,
    [Nome]                        VARCHAR (100)   NULL,
    [DataAdmissao]                DATE            NULL,
    [DataAtualizacaoCargo]        DATE            NULL,
    [DataAtualizacaoVolta]        DATE            NULL,
    [Salario]                     DECIMAL (20, 2) NULL,
    [Cargo]                       VARCHAR (100)   NULL,
    [LotacaoUF]                   VARCHAR (4)     NULL,
    [LotacaoCidade]               VARCHAR (60)    NULL,
    [LotacaoDataInicio]           DATE            NULL,
    [LotacaoSigla]                VARCHAR (30)    NULL,
    [LotacaoEmail]                VARCHAR (60)    NULL,
    [ParticipanteEmail]           VARCHAR (60)    NULL,
    [ParticipanteLotacaoDDD]      VARCHAR (5)     NULL,
    [ParticipanteLotacaoTelefone] VARCHAR (10)    NULL,
    [FuncaoDataInicio]            DATE            NULL,
    [NomeArquivo]                 VARCHAR (70)    NOT NULL,
    [DataArquivo]                 DATE            NOT NULL,
    [LastValue]                   BIT             NOT NULL,
    [CargoCaixaSeguros]           VARCHAR (70)    NULL,
    [Lotacao]                     VARCHAR (70)    NULL,
    [IDCargoPropay]               SMALLINT        NULL,
    [IDIndicadorArea]             TINYINT         NULL,
    [IDCentroCusto]               SMALLINT        NULL,
    [VIP]                         BIT             NULL
);

