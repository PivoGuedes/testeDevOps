CREATE TABLE [Dados].[Parcela] (
    [ID]                    BIGINT          NOT NULL,
    [IDEndosso]             BIGINT          NULL,
    [NumeroParcela]         INT             NULL,
    [NumeroTitulo]          VARCHAR (13)    NULL,
    [ValorPremioLiquido]    DECIMAL (19, 2) NULL,
    [DataVencimento]        DATE            NULL,
    [QuantidadeOcorrencias] SMALLINT        NULL,
    [IDSituacaoParcela]     TINYINT         NULL,
    [DataArquivo]           DATE            NULL,
    [DataEmissao]           DATE            NOT NULL,
    [DataSistema]           DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [IDParcelaOperacao]     INT             NULL,
    [TipoDado]              VARCHAR (30)    NULL,
    [NomeArquivo]           VARCHAR (100)   NULL,
    CONSTRAINT [PK_PARCELA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PARCELA_FK_PARCEL_ENDOSSO] FOREIGN KEY ([IDEndosso]) REFERENCES [Dados].[Endosso] ([ID]),
    CONSTRAINT [FK_PARCELA_FK_PARCEL_SITUACAO] FOREIGN KEY ([IDSituacaoParcela]) REFERENCES [Dados].[SituacaoParcela] ([ID]),
    CONSTRAINT [fk_Parcela_IDParcelaOperacao] FOREIGN KEY ([IDParcelaOperacao]) REFERENCES [Dados].[ParcelaOperacao] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Parcela_Endosso_Numero_Situacao]
    ON [Dados].[Parcela]([IDEndosso] ASC, [NumeroParcela] ASC, [IDSituacaoParcela] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

