CREATE TABLE [Dados].[ContratoConsignadoCCA] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [Contrato]             VARCHAR (20)    NOT NULL,
    [ValorCredito]         DECIMAL (26, 6) NULL,
    [DataLiberacao]        DATE            NULL,
    [TipoDado]             VARCHAR (100)   NOT NULL,
    [CPFCNPJ]              VARCHAR (14)    NULL,
    [CodigoTipoContrato]   SMALLINT        NOT NULL,
    [CodigoCanalConcessao] VARCHAR (2)     NOT NULL,
    [CodigoCorrespondente] INT             NOT NULL,
    [CodigoConvenente]     INT             NOT NULL,
    [FlagPrestamista]      BIT             DEFAULT ((0)) NOT NULL,
    [ValorPrestamista]     DECIMAL (24, 4) NULL,
    [Agencia]              VARCHAR (4)     NOT NULL,
    [SituacaoContrato]     VARCHAR (10)    NULL,
    [CodigoSR]             VARCHAR (4)     NULL,
    [CargoFuncionario]     VARCHAR (20)    NULL,
    [MatriculaFuncionario] VARCHAR (7)     NULL,
    [ContratoComposto]     VARCHAR (60)    NOT NULL,
    [IDProposta]           BIGINT          NULL,
    [IDConvenente]         INT             NOT NULL,
    [IDFaixaCredito]       INT             NOT NULL,
    CONSTRAINT [pk_ContratoConsignadoCCA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_IDConvenente_ContratoConsginadoCCA] FOREIGN KEY ([IDConvenente]) REFERENCES [Dados].[Convenente] ([ID]),
    CONSTRAINT [fk_IDFaixaCredito_FaixaCredito] FOREIGN KEY ([IDFaixaCredito]) REFERENCES [Dados].[FaixaCredito] ([ID]),
    CONSTRAINT [fk_IDProposta_ContratoConsignadoCCA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_CPFCNPJ_ConsignadoCCA]
    ON [Dados].[ContratoConsignadoCCA]([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_Data_ConsignadoCCA]
    ON [Dados].[ContratoConsignadoCCA]([DataLiberacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

