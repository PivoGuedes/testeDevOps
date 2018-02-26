CREATE TABLE [Dados].[MeioPagamento] (
    [IDProposta]       BIGINT       NOT NULL,
    [DataArquivo]      DATE         NOT NULL,
    [IDFormaPagamento] TINYINT      NOT NULL,
    [Banco]            SMALLINT     NULL,
    [Agencia]          VARCHAR (10) NULL,
    [Operacao]         VARCHAR (10) NULL,
    [ContaCorrente]    VARCHAR (20) NULL,
    [DiaVencimento]    TINYINT      NULL,
    [LastValue]        BIT          CONSTRAINT [DF_MeioPagamento_LastValue] DEFAULT ((0)) NOT NULL,
    [ID]               BIGINT       IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_MEIOPAGAMENTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_MEIOPAGA_FK_MEIOPA_FORMAPAG] FOREIGN KEY ([IDFormaPagamento]) REFERENCES [Dados].[FormaPagamento] ([ID]),
    CONSTRAINT [FK_MEIOPAGA_FK_MEIOPA_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_MeioPagamento_LastValue]
    ON [Dados].[MeioPagamento]([IDProposta] ASC, [LastValue] ASC)
    INCLUDE([DataArquivo]) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_MeioPagamento]
    ON [Dados].[MeioPagamento]([IDProposta] ASC, [IDFormaPagamento] ASC, [Banco] ASC, [Agencia] ASC, [Operacao] ASC, [ContaCorrente] ASC, [DiaVencimento] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_Idx_MeioPagamento_Proposta_Arquivo]
    ON [Dados].[MeioPagamento]([IDProposta] ASC, [DataArquivo] DESC)
    INCLUDE([IDFormaPagamento], [Banco], [Agencia], [ContaCorrente], [DiaVencimento]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

