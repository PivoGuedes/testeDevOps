﻿CREATE TABLE [Marketing].[PagamentosIndenizacaoIntegralCaixa] (
    [Codigo]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdSinistro]         BIGINT          NOT NULL,
    [IDContrato]         BIGINT          NOT NULL,
    [CodigoCliente]      BIGINT          NULL,
    [ValorPagamento]     DECIMAL (18, 2) NULL,
    [DescricaoEfeito]    VARCHAR (200)   NULL,
    [SeguroTerceiro]     VARCHAR (2)     NULL,
    [NomeContato]        VARCHAR (200)   NULL,
    [CPFCNPJContato]     VARCHAR (20)    NULL,
    [TelefoneComercial]  VARCHAR (20)    NULL,
    [TelefoneCelular]    VARCHAR (20)    NULL,
    [Email]              VARCHAR (300)   NULL,
    [MarcaTipo]          VARCHAR (200)   NULL,
    [Placa]              VARCHAR (20)    NULL,
    [CategoriaPagamento] VARCHAR (150)   NULL,
    [DataPagamento]      DATE            NULL,
    [DataAprovacao]      DATE            NULL,
    [DataArquivo]        DATE            NULL,
    [DataInclusao]       DATE            NULL,
    CONSTRAINT [PK_PagamentosIndenizacaoIntegralCaixa] PRIMARY KEY CLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_PagamentoAuto] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_Sinistro_PagamentoAuto] FOREIGN KEY ([IdSinistro]) REFERENCES [Dados].[Sinistro] ([ID])
);

