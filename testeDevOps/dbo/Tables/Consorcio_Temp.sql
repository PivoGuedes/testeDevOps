CREATE TABLE [dbo].[Consorcio_Temp] (
    [ID]                  BIGINT          NULL,
    [Periodo]             DATE            NULL,
    [Venda]               DATE            NULL,
    [DataQuitacaoParcela] DATE            NULL,
    [Contrato]            VARCHAR (50)    NULL,
    [NumeroParcela]       INT             NULL,
    [LancamentoManual]    INT             NOT NULL,
    [PercentualComissao]  NUMERIC (18, 2) NULL,
    [ValorBase]           NUMERIC (18, 6) NULL,
    [ValorComissaoPAR]    NUMERIC (18, 2) NULL,
    [ValorCorretagem]     NUMERIC (18, 6) NULL,
    [NomeArquivo]         VARCHAR (200)   NULL,
    [IDProdutor]          INT             NOT NULL,
    [CodigoProdutor]      INT             NOT NULL,
    [IDProduto]           INT             NOT NULL,
    [CodigoProduto]       INT             NOT NULL,
    [IDEmpresa]           INT             NOT NULL,
    [IDOperacao]          INT             NOT NULL,
    [NumeroRecibo]        VARCHAR (50)    NULL,
    [DataArquivo]         DATE            NULL
);


GO
CREATE CLUSTERED INDEX [idxTemp]
    ON [dbo].[Consorcio_Temp]([NumeroRecibo] ASC) WITH (FILLFACTOR = 90);

