CREATE TABLE [dbo].[ENDOSSO_BERKLEY_TEMP] (
    [ID]                            INT             NOT NULL,
    [NumeroProposta]                VARCHAR (20)    NULL,
    [Apolice]                       VARCHAR (15)    NULL,
    [Endosso]                       VARCHAR (15)    NULL,
    [IDTipoEndosso]                 SMALLINT        NULL,
    [AlteraEndosso]                 VARCHAR (15)    NULL,
    [DataEmissao]                   DATE            NULL,
    [InicioVigencia]                DATE            NULL,
    [FimVigencia]                   DATE            NULL,
    [QuantidadeParcelas]            VARCHAR (3)     NULL,
    [DataVencimentoPrimeiraParcela] DATE            NULL,
    [ComissaoAntecipada]            VARCHAR (1)     NULL,
    [ComissaoInicideSobreAdicional] VARCHAR (1)     NULL,
    [PremioLiquido]                 DECIMAL (38, 6) NULL,
    [Adicional]                     DECIMAL (38, 6) NULL,
    [CustoDeApolice]                DECIMAL (18, 6) NULL,
    [ValorIOF]                      DECIMAL (38, 6) NULL,
    [PremioTotal]                   DECIMAL (38, 6) NULL,
    [PercentualDeComissao]          DECIMAL (5, 2)  NULL,
    [ValorComissaoEndosso]          DECIMAL (38, 6) NULL,
    [QuantidadeDeVidasInicial]      VARCHAR (5)     NULL,
    [NumeroPropostaCorretor]        VARCHAR (7)     NULL,
    [DataArquivoEndosso]            DATE            NULL,
    [NomeArquivoEndosso]            VARCHAR (20)    NULL,
    [DataArquivoComissao]           DATE            NULL,
    [NomeArquivoComissao]           VARCHAR (20)    NULL,
    [NumeroParcela]                 VARCHAR (3)     NULL,
    [PremioLiquidoComissao]         DECIMAL (38, 6) NULL,
    [AdicionalComissao]             DECIMAL (38, 6) NULL,
    [CustoDeApoliceComissao]        DECIMAL (38, 6) NULL,
    [ValorIOFComissao]              DECIMAL (38, 6) NULL,
    [PremioTotalComissao]           DECIMAL (38, 6) NULL,
    [DataVencimentoPremio]          DATE            NULL,
    [ValorComissao]                 DECIMAL (38, 6) NULL,
    [DataVencimentoComissao]        DATE            NULL,
    [DataPagamentoComissao]         DATE            NULL,
    [Endereco]                      VARCHAR (50)    NULL,
    [NumeroEndereco]                VARCHAR (10)    NULL,
    [Complemento]                   VARCHAR (20)    NULL,
    [CEP]                           VARCHAR (8)     NULL,
    [Cidade]                        VARCHAR (30)    NULL,
    [UF]                            VARCHAR (2)     NULL,
    [EnderecoLocalRisco]            VARCHAR (50)    NULL,
    [NumeroLocalRisco]              VARCHAR (10)    NULL,
    [ComplementoLocalRisco]         VARCHAR (20)    NULL,
    [CEPLocalRisco]                 VARCHAR (8)     NULL,
    [CidadeLocalRisco]              VARCHAR (30)    NULL,
    [EstadoLocalRisco]              VARCHAR (2)     NULL
);


GO
CREATE CLUSTERED INDEX [IDX_ENDOSSO_BERKLEY_TEMP_ID]
    ON [dbo].[ENDOSSO_BERKLEY_TEMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_ENDOSSO_BERKLEY_TEMP_Proposta]
    ON [dbo].[ENDOSSO_BERKLEY_TEMP]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_ENDOSSO_BERKLEY_TEMP_Apolice]
    ON [dbo].[ENDOSSO_BERKLEY_TEMP]([Apolice] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

