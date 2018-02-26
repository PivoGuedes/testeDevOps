CREATE TABLE [Transacao].[Consignado] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [IDTipoTransacao]     INT             NOT NULL,
    [IDUnidade]           SMALLINT        NOT NULL,
    [CodigoCanal]         INT             NULL,
    [CodigoTipoTransacao] INT             NULL,
    [CodigoConvenente]    INT             NULL,
    [CodCorrespondente]   INT             NULL,
    [CPF]                 VARCHAR (20)    NOT NULL,
    [NumeroContrato]      VARCHAR (20)    NOT NULL,
    [ValorContrato]       DECIMAL (18, 2) NOT NULL,
    [ValorSeguro]         DECIMAL (18, 2) NULL,
    [DataLiberacao]       DATETIME        NULL,
    [Matricula]           VARCHAR (20)    NULL,
    [NomeFuncionario]     VARCHAR (255)   NULL,
    [TipoVenda]           VARCHAR (200)   NULL,
    [DataImportacao]      DATETIME        DEFAULT (getdate()) NOT NULL,
    [Ativo]               BIT             DEFAULT ((1)) NOT NULL,
    [IsFinanciado]        BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Consignado] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TipoTransacao_Consignado] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_Unidade_Consignado] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idx_consignado]
    ON [Transacao].[Consignado]([NumeroContrato] ASC, [DataLiberacao] ASC) WITH (FILLFACTOR = 90);

