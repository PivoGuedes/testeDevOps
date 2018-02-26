CREATE TABLE [Dados].[ComissaoSaude] (
    [ID]                   BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDComissao]           BIGINT        NOT NULL,
    [IDCanalVendaPARSaude] INT           NOT NULL,
    [IDSegmento]           SMALLINT      NOT NULL,
    [TipoComissao]         CHAR (1)      NOT NULL,
    [IDSeguradora]         SMALLINT      NOT NULL,
    [QtApolices]           INT           NOT NULL,
    [Segmento]             INT           NOT NULL,
    [NomeContrato]         VARCHAR (140) NULL,
    [CPFCNPJ]              VARCHAR (18)  NULL,
    CONSTRAINT [PK_Comissao_Saude] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Comissao_Saude_CANALVENDA] FOREIGN KEY ([IDCanalVendaPARSaude]) REFERENCES [Dados].[CanalVendaPARSaude] ([ID]),
    CONSTRAINT [FK_Comissao_Saude_FK_COMISS] FOREIGN KEY ([IDComissao]) REFERENCES [Dados].[Comissao_Partitioned] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_ComissaoSaude_IDComissao]
    ON [Dados].[ComissaoSaude]([IDComissao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

