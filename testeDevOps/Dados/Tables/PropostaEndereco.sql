CREATE TABLE [Dados].[PropostaEndereco] (
    [ID]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]     BIGINT        NULL,
    [IDTipoEndereco] TINYINT       NULL,
    [Endereco]       VARCHAR (150) NOT NULL,
    [Bairro]         VARCHAR (80)  NULL,
    [Cidade]         VARCHAR (80)  NULL,
    [UF]             CHAR (2)      NULL,
    [CEP]            VARCHAR (9)   NULL,
    [LastValue]      BIT           NULL,
    [TipoDado]       VARCHAR (50)  NULL,
    [DataArquivo]    DATE          NULL,
    CONSTRAINT [PK_PROPOSTAENDERECO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PROPOSTA_PROPOSTAENDERECO] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PROPOSTAENDERECO_TIPOENDERECO] FOREIGN KEY ([IDTipoEndereco]) REFERENCES [Dados].[TipoEndereco] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDX_CL_PropostaEndereco]
    ON [Dados].[PropostaEndereco]([IDProposta] ASC, [IDTipoEndereco] ASC, [Endereco] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_PropostaEndereco_LastValue]
    ON [Dados].[PropostaEndereco]([IDProposta] ASC, [IDTipoEndereco] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_idproposta_idtipoendereco]
    ON [Dados].[PropostaEndereco]([IDProposta] ASC, [IDTipoEndereco] ASC, [LastValue] ASC)
    INCLUDE([Endereco], [Cidade], [Bairro], [CEP], [UF]) WITH (FILLFACTOR = 90);

