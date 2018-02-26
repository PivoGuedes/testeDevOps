CREATE TABLE [Dados].[PropostaCapitalizacaoTituloSituacao] (
    [ID]                            BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDPropostaCapitalizacaoTitulo] BIGINT        NULL,
    [IDSituacaoTitulo]              TINYINT       NOT NULL,
    [IDMotivoSituacaoTitulo]        SMALLINT      NULL,
    [DataInicioSituacao]            DATE          NULL,
    [LastValue]                     BIT           CONSTRAINT [DF_PropostaCapitalizacaoTituloSituacao_LastValue] DEFAULT ((0)) NOT NULL,
    [DataArquivo]                   DATE          NOT NULL,
    [TipoArquivo]                   VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_PropostaCapitalizacaoTituloSituacao] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_IDSituacaoTituloTituloSituacao_SituacaoProposta] FOREIGN KEY ([IDSituacaoTitulo]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PropostaCapitalizacaoTituloSituacao_PropostaCapitalizacaoTitulo] FOREIGN KEY ([IDPropostaCapitalizacaoTitulo]) REFERENCES [Dados].[PropostaCapitalizacaoTitulo] ([ID]),
    CONSTRAINT [FK_PropostaCapitalizacaoTituloSituacao_TipoMotivo] FOREIGN KEY ([IDMotivoSituacaoTitulo]) REFERENCES [Dados].[TipoMotivo] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idxNCL_TitulosSituacao_CapitalizacaoTituloMotivoSituacaoData]
    ON [Dados].[PropostaCapitalizacaoTituloSituacao]([IDPropostaCapitalizacaoTitulo] ASC, [IDSituacaoTitulo] ASC, [IDMotivoSituacaoTitulo] ASC, [DataInicioSituacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_TitulosSituacao_LastValue]
    ON [Dados].[PropostaCapitalizacaoTituloSituacao]([IDPropostaCapitalizacaoTitulo] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

