﻿CREATE TABLE [dbo].[VincendosMensal_TEMP] (
    [Codigo]              INT           NOT NULL,
    [Agencia]             VARCHAR (4)   NOT NULL,
    [NomeAgencia]         VARCHAR (60)  NOT NULL,
    [Filial]              VARCHAR (10)  NOT NULL,
    [NomeFilial]          VARCHAR (60)  NOT NULL,
    [Escrit]              VARCHAR (10)  NOT NULL,
    [NomeEscritorio]      VARCHAR (60)  NOT NULL,
    [Ter_Vig]             DATE          NOT NULL,
    [Apolice]             VARCHAR (40)  NOT NULL,
    [CGCCPF]              VARCHAR (20)  NOT NULL,
    [Segurado]            VARCHAR (60)  NOT NULL,
    [Endereco]            VARCHAR (100) NOT NULL,
    [Bairro]              VARCHAR (100) NOT NULL,
    [Cidade]              VARCHAR (100) NOT NULL,
    [UF]                  VARCHAR (4)   NOT NULL,
    [CEP]                 VARCHAR (10)  NOT NULL,
    [DDD]                 VARCHAR (3)   NOT NULL,
    [Fone]                VARCHAR (15)  NOT NULL,
    [Email]               VARCHAR (100) NOT NULL,
    [Veiculo]             VARCHAR (100) NOT NULL,
    [AnoMod]              VARCHAR (10)  NOT NULL,
    [Placa]               VARCHAR (10)  NOT NULL,
    [Filler]              VARCHAR (40)  NOT NULL,
    [Chassi]              VARCHAR (30)  NOT NULL,
    [FormaCobr]           VARCHAR (30)  NOT NULL,
    [ContaDebito]         VARCHAR (50)  NOT NULL,
    [Produto]             VARCHAR (60)  NOT NULL,
    [CL_BONUS_A_CONCEDER] VARCHAR (30)  NOT NULL,
    [APP]                 VARCHAR (30)  NOT NULL,
    [RCDM]                VARCHAR (30)  NOT NULL,
    [RCDP]                VARCHAR (30)  NOT NULL,
    [VL_Mercado]          VARCHAR (30)  NOT NULL,
    [Economiario]         VARCHAR (30)  NOT NULL,
    [Matricula]           VARCHAR (30)  NOT NULL,
    [Fille2]              VARCHAR (10)  NOT NULL,
    [DDD_Unidade]         VARCHAR (3)   NOT NULL,
    [Fone_Unidade]        VARCHAR (30)  NOT NULL,
    [Tem_Sinistro]        VARCHAR (5)   NOT NULL,
    [TP_Franquia]         VARCHAR (30)  NOT NULL,
    [Tem_Endosso]         VARCHAR (5)   NOT NULL,
    [Tem_Parc_Pend]       VARCHAR (5)   NULL,
    [DDD_Celular]         VARCHAR (5)   NOT NULL,
    [Celular]             VARCHAR (15)  NOT NULL,
    [DDD_Comercial]       VARCHAR (5)   NOT NULL,
    [TEL_Comercial]       VARCHAR (15)  NOT NULL,
    [DataHoraSistema]     DATETIME2 (7) NOT NULL,
    [NomeArquivo]         VARCHAR (300) NOT NULL
);

