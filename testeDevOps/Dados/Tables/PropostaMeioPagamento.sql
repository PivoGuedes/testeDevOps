CREATE TABLE [Dados].[PropostaMeioPagamento] (
    [ID]             BIGINT    NOT NULL,
    [IDProposta]     BIGINT    NULL,
    [DiaVencimento]  INT       NULL,
    [DiaCorte]       INT       NULL,
    [FormaPagamento] INT       NULL,
    [Banco]          CHAR (10) NULL,
    [Agencia]        CHAR (10) NULL,
    [Conta]          CHAR (10) NULL,
    [OperacaoConta]  CHAR (10) NULL,
    CONSTRAINT [PK_PROPOSTAMEIOPAGAMENTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

