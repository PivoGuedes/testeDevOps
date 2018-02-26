CREATE TABLE [Dados].[PropostaAIC] (
    [ID]                        INT              IDENTITY (1, 1) NOT NULL,
    [IDProposta]                BIGINT           NULL,
    [IDProdutoSIGPF]            TINYINT          NULL,
    [IDTipoPagamento]           INT              NULL,
    [IDMatricula]               VARCHAR (5)      NULL,
    [IDUnidade]                 SMALLINT         NULL,
    [IDCanalVenda]              INT              NULL,
    [IDTipoContribuicao]        VARCHAR (20)     NULL,
    [DataVenda]                 DATE             NULL,
    [HoraVenda]                 TIME (7)         NULL,
    [Matricula]                 VARCHAR (20)     NULL,
    [ValorPremio]               DECIMAL (19, 2)  NULL,
    [ValorContribuicaoGravidez] DECIMAL (19, 2)  NULL,
    [ValorAporteInicial]        DECIMAL (19, 2)  NULL,
    [ValorContribuicaoMensal]   DECIMAL (19, 2)  NULL,
    [ValorContribuicaoPPC]      DECIMAL (19, 2)  NULL,
    [ValorContribuicaoPeculio]  DECIMAL (19, 2)  NULL,
    [SupRede]                   VARCHAR (20)     NULL,
    [NomeConsultor]             VARCHAR (150)    NULL,
    [Asven]                     VARCHAR (2)      NULL,
    [SOData]                    DATE             NULL,
    [Mes]                       VARCHAR (20)     NULL,
    [GuidCodigoProdutoAIC]      UNIQUEIDENTIFIER NULL,
    [GuidCodigoCanalAIC]        UNIQUEIDENTIFIER NULL,
    [DescricaoTipoPessoa]       VARCHAR (10)     NULL,
    [CodigoTipoPessoa]          VARCHAR (10)     NULL,
    [NomeArquivo]               VARCHAR (200)    NULL,
    [IDPeriodoContribuicao]     INT              NULL,
    [MatriculaIndicador]        VARCHAR (20)     NULL,
    [DataArquivo]               DATE             NULL,
    [TipoSeguro]                VARCHAR (20)     NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaAIC_PeriodoContribuicao] FOREIGN KEY ([IDPeriodoContribuicao]) REFERENCES [Dados].[PeriodoContribuicao] ([ID]),
    CONSTRAINT [FK_PropostaAIC_ProdutoSIGPF] FOREIGN KEY ([IDProdutoSIGPF]) REFERENCES [Dados].[ProdutoSIGPF] ([ID]),
    CONSTRAINT [FK_PropostaAIC_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PropostaAIC_TipoPagamento] FOREIGN KEY ([IDTipoPagamento]) REFERENCES [Dados].[TipoPagamentoAIC] ([ID]),
    CONSTRAINT [FK_PropostaAIC_Unidade] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PropostaAIC_IDProposta]
    ON [Dados].[PropostaAIC]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

