﻿CREATE TABLE [Dados].[PropostaPrevidencia] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]                  BIGINT          NULL,
    [TipoAposentadoria]           TINYINT         NULL,
    [IndicadorSimulacao]          CHAR (1)        NULL,
    [PrazoPercepcao]              TINYINT         NULL,
    [PrazoDiferimento]            TINYINT         NULL,
    [TipoContribuicao]            CHAR (1)        NULL,
    [ValorContribuicao]           DECIMAL (19, 2) NULL,
    [ValorReservaInicial]         DECIMAL (19, 2) NULL,
    [NumeroPropostaEmpresarial]   VARCHAR (20)    NULL,
    [DiaVencimento]               TINYINT         NULL,
    [PercentualDesconto]          DECIMAL (5, 2)  NULL,
    [DataCreditoFederalPrevSICOB] DATE            NULL,
    [CodigoFundo]                 TINYINT         NULL,
    [PercentualReversao]          DECIMAL (5, 2)  NULL,
    [IndicadorReservaInicial]     CHAR (1)        NULL,
    [OrigemProposta]              CHAR (2)        NULL,
    [DataArquivo]                 DATE            NULL,
    [TipoDado]                    VARCHAR (30)    NULL,
    CONSTRAINT [PK_NCL)PropostaPrevidencia_ID] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaPrevidencia_Proposta_ID] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_CL_PropostaPrevidencia_IDPropostaDataArquivo] UNIQUE CLUSTERED ([IDProposta] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);
