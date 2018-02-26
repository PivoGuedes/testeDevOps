CREATE TABLE [dbo].[APOLICE_BERKLEY_TEMP] (
    [ID]                            INT             NOT NULL,
    [Ramo]                          VARCHAR (2)     NULL,
    [NumeroProposta]                VARCHAR (15)    NULL,
    [Apolice]                       VARCHAR (15)    NULL,
    [DataEmissao]                   DATE            NULL,
    [InicioVigencia]                DATE            NULL,
    [FimVigencia]                   DATE            NULL,
    [QuantidadeParcelas]            VARCHAR (3)     NULL,
    [DataVencimentoPrimeiraParcela] DATE            NULL,
    [ComissaoAntecipada]            VARCHAR (1)     NULL,
    [ComissaoInicideSobreAdicional] VARCHAR (1)     NULL,
    [PremioLiquido]                 DECIMAL (18, 6) NULL,
    [Adicional]                     DECIMAL (18, 6) NULL,
    [CustoDeApolice]                DECIMAL (18, 6) NULL,
    [ValorIOF]                      DECIMAL (18, 6) NULL,
    [PremioTotal]                   DECIMAL (18, 6) NULL,
    [PercentualDeComissao]          DECIMAL (18, 6) NULL,
    [ValorComissao]                 VARCHAR (14)    NULL,
    [ApoliceRenovada]               VARCHAR (15)    NULL,
    [NumeroPropostaCorretor]        VARCHAR (7)     NULL,
    [NomeUsuario]                   VARCHAR (50)    NULL,
    [MatriculaProdutorPAR]          VARCHAR (10)    NULL,
    [NomeCliente]                   VARCHAR (50)    NULL,
    [Endereco]                      VARCHAR (50)    NULL,
    [Bairro]                        VARCHAR (30)    NULL,
    [Cidade]                        VARCHAR (30)    NULL,
    [UF]                            VARCHAR (2)     NULL,
    [CEP]                           VARCHAR (8)     NULL,
    [TipoPessoa]                    VARCHAR (1)     NULL,
    [CPFCNPJ]                       VARCHAR (18)    NULL,
    [DDD]                           VARCHAR (4)     NULL,
    [Telefone]                      VARCHAR (12)    NULL,
    [NomeArquivo]                   VARCHAR (50)    NOT NULL,
    [DataArquivo]                   DATE            NOT NULL,
    [CodigoComercializado]          VARCHAR (2)     NULL,
    [Descricao]                     VARCHAR (100)   NULL
);


GO
CREATE CLUSTERED INDEX [IDX_APOLICE_Berkley_TEMP_ID]
    ON [dbo].[APOLICE_BERKLEY_TEMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_APOLICE_Berkley_TEMP_Proposta]
    ON [dbo].[APOLICE_BERKLEY_TEMP]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_APOLICE_Berkley_TEMP_Apolice]
    ON [dbo].[APOLICE_BERKLEY_TEMP]([Apolice] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

