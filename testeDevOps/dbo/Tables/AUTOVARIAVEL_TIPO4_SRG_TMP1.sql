﻿CREATE TABLE [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP1] (
    [Codigo]                        BIGINT         NOT NULL,
    [NomeArquivo]                   NVARCHAR (100) NOT NULL,
    [DataArquivo]                   DATE           NOT NULL,
    [NumeroProposta]                CHAR (14)      NULL,
    [DataHoraProcessamento]         DATETIME2 (7)  NOT NULL,
    [TipoArquivo]                   VARCHAR (15)   NULL,
    [CodigoVeiculo]                 VARCHAR (6)    NULL,
    [DescricaoVeiculo]              VARCHAR (60)   NULL,
    [CodigoRegiao]                  VARCHAR (4)    NULL,
    [AnoFabricacao]                 VARCHAR (4)    NULL,
    [AnoModelo]                     VARCHAR (4)    NULL,
    [Capacidade]                    TINYINT        NULL,
    [CodigoBonus]                   TINYINT        NULL,
    [CodigoSubProduto]              VARCHAR (6)    NULL,
    [CodigoClasseFranquia]          VARCHAR (4)    NULL,
    [ClasseFranquia]                VARCHAR (13)   NULL,
    [Cobertura]                     VARCHAR (1)    NULL,
    [DataInicioVigencia]            DATE           NULL,
    [DataFimVigencia]               DATE           NULL,
    [Combustivel]                   VARCHAR (8)    NULL,
    [PlacaVeiculo]                  VARCHAR (8)    NULL,
    [CHASSIS]                       VARCHAR (20)   NULL,
    [NumeroApoliceAnterior]         VARCHAR (21)   NULL,
    [QuantidadeParcelas]            VARCHAR (2)    NULL,
    [NomeCondutor1]                 VARCHAR (100)  NULL,
    [EstadoCivilCondutor1]          VARCHAR (20)   NULL,
    [SexoCondutor1]                 VARCHAR (20)   NULL,
    [RGCondutor1]                   VARCHAR (20)   NULL,
    [DataNascimentoCondutor1]       DATE           NULL,
    [CNHCondutor1]                  VARCHAR (20)   NULL,
    [DataCNHCondutor1]              DATE           NULL,
    [CodigoRelacionamento]          VARCHAR (2)    NULL,
    [NomeCondutor2]                 VARCHAR (100)  NULL,
    [EstadoCivilCondutor2]          VARCHAR (20)   NULL,
    [SexoCondutor2]                 VARCHAR (20)   NULL,
    [RGCondutor2]                   VARCHAR (20)   NULL,
    [DataNascimentoCondutor2]       DATE           NULL,
    [CNHCondutor2]                  VARCHAR (20)   NULL,
    [DataCNHCondutor2]              DATE           NULL,
    [CodigoRelacionamentoCondutor2] VARCHAR (2)    NULL,
    [VersaoCalculo]                 VARCHAR (4)    NULL,
    [CodigoSeguradora]              VARCHAR (5)    NULL,
    [CodigoRegiaoVistoriada]        VARCHAR (4)    NULL,
    [CodigoTipoSeguro]              VARCHAR (2)    NULL,
    [TipoSeguro]                    VARCHAR (35)   NULL,
    [TP]                            VARCHAR (50)   NULL
);


GO
CREATE CLUSTERED INDEX [idx_AUTOVARIAVEL_TIPO4_SRG_TMP_Codigo]
    ON [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP1]([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

