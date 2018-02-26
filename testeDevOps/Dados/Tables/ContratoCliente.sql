CREATE TABLE [Dados].[ContratoCliente] (
    [IDContrato]    BIGINT        NOT NULL,
    [TipoPessoa]    VARCHAR (15)  NULL,
    [CPFCNPJ]       VARCHAR (18)  NULL,
    [NomeCliente]   VARCHAR (140) NULL,
    [CodigoCliente] VARCHAR (9)   NULL,
    [Endereco]      VARCHAR (40)  NULL,
    [Bairro]        VARCHAR (20)  NULL,
    [Cidade]        VARCHAR (20)  NULL,
    [UF]            CHAR (2)      NULL,
    [CEP]           CHAR (9)      NULL,
    [DDD]           VARCHAR (4)   NULL,
    [Telefone]      VARCHAR (10)  NULL,
    [LastValue]     BIT           NULL,
    [DataArquivo]   DATE          NOT NULL,
    [Arquivo]       VARCHAR (80)  NULL,
    CONSTRAINT [PK_CONTRATOCLIENTE] PRIMARY KEY CLUSTERED ([IDContrato] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CONTRATO_REFERENCE_CONTRATO] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_ContratoCliente_LastValue]
    ON [Dados].[ContratoCliente]([IDContrato] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_ContratoCliente_CPFCNPJ]
    ON [Dados].[ContratoCliente]([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_contratoCliente]
    ON [Dados].[ContratoCliente]([CPFCNPJ] ASC, [IDContrato] ASC, [CodigoCliente] ASC) WITH (FILLFACTOR = 90);

