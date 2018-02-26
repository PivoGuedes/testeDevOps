﻿CREATE TABLE [Marketing].[VincendosAuto] (
    [ID]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]            BIGINT          NOT NULL,
    [CodigoCliente]         BIGINT          NOT NULL,
    [IDAgencia]             SMALLINT        NOT NULL,
    [Email]                 VARCHAR (200)   NULL,
    [Veiculo]               VARCHAR (200)   NULL,
    [AnoModelo]             INT             NULL,
    [Placa]                 VARCHAR (8)     NULL,
    [Chassi]                VARCHAR (50)    NULL,
    [FormaCobranca]         VARCHAR (100)   NULL,
    [AgenciaDebito]         INT             NULL,
    [OperacaoConta]         INT             NULL,
    [ContaDebito]           INT             NULL,
    [DvConta]               VARCHAR (1)     NULL,
    [Produto]               VARCHAR (100)   NULL,
    [ClasseBonus]           INT             NULL,
    [App]                   DECIMAL (18, 2) NULL,
    [Rcdm]                  DECIMAL (18, 2) NULL,
    [Rcdp]                  DECIMAL (18, 2) NULL,
    [IsValorMercado]        VARCHAR (1)     NULL,
    [Economiario]           VARCHAR (200)   NULL,
    [Matricula]             VARCHAR (10)    NULL,
    [DddUnidade]            INT             NULL,
    [FoneUnidade]           VARCHAR (20)    NULL,
    [TemSinistro]           VARCHAR (1)     NULL,
    [TipoFranquia]          VARCHAR (50)    NULL,
    [PossuiEndosso]         VARCHAR (1)     NULL,
    [PossuiParcelaPendente] VARCHAR (1)     NULL,
    [DddCelular]            VARCHAR (3)     NULL,
    [Celular]               VARCHAR (20)    NULL,
    [DddComercial]          VARCHAR (3)     NULL,
    [TelefoneComercial]     VARCHAR (20)    NULL,
    [NomeArquivo]           VARCHAR (200)   NULL,
    [DataArquivo]           DATE            NULL,
    CONSTRAINT [PK_VincendoMensal] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agencia_VincendosAuto] FOREIGN KEY ([IDAgencia]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Contrato_VincendosAuto] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID])
);
