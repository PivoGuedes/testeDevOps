﻿CREATE TABLE [Dados].[PropostaBack] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]                  BIGINT          NULL,
    [IDSeguradora]                SMALLINT        NOT NULL,
    [NumeroProposta]              VARCHAR (20)    NOT NULL,
    [NumeroPropostaEMISSAO]       VARCHAR (20)    NULL,
    [IDProduto]                   INT             NULL,
    [IDProdutoAnterior]           INT             NULL,
    [IDProdutoSIGPF]              TINYINT         NULL,
    [IDPeriodicidadePagamento]    TINYINT         NULL,
    [IDCanalVendaPAR]             INT             NULL,
    [DataProposta]                DATE            NULL,
    [DataInicioVigencia]          DATE            NULL,
    [DataFimVigencia]             DATE            NULL,
    [IDFuncionario]               INT             NULL,
    [Valor]                       DECIMAL (24, 4) NULL,
    [RendaIndividual]             VARCHAR (2)     NULL,
    [RendaFamiliar]               VARCHAR (2)     NULL,
    [IDAgenciaVenda]              SMALLINT        NULL,
    [DataSituacao]                DATE            NULL,
    [IDSituacaoProposta]          TINYINT         NULL,
    [IDSituacaoCobranca]          TINYINT         NULL,
    [IDTipoMotivo]                SMALLINT        NULL,
    [TipoDado]                    VARCHAR (80)    NOT NULL,
    [DataArquivo]                 DATE            NOT NULL,
    [ValorPremioBrutoEmissao]     NUMERIC (16, 2) NULL,
    [ValorPremioLiquidoEmissao]   NUMERIC (16, 2) NULL,
    [ValorPremioBrutoCalculado]   NUMERIC (16, 2) NULL,
    [ValorPremioLiquidoCalculado] NUMERIC (16, 2) NULL,
    [ValorPagoAcumulado]          NUMERIC (16, 2) NULL,
    [ValorPremioTotal]            NUMERIC (16, 2) NULL,
    [RenovacaoAutomatica]         VARCHAR (1)     NULL,
    [PercentualDesconto]          NUMERIC (5, 2)  NULL,
    [EmpresaConvenente]           VARCHAR (40)    NULL,
    [MatriculaConvenente]         VARCHAR (8)     NULL,
    [OpcaoCobertura]              VARCHAR (1)     NULL,
    [CodigoPlano]                 VARCHAR (4)     NULL,
    [DataAutenticacaoSICOB]       DATE            NULL,
    [AgenciaPagamentoSICOB]       VARCHAR (4)     NULL,
    [TarifaCobrancaSICOB]         NUMERIC (15, 2) NULL,
    [DataCreditoSASSESICOB]       DATE            NULL,
    [ValorComissaoSICOB]          NUMERIC (15, 2) NULL,
    [PeriodicidadePagamento]      VARCHAR (2)     NULL,
    [OpcaoConjuge]                VARCHAR (1)     NULL,
    [OrigemProposta]              VARCHAR (2)     NULL,
    [DeclaracaoSaudeTitular]      VARCHAR (7)     NULL,
    [DeclaracaoSaudeConjuge]      VARCHAR (7)     NULL,
    [AposentadoriaInvalidez]      VARCHAR (1)     NULL,
    [CodigoSegmento]              VARCHAR (4)     NULL,
    [SubGrupo]                    INT             NULL,
    [DataEmissao]                 DATE            NULL,
    [DataVenda]                   DATE            NULL,
    [IDContratoAnterior]          BIGINT          NULL,
    [QuantidadeParcelas]          TINYINT         NULL,
    [IDSituacaoContratual]        SMALLINT        NULL,
    [DataSituacaoContratual]      DATE            NULL,
    [TotalDeVidas]                INT             NULL,
    [IDPropostaM]                 BIGINT          NULL,
    [IDCanalVenda1]               TINYINT         NULL,
    [IDCanalVenda]                TINYINT         NULL
);

