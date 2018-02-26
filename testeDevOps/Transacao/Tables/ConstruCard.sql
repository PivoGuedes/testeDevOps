CREATE TABLE [Transacao].[ConstruCard] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [IDTipoTransacao]    INT             NOT NULL,
    [IDUF]               INT             NOT NULL,
    [RazaoSocial]        VARCHAR (150)   NOT NULL,
    [CPFCnpj]            VARCHAR (20)    NOT NULL,
    [NumeroContrato]     VARCHAR (20)    NOT NULL,
    [DataConcessao]      DATE            NOT NULL,
    [ValorContratado]    DECIMAL (18, 2) NOT NULL,
    [PrazoFinanciamento] INT             NOT NULL,
    [CodigoStatus]       INT             NOT NULL,
    [Telefone]           VARCHAR (20)    NOT NULL,
    [DataImportacao]     DATETIME        DEFAULT (getdate()) NOT NULL,
    [Ativo]              BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ConstruCard] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TipoTransacaoConstrucard] FOREIGN KEY ([IDTipoTransacao]) REFERENCES [Transacao].[TipoTransacao] ([ID]),
    CONSTRAINT [FK_UF_CONSTRUCARD] FOREIGN KEY ([IDUF]) REFERENCES [Transacao].[UF] ([ID])
);

