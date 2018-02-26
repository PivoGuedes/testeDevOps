﻿CREATE TABLE [dbo].[PRESTAMISTA_CANCELAMENTO_TEMP] (
    [Codigo]               BIGINT          NOT NULL,
    [ControleVersao]       DECIMAL (16, 8) NULL,
    [NomeArquivo]          VARCHAR (100)   NOT NULL,
    [DataArquivo]          DATE            NULL,
    [NumeroProduto]        VARCHAR (10)    NULL,
    [TipoCredito]          CHAR (2)        NULL,
    [NumeroProposta]       VARCHAR (22)    NULL,
    [NumeroContrato]       VARCHAR (20)    NULL,
    [CodigoSubestipulante] VARCHAR (10)    NULL,
    [CodigoESCNEG]         VARCHAR (10)    NULL,
    [CodigoPV]             VARCHAR (4)     NULL,
    [NomeSegurado]         VARCHAR (60)    NULL,
    [CPFCNPJ]              CHAR (14)       NULL,
    [DataContrato]         DATE            NULL,
    [DataInclusao]         DATE            NULL,
    [DataAmortizacao]      DATE            NULL,
    [DataEncerramento]     DATE            NULL,
    [MotivoEncerramento]   VARCHAR (5)     NULL,
    [NumeroOrdemExclusao]  VARCHAR (10)    NULL,
    [NumeroRE]             VARCHAR (5)     NULL,
    [IOFCancelado]         NUMERIC (16, 2) NULL,
    [PremioCancelado]      NUMERIC (16, 2) NULL,
    [IOFInad]              NUMERIC (16, 2) NULL,
    [PremioInad]           NUMERIC (16, 2) NULL,
    [CodigoSeguradora]     SMALLINT        DEFAULT ((1)) NOT NULL
);

