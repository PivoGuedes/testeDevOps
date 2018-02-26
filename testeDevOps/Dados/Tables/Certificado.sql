CREATE TABLE [Dados].[Certificado] (
    [ID]                                 INT             IDENTITY (1, 1) NOT NULL,
    [IDContrato]                         BIGINT          NULL,
    [IDProposta]                         BIGINT          NULL,
    [IDSeguradora]                       SMALLINT        NOT NULL,
    [NumeroCertificado]                  VARCHAR (20)    NOT NULL,
    [NumeroSICOB]                        VARCHAR (9)     NULL,
    [CPF]                                VARCHAR (18)    NULL,
    [NomeCliente]                        VARCHAR (140)   NULL,
    [DataNascimento]                     DATE            NULL,
    [IDAgencia]                          SMALLINT        NULL,
    [MatriculaIndicador]                 VARCHAR (20)    NULL,
    [MatriculaIndicadorGerente]          VARCHAR (20)    NULL,
    [MatriculaSuperintendenteRegional]   VARCHAR (20)    NULL,
    [MatriculaFuncionarioCaixa]          VARCHAR (20)    NULL,
    [DataInicioVigencia]                 DATE            NULL,
    [DataFimVigencia]                    DATE            NULL,
    [DataCancelamento]                   DATE            NULL,
    [ValorPremioBruto]                   DECIMAL (19, 2) CONSTRAINT [DF_Certificado_ValorPremioBruto] DEFAULT ((0)) NULL,
    [ValorPremioLiquido]                 DECIMAL (19, 2) CONSTRAINT [DF_Certificado_ValorPremioLiquido] DEFAULT ((0)) NULL,
    [IDIndicador]                        INT             NULL,
    [IDIndicadorGerente]                 INT             NULL,
    [IDIndicadorSuperintendenteRegional] INT             NULL,
    [IDFuncionarioCaixa]                 INT             NULL,
    [IDTipoSegurado]                     INT             NULL,
    [CodigoMoedaSegurada]                SMALLINT        NULL,
    [CodigoMoedaPremio]                  SMALLINT        NULL,
    [TipoBeneficio]                      CHAR (1)        NULL,
    [DataArquivo]                        DATE            NOT NULL,
    [Arquivo]                            VARCHAR (80)    NOT NULL,
    [NumeroCertificadoOriginal]          VARCHAR (20)    NULL,
    CONSTRAINT [PK_Certificado_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CERTIFIC_FK_CERTIF_CONTRATO] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_CERTIFIC_FK_CERTIF_PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_CERTIFIC_FK_CERTIF_SEGURADO] FOREIGN KEY ([IDSeguradora]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_CERTIFIC_FK_CERTIF_UNIDADE] FOREIGN KEY ([IDAgencia]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_CERTIFIC_FUNCIONARIOCAIXA] FOREIGN KEY ([IDFuncionarioCaixa]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CERTIFIC_GERENTE] FOREIGN KEY ([IDIndicadorGerente]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CERTIFIC_INDICADOR] FOREIGN KEY ([IDIndicador]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_CERTIFIC_SUPERINTENDENTEREG] FOREIGN KEY ([IDIndicadorSuperintendenteRegional]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_Certificado_TipoSeguradoCertificado_ID] FOREIGN KEY ([IDTipoSegurado]) REFERENCES [Dados].[TipoSeguradoCertificado] ([ID]),
    CONSTRAINT [UNQ_Certificado] UNIQUE NONCLUSTERED ([NumeroCertificado] ASC, [IDProposta] ASC, [IDSeguradora] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idxNC_IDSeguradora_NumeroCertificado]
    ON [Dados].[Certificado]([IDSeguradora] ASC, [NumeroCertificado] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Certificado_IDProposta]
    ON [Dados].[Certificado]([IDProposta] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_DataArquivo_Certificado]
    ON [Dados].[Certificado]([DataArquivo] ASC)
    INCLUDE([IDContrato], [IDProposta], [CPF], [NomeCliente]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_ValorPremioBruto]
    ON [Dados].[Certificado]([ValorPremioBruto] ASC)
    INCLUDE([ID], [IDProposta], [DataInicioVigencia], [DataFimVigencia], [ValorPremioLiquido], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Essa entidade refere-se a desmembramento ou subcontrato específico para os produtos referentes a SEGURO DE VIDA.
Cada CERTIFICADO deve ter uma associação de Apólice (Contrato) na tabela ContratoCertificado e o número da proposta que gerou o respectivo CERTIFICADO.', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Certificado';

