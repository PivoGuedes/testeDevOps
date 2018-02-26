﻿CREATE TABLE [Transacao].[CreditoRural] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [IDTipoTransacao]     INT             NOT NULL,
    [IDTipoCliente]       INT             NOT NULL,
    [IDSituacao]          INT             NOT NULL,
    [IDUfEmpreendimento]  INT             NOT NULL,
    [IDMunicipioIBGE]     INT             NOT NULL,
    [IDUnidade]           SMALLINT        NOT NULL,
    [NumeroContrato]      VARCHAR (50)    NOT NULL,
    [RazaoSocial]         VARCHAR (300)   NOT NULL,
    [CPFCNPJ]             VARCHAR (20)    NOT NULL,
    [DataContratacao]     DATE            NOT NULL,
    [DataEncerramento]    DATE            NOT NULL,
    [Valorfinanciado]     DECIMAL (18, 2) NOT NULL,
    [NomeProduto]         VARCHAR (550)   NOT NULL,
    [Atividade]           VARCHAR (550)   NOT NULL,
    [Finalidade]          VARCHAR (550)   NOT NULL,
    [EmpregoProduto]      VARCHAR (550)   NOT NULL,
    [ValorLiberado]       DECIMAL (18, 2) NOT NULL,
    [ValorLiberar]        DECIMAL (18, 2) NOT NULL,
    [CronogramaLiberacao] VARCHAR (500)   NOT NULL,
    [ValorNegado]         DECIMAL (18, 2) NOT NULL,
    [DiasAtraso]          INT             NOT NULL,
    [ValorTotalAtraso]    DECIMAL (18, 2) NOT NULL,
    [OrigemRecurso]       VARCHAR (50)    NOT NULL,
    [NumeroProposta]      VARCHAR (20)    NOT NULL,
    [DataImportacao]      DATETIME        DEFAULT (getdate()) NOT NULL,
    [Ativo]               BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CreditoRural] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MunicipioIBGECredutoRural] FOREIGN KEY ([IDMunicipioIBGE]) REFERENCES [Transacao].[MunicipioIBGE] ([ID]),
    CONSTRAINT [FK_SituacaoCreditoRural] FOREIGN KEY ([IDSituacao]) REFERENCES [Transacao].[Situacao] ([ID]),
    CONSTRAINT [FK_TipoPessoa_CreditoRural] FOREIGN KEY ([IDTipoCliente]) REFERENCES [Transacao].[TipoPessoa] ([ID]),
    CONSTRAINT [FK_TipoTransacaoCreditoRural] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_UnidadeCreditoRural] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

