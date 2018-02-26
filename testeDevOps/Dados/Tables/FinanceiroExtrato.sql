CREATE TABLE [Dados].[FinanceiroExtrato] (
    [ID]                     BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]             BIGINT          NOT NULL,
    [IDProduto]              INT             NOT NULL,
    [IDISMip]                TINYINT         CONSTRAINT [DF_FinanceiroExtrato_IDISMip] DEFAULT ((0)) NOT NULL,
    [PremioMip]              NUMERIC (16, 2) NULL,
    [IOFMip]                 NUMERIC (16, 2) NULL,
    [PremioMipAtrasado]      NUMERIC (16, 2) NULL,
    [IOFMipAtrasado]         NUMERIC (16, 2) NULL,
    [IDISInad]               TINYINT         CONSTRAINT [DF_FinanceiroExtrato_IDISInad] DEFAULT ((0)) NOT NULL,
    [PremioInad]             NUMERIC (16, 2) NULL,
    [IOFInad]                NUMERIC (16, 2) NULL,
    [PremioInadAtrasado]     NUMERIC (16, 2) NULL,
    [IOFInadAtrasado]        NUMERIC (16, 2) NULL,
    [PremioCancelado]        NUMERIC (16, 2) NULL,
    [IOFCancelado]           NUMERIC (16, 2) NULL,
    [IDISDfi]                TINYINT         CONSTRAINT [DF_FinanceiroExtrato_IDISDfi] DEFAULT ((0)) NOT NULL,
    [PremioDfi]              NUMERIC (16, 2) NULL,
    [IOFDfi]                 NUMERIC (16, 2) NULL,
    [IDISDfiAtrasado]        TINYINT         CONSTRAINT [DF_FinanceiroExtrato_IDISMip1] DEFAULT ((0)) NOT NULL,
    [PremioDfiAtrasado]      NUMERIC (16, 2) NULL,
    [IOFDfiAtrasado]         NUMERIC (16, 2) NULL,
    [PercentualResseguro]    NUMERIC (5, 2)  NULL,
    [ValorPrRessMipMes]      NUMERIC (16, 2) NULL,
    [ValorPrRessMipAtrasado] NUMERIC (16, 2) NULL,
    [ValorPrRessDfiMes]      NUMERIC (16, 2) NULL,
    [ValorPrRessDfiAtrasado] NUMERIC (16, 2) NULL,
    [DataAmortizacao]        DATE            NULL,
    [DataArquivo]            DATE            NOT NULL,
    [Arquivo]                VARCHAR (100)   NULL,
    [DataInclusao]           DATE            NULL,
    [NumeroRI]               VARCHAR (5)     NULL,
    [NumeroOrdemInclusao]    VARCHAR (10)    NULL,
    [DataExclusao]           DATE            NULL,
    [NumeroRE]               VARCHAR (5)     NULL,
    [NumeroOrdemExclusao]    VARCHAR (10)    NULL,
    CONSTRAINT [PK_FINANCEIROEXTRATO] PRIMARY KEY NONCLUSTERED ([ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_FinanceiroExtrato_IdentificacaoIS] FOREIGN KEY ([IDISDfi]) REFERENCES [Dados].[IdentificacaoIS] ([ID]),
    CONSTRAINT [FK_FinanceiroExtrato_IdentificacaoIS1] FOREIGN KEY ([IDISMip]) REFERENCES [Dados].[IdentificacaoIS] ([ID]),
    CONSTRAINT [FK_FinanceiroExtrato_IdentificacaoIS2] FOREIGN KEY ([IDISInad]) REFERENCES [Dados].[IdentificacaoIS] ([ID]),
    CONSTRAINT [FK_FinanceiroExtrato_IdentificacaoIS3] FOREIGN KEY ([IDISDfiAtrasado]) REFERENCES [Dados].[IdentificacaoIS] ([ID]),
    CONSTRAINT [FK_FinanceiroExtrato_Produto] FOREIGN KEY ([IDProduto]) REFERENCES [Dados].[Produto] ([ID]),
    CONSTRAINT [FK_PRESTAMISTA_REFERENCE_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_FINANCEIROEXTRATO] UNIQUE CLUSTERED ([IDProposta] DESC, [DataArquivo] DESC, [IDProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_FinanceiroExtrato_DataArquivo]
    ON [Dados].[FinanceiroExtrato]([DataArquivo] ASC)
    INCLUDE([IDProposta], [PremioMip], [IOFMip], [PremioDfi], [IOFDfi], [PremioMipAtrasado], [PremioCancelado]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_IDProduto_FinanceiroExtrato]
    ON [Dados].[FinanceiroExtrato]([IDProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

