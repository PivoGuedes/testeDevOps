CREATE TABLE [dbo].[TMP] (
    [MesRefIni]                  DATE          NULL,
    [MesRefFim]                  DATE          NULL,
    [PVCodigo]                   SMALLINT      NULL,
    [PVASVEN]                    BIT           NOT NULL,
    [ID]                         INT           NULL,
    [IDUnidade]                  SMALLINT      NULL,
    [Nome]                       VARCHAR (100) NULL,
    [IDTipoUnidade]              SMALLINT      NULL,
    [IDFilialPARCorretora]       SMALLINT      NULL,
    [IDFilialFaturamento]        SMALLINT      NULL,
    [IDUnidadeEscritorioNegocio] SMALLINT      NULL,
    [Endereco]                   VARCHAR (100) NULL,
    [Bairro]                     VARCHAR (50)  NULL,
    [CEP]                        CHAR (8)      NULL,
    [DDD]                        CHAR (4)      NULL,
    [DataCriacao]                DATE          NULL,
    [DataExtincao]               DATE          NULL,
    [DataAutomacao]              DATE          NULL,
    [Praca]                      TINYINT       NULL,
    [IDTipoPV]                   SMALLINT      NULL,
    [IDRetaguarda]               SMALLINT      NULL,
    [AutenticarPV]               TINYINT       NULL,
    [Porte]                      TINYINT       NULL,
    [Rota]                       TINYINT       NULL,
    [Impressa]                   SMALLINT      NULL,
    [Responsavel]                VARCHAR (40)  NULL,
    [CodigoEnderecamento]        CHAR (8)      NULL,
    [SiglaUnidade]               CHAR (8)      NULL,
    [CanalVoz]                   SMALLINT      NULL,
    [JusticaFederal]             CHAR (1)      NULL,
    [DataFimOperacao]            DATE          NULL,
    [ClassePV]                   CHAR (1)      NULL,
    [NomeMunicipio]              VARCHAR (35)  NULL,
    [UFMunicipio]                CHAR (2)      NULL,
    [Telefone1]                  CHAR (9)      NULL,
    [TipoTelefone1]              CHAR (5)      NULL,
    [Telefone2]                  CHAR (9)      NULL,
    [TipoTelefone2]              CHAR (5)      NULL,
    [Telefone3]                  CHAR (9)      NULL,
    [TipoTelefone3]              CHAR (5)      NULL,
    [Telefone4]                  CHAR (9)      NULL,
    [TipoTelefone4]              CHAR (5)      NULL,
    [Telefone5]                  CHAR (9)      NULL,
    [TipoTelefone5]              CHAR (5)      NULL,
    [ASVEN]                      BIT           NULL,
    [IBGE]                       NUMERIC (8)   NULL,
    [MatriculaGestor]            VARCHAR (20)  NULL,
    [CodigoNaFonte]              BIGINT        NULL,
    [TipoDado]                   VARCHAR (30)  NULL,
    [Arquivo]                    VARCHAR (80)  NULL,
    [DataArquivo]                DATE          NULL,
    [UPDT]                       INT           NULL
);


GO
CREATE CLUSTERED INDEX [D]
    ON [dbo].[TMP]([IDUnidade] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [N]
    ON [dbo].[TMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

