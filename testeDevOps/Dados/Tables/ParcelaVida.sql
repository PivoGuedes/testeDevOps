CREATE TABLE [Dados].[ParcelaVida] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]              BIGINT          NULL,
    [IDCertificado]           INT             NULL,
    [IDSituacaoCobranca]      TINYINT         NULL,
    [SituacaoSeguro]          SMALLINT        NULL,
    [SituacaoLancamentoConta] SMALLINT        NULL,
    [NumeroParcela]           INT             NULL,
    [OpcaoPagamento]          VARCHAR (20)    NULL,
    [AgenciaCobranca]         VARCHAR (10)    NULL,
    [Operacao]                VARCHAR (20)    NULL,
    [Conta]                   VARCHAR (20)    NULL,
    [DigitoConta]             VARCHAR (5)     NULL,
    [DataVencimento]          DATE            NULL,
    [DataCobranca]            DATE            NULL,
    [DataPagamento]           DATE            NULL,
    [ValorPremio]             DECIMAL (15, 2) NULL,
    [CodigoRetornoFebraban]   VARCHAR (20)    NULL,
    [NomeArquivo]             NVARCHAR (120)  NOT NULL,
    [DataArquivo]             DATE            NOT NULL,
    CONSTRAINT [PK_PARCELAVIDA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PARCELAVIDA_CERTIFICADO] FOREIGN KEY ([IDCertificado]) REFERENCES [Dados].[Certificado] ([ID]),
    CONSTRAINT [FK_PARCELAVIDA_CONTRATO] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_PARCELAVIDA_SITUACAOCOBRANCA] FOREIGN KEY ([IDSituacaoCobranca]) REFERENCES [Dados].[SituacaoCobranca] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_ParcelaVida_ContratoCertificadoSituacaoCobrancaSeguroLancamentoConta]
    ON [Dados].[ParcelaVida]([IDContrato] ASC, [IDCertificado] ASC, [IDSituacaoCobranca] ASC, [SituacaoSeguro] ASC, [SituacaoLancamentoConta] ASC, [NumeroParcela] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

