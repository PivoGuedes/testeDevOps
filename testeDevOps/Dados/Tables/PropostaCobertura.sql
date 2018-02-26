CREATE TABLE [Dados].[PropostaCobertura] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]               BIGINT          NOT NULL,
    [IDCobertura]              SMALLINT        NOT NULL,
    [IDTipoCobertura]          TINYINT         NOT NULL,
    [ValorImportanciaSegurada] DECIMAL (19, 2) NULL,
    [ValorPremio]              DECIMAL (19, 2) NULL,
    [LastValue]                BIT             NULL,
    [DataArquivo]              DATE            NULL,
    [Arquivo]                  VARCHAR (100)   NULL,
    CONSTRAINT [PK_PropostaCobertura] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaCobertura_Cobertura] FOREIGN KEY ([IDCobertura]) REFERENCES [Dados].[Cobertura] ([ID]),
    CONSTRAINT [FK_PropostaCobertura_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PropostaCobertura_TipoCobertura] FOREIGN KEY ([IDTipoCobertura]) REFERENCES [Dados].[TipoCobertura] ([ID]),
    CONSTRAINT [UNQ_PropostaCoberturaUnica] UNIQUE NONCLUSTERED ([IDProposta] ASC, [IDCobertura] ASC, [IDTipoCobertura] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PropostaCobertura_LastValue]
    ON [Dados].[PropostaCobertura]([IDProposta] ASC, [IDCobertura] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_LastValue]
    ON [Dados].[PropostaCobertura]([LastValue] ASC)
    INCLUDE([IDProposta], [IDCobertura], [IDTipoCobertura], [ValorImportanciaSegurada], [ValorPremio], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

