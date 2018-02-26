CREATE TABLE [Dados].[PropostaCapitalizacao] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]              BIGINT          NOT NULL,
    [TipoTitular]             INT             NULL,
    [ValorMensalidade]        DECIMAL (16, 9) NULL,
    [QtdeTotalTitulos]        INT             NULL,
    [TituloOriginarioRevenda] VARCHAR (20)    NULL,
    [DataCreditoFederalCap]   DATETIME        NULL,
    [TipoArquivo]             VARCHAR (20)    NULL,
    [NomeArquivo]             VARCHAR (100)   NULL,
    [DataArquivo]             DATETIME        NOT NULL,
    [LastValue]               BIT             NULL,
    CONSTRAINT [PK_PropostaCapitalizacao] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaCapitalizacao_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE CLUSTERED INDEX [IDX_NCL_PropostaCapitalizacao_IDProposta]
    ON [Dados].[PropostaCapitalizacao]([IDProposta] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_PropostaCapitalizacao_LastValue]
    ON [Dados].[PropostaCapitalizacao]([IDProposta] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

