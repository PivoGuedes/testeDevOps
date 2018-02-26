﻿CREATE TABLE [dbo].[CERTIFICADO_TEMP] (
    [Codigo]                                    BIGINT          NOT NULL,
    [ControleVersao]                            NUMERIC (16, 8) NULL,
    [NomeArquivo]                               NVARCHAR (100)  NOT NULL,
    [DataArquivo]                               DATE            NULL,
    [CPF]                                       CHAR (18)       NULL,
    [Nome]                                      VARCHAR (8000)  NULL,
    [DataNascimento]                            DATE            NULL,
    [IDSeguradora]                              INT             NOT NULL,
    [NumeroContrato]                            VARCHAR (8000)  NULL,
    [NumeroCertificado]                         VARCHAR (20)    NULL,
    [DataInicioVigencia]                        DATE            NULL,
    [DataFimVigencia]                           DATE            NULL,
    [ValorPremioTotal]                          NUMERIC (15, 2) NULL,
    [ValorPremioLiquido]                        NUMERIC (15, 2) NULL,
    [Agencia]                                   VARCHAR (8000)  NULL,
    [QuantidadeParcelas]                        INT             NULL,
    [NumeroSICOB]                               VARCHAR (8000)  NULL,
    [CodigoSubestipulante]                      VARCHAR (8000)  NULL,
    [MatriculaIndicador]                        VARCHAR (8000)  NULL,
    [MatriculaIndicadorGerente]                 VARCHAR (8000)  NULL,
    [MatriculaIndicadorSuperintendenteRegional] VARCHAR (8000)  NULL,
    [MatriculaFuncionario]                      VARCHAR (8000)  NULL,
    [CodigoMoedaSegurada]                       VARCHAR (8000)  NULL,
    [CodigoMoedaPremio]                         VARCHAR (8000)  NULL,
    [TipoBeneficio]                             VARCHAR (8000)  NULL,
    [DataCancelamento]                          DATE            NULL,
    [NumeroProposta]                            VARCHAR (8000)  NULL,
    [CodigoPeriodoPagamento]                    VARCHAR (8000)  NULL,
    [PeriodoPagamento]                          VARCHAR (10)    NULL,
    [CodigoTipoSegurado]                        SMALLINT        NULL,
    [TipoSegurado]                              VARCHAR (16)    NULL,
    [CodigoCliente]                             VARCHAR (9)     NULL,
    [EstadoCivil]                               CHAR (1)        NULL,
    [Endereco]                                  VARCHAR (40)    NULL,
    [Bairro]                                    VARCHAR (20)    NULL,
    [Cidade]                                    VARCHAR (20)    NULL,
    [SiglaUF]                                   VARCHAR (16)    NULL,
    [CEP]                                       VARCHAR (9)     NULL,
    [DDD]                                       VARCHAR (4)     NULL,
    [Telefone]                                  VARCHAR (9)     NULL,
    [CodigoProduto]                             VARCHAR (5)     NULL,
    [RankCertificadoProposta]                   BIGINT          NULL,
    [RankCertificado]                           BIGINT          NULL
);


GO
CREATE CLUSTERED INDEX [idx_CERTIFICADO_TEMP]
    ON [dbo].[CERTIFICADO_TEMP]([Codigo] ASC) WITH (FILLFACTOR = 90);

