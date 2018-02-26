CREATE TABLE [dbo].[EMISSAO_ENDOSSO_TEMP] (
    [Codigo]                           INT             NOT NULL,
    [ControleVersao]                   NUMERIC (16, 8) NULL,
    [NomeArquivo]                      VARCHAR (100)   NOT NULL,
    [DataArquivo]                      DATE            NOT NULL,
    [CPFCNPJ]                          VARCHAR (18)    NULL,
    [Nome]                             VARCHAR (140)   NOT NULL,
    [TipoPessoa]                       VARCHAR (15)    NULL,
    [IDSeguradora]                     INT             NOT NULL,
    [NumeroContrato]                   VARCHAR (20)    NULL,
    [NumeroProposta]                   VARCHAR (20)    NULL,
    [CodigoProduto]                    VARCHAR (6)     NULL,
    [DataEmissao]                      DATE            NOT NULL,
    [DataInicioVigencia]               DATE            NOT NULL,
    [DataFimVigencia]                  DATE            NOT NULL,
    [Agencia]                          VARCHAR (20)    NULL,
    [NumeroContratoAnterior]           VARCHAR (20)    NULL,
    [ValorPremioTotal]                 NUMERIC (15, 2) NOT NULL,
    [ValorPremioLiquido]               NUMERIC (15, 2) NOT NULL,
    [QuantidadeParcelas]               SMALLINT        NOT NULL,
    [NumeroEndosso]                    BIGINT          NOT NULL,
    [TipoEndosso]                      TINYINT         NOT NULL,
    [DescricaoTipoEndosso]             VARCHAR (39)    NULL,
    [SituacaoEndosso]                  TINYINT         NOT NULL,
    [DescricaoSituacaoEndosso]         VARCHAR (9)     NULL,
    [Indicador]                        VARCHAR (20)    NULL,
    [IndicadorGerente]                 VARCHAR (20)    NULL,
    [IndicadorSuperintendenteRegional] VARCHAR (20)    NULL,
    [CodigoMoedaSegurada]              VARCHAR (30)    NULL,
    [CodigoMoedaPremio]                VARCHAR (30)    NULL,
    [CodigoSubestipulante]             VARCHAR (30)    NULL,
    [CodigoFonteProdutora]             VARCHAR (30)    NULL,
    [NumeroPropostaSASSE]              VARCHAR (20)    NULL,
    [NumeroBilhete]                    VARCHAR (20)    NULL,
    [NumeroSICOB]                      VARCHAR (20)    NULL,
    [CodigoCliente]                    VARCHAR (20)    NULL,
    [LayoutRisco]                      VARCHAR (50)    NULL,
    [CodigoRamo]                       VARCHAR (20)    NULL,
    [Endereco]                         VARCHAR (8000)  NULL,
    [Bairro]                           VARCHAR (8000)  NULL,
    [Cidade]                           VARCHAR (8000)  NULL,
    [UF]                               VARCHAR (8000)  NULL,
    [CEP]                              VARCHAR (8000)  NULL,
    [DDD]                              VARCHAR (8000)  NULL,
    [Telefone]                         VARCHAR (8000)  NULL,
    [NomeTomador]                      VARCHAR (300)   NULL,
    [EnderecoLocalRisco]               VARCHAR (300)   NULL,
    [BairroLocalRisco]                 VARCHAR (300)   NULL,
    [CidadeLocalRisco]                 VARCHAR (300)   NULL,
    [UFLocalRisco]                     VARCHAR (300)   NULL,
    [NomeEmpreendimento]               VARCHAR (300)   NULL,
    [CodigoCorretor1]                  VARCHAR (300)   NULL,
    [CNPJCorretor1]                    VARCHAR (300)   NULL,
    [RazaoSocialCorretor1]             VARCHAR (300)   NULL,
    [CodigoCorretor2]                  VARCHAR (300)   NULL,
    [CnpjCorretor2]                    VARCHAR (300)   NULL,
    [RazaoSocialCorretor2]             VARCHAR (300)   NULL,
    [RankEndosso]                      BIGINT          NULL,
    [RankContrato]                     BIGINT          NULL
);


GO
CREATE CLUSTERED INDEX [idx_EMISSAO_ENDOSSO_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([NumeroContrato] ASC, [NumeroEndosso] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_EMISSAO_ENDOSSO_NumeroContratoAnterior_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([NumeroContratoAnterior] ASC)
    INCLUDE([NomeArquivo], [DataArquivo], [IDSeguradora]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_EMISSAO_ENDOSSO_Indicador_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([Indicador] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_EMISSAO_ENDOSSO_IndicadorGerente_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([IndicadorGerente] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_EMISSAO_ENDOSSO_IndicadorSuperintendenteRegional_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([IndicadorSuperintendenteRegional] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_EMISSAO_ENDOSSO_RankEndosso_TEMP]
    ON [dbo].[EMISSAO_ENDOSSO_TEMP]([RankEndosso] ASC)
    INCLUDE([NomeArquivo], [DataArquivo], [IDSeguradora], [NumeroContrato], [CodigoProduto], [DataEmissao], [DataInicioVigencia], [DataFimVigencia], [ValorPremioTotal], [ValorPremioLiquido], [QuantidadeParcelas], [NumeroEndosso], [TipoEndosso], [SituacaoEndosso], [CodigoSubestipulante]) WITH (FILLFACTOR = 90);

