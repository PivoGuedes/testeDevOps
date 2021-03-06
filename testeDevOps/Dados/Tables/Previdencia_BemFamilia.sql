﻿CREATE TABLE [Dados].[Previdencia_BemFamilia] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]     BIGINT          NULL,
    [IDStatus]       INT             NULL,
    [IDSubstatus]    INT             NULL,
    [IDProduto]      INT             NULL,
    [Conjugado]      BIT             NULL,
    [DataEmissao]    DATE            NULL,
    [DataInicio]     DATE            NULL,
    [DataFim]        DATE            NULL,
    [DataAprovacao]  DATE            NULL,
    [IDAgencia]      SMALLINT        NULL,
    [IDIndicador]    INT             NULL,
    [IDBeneficio]    INT             NULL,
    [DataVencimento] DATE            NULL,
    [DataPagamento]  DATE            NULL,
    [ValorVenda]     DECIMAL (19, 2) NULL,
    [ValorInicial]   DECIMAL (19, 2) NULL,
    [DataArquivo]    DATE            NULL,
    [IDFilial]       INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PrevBemFamilia_Agencia] FOREIGN KEY ([IDAgencia]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_Beneficio] FOREIGN KEY ([IDBeneficio]) REFERENCES [Dados].[BeneficioPrevBemFamilia] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_Indicador] FOREIGN KEY ([IDIndicador]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_ProdutoKIPREV] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[ProdutoKIPREV] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_StatusBemFamilia] FOREIGN KEY ([IDStatus]) REFERENCES [Dados].[StatusPrevidenciaBemFamilia] ([ID]),
    CONSTRAINT [FK_PrevBemFamilia_SubStatusBemFamilia] FOREIGN KEY ([IDSubstatus]) REFERENCES [Dados].[SubStatusPrevidenciaBemFamilia] ([ID]),
    CONSTRAINT [FK_Previdencia_BemFamilia_Filial] FOREIGN KEY ([IDFilial]) REFERENCES [Dados].[FilialPrevBemFamilia] ([ID])
);

