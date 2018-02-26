CREATE TABLE [Dados].[PropostaVidaEmpresarialCargo] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]           BIGINT          NULL,
    [NivelCargo]           TINYINT         NULL,
    [ValorSeguradoCargo]   DECIMAL (19, 2) NULL,
    [QuantidadeVidasCargo] INT             NULL,
    [TipoDado]             VARCHAR (50)    NULL,
    [DataArquivo]          DATE            NULL,
    [LastValue]            BIT             NULL,
    CONSTRAINT [PK_PROPOSTAVIDAEMPRESARIALCARGO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTAVIDAEMPRESARIALCARGO_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IND_NCL_PropostaVidaEmpresarialCargo_LastValue]
    ON [Dados].[PropostaVidaEmpresarialCargo]([IDProposta] ASC, [NivelCargo] ASC, [LastValue] DESC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaVidaEmpresarialCargo_IDProposta]
    ON [Dados].[PropostaVidaEmpresarialCargo]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

