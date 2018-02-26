CREATE TABLE [Dados].[Contrato] (
    [ID]                                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContratoAnterior]                 BIGINT          NULL,
    [IDProposta]                         BIGINT          NULL,
    [IDSeguradora]                       SMALLINT        NOT NULL,
    [IDRamo]                             SMALLINT        NULL,
    [NumeroContrato]                     VARCHAR (24)    NULL,
    [CodigoFonteProdutora]               SMALLINT        NULL,
    [NumeroBilhete]                      VARCHAR (20)    NULL,
    [NumeroSICOB]                        VARCHAR (9)     NULL,
    [DataEmissao]                        DATE            NULL,
    [DataInicioVigencia]                 DATE            NULL,
    [DataFimVigencia]                    DATE            NULL,
    [DataCancelamento]                   DATE            NULL,
    [ValorPremioLiquido]                 DECIMAL (19, 2) NULL,
    [ValorPremioTotal]                   DECIMAL (19, 2) NULL,
    [DataFimVigenciaAtual]               DATE            NULL,
    [ValorPremioTotalAtual]              DECIMAL (19, 2) NULL,
    [ValorPremioLiquidoAtual]            DECIMAL (19, 2) NULL,
    [IDSituacaoEndosso]                  TINYINT         NULL,
    [QuantidadeParcelas]                 TINYINT         NULL,
    [IDAgencia]                          SMALLINT        NULL,
    [IDIndicador]                        INT             NULL,
    [IDIndicadorGerente]                 INT             NULL,
    [IDIndicadorSuperintendenteRegional] INT             NULL,
    [CodigoMoedaSegurada]                SMALLINT        NULL,
    [CodigoMoedaPremio]                  SMALLINT        NULL,
    [LayoutRisco]                        VARCHAR (10)    NULL,
    [DataArquivo]                        DATE            NOT NULL,
    [Arquivo]                            VARCHAR (80)    NOT NULL,
    [NomeTomador]                        VARCHAR (140)   NULL,
    [EnderecoLocalRisco]                 VARCHAR (200)   NULL,
    [BairroLocalRisco]                   VARCHAR (100)   NULL,
    [CidadeLocalRisco]                   VARCHAR (100)   NULL,
    [UFLocalRisco]                       VARCHAR (2)     NULL,
    [NomeEmpreendimento]                 VARCHAR (100)   NULL,
    [CodigoCorretor1]                    VARCHAR (50)    NULL,
    [CNPJCorretor1]                      VARCHAR (20)    NULL,
    [RazaoSocialCorretor1]               VARCHAR (100)   NULL,
    [CodigoCorretor2]                    VARCHAR (50)    NULL,
    [CNPJCorretor2]                      VARCHAR (50)    NULL,
    [RazaoSocialCorretor2]               VARCHAR (100)   NULL,
    [Rowversion]                         ROWVERSION      NOT NULL,
    CONSTRAINT [PK_CONTRATO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CONTRATO_FK_CONTRA_CONTRATO] FOREIGN KEY ([IDContratoAnterior]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_CONTRATO_FK_CONTRA_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_CONTRATO_FK_CONTRA_RAMO] FOREIGN KEY ([IDRamo]) REFERENCES [Dados].[Ramo] ([ID]),
    CONSTRAINT [FK_CONTRATO_FK_CONTRA_UNIDADE] FOREIGN KEY ([IDAgencia]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_CONTRATO_INDICADOR] FOREIGN KEY ([IDIndicador]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CONTRATO_INDICADOR_GERENTE] FOREIGN KEY ([IDIndicadorGerente]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CONTRATO_INDICADOR_SUPERINTENDENTEREG] FOREIGN KEY ([IDIndicadorSuperintendenteRegional]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CONTRATO_REFERENCE_SEGURADORA] FOREIGN KEY ([IDSeguradora]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_Contrato_SituacaoEndosso] FOREIGN KEY ([IDSituacaoEndosso]) REFERENCES [Dados].[SituacaoEndosso] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Contrato_IDProposta]
    ON [Dados].[Contrato]([IDProposta] ASC)
    INCLUDE([ID], [DataInicioVigencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_NCL_UNQ_Contrato_Seguradora]
    ON [Dados].[Contrato]([NumeroContrato] ASC, [IDSeguradora] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Contrato_Bilhete_Proposta]
    ON [Dados].[Contrato]([ID] ASC, [IDSeguradora] ASC)
    INCLUDE([NumeroContrato], [NumeroBilhete], [IDProposta], [DataEmissao], [ValorPremioLiquido], [ValorPremioTotal], [QuantidadeParcelas]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_contratoCliente]
    ON [Dados].[Contrato]([NumeroContrato] ASC, [ID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Contrato_Data_IDProposta]
    ON [Dados].[Contrato]([DataArquivo] ASC)
    INCLUDE([IDProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Contrato_DataInicioVigencia]
    ON [Dados].[Contrato]([DataInicioVigencia] ASC)
    INCLUDE([ID], [IDProposta], [DataFimVigencia], [DataCancelamento]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Essa entidade refere-se a uma generalização de APOLICE, COTA, TITULO e outros produtos que usem, mesmo que parcialmente, a estrutura descrita em seus campos para especificar os dados da venda do produto na forma de um CONTRATO', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Contrato';

