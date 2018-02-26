CREATE TABLE [Dados].[UnidadeHistorico] (
    [ID]                         INT           IDENTITY (1, 1) NOT NULL,
    [IDUnidade]                  SMALLINT      NULL,
    [Codigo]                     AS            ([Dados].[fn_RetornaUnidadeCodigo]([IDUnidade])),
    [Nome]                       VARCHAR (100) NOT NULL,
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
    [ASVEN]                      BIT           CONSTRAINT [DF__UnidadeHi__ASVEN__02BD4848] DEFAULT ((0)) NOT NULL,
    [IBGE]                       NUMERIC (8)   NULL,
    [MatriculaGestor]            VARCHAR (20)  NULL,
    [CodigoNaFonte]              BIGINT        NOT NULL,
    [TipoDado]                   VARCHAR (30)  NOT NULL,
    [Arquivo]                    VARCHAR (80)  NOT NULL,
    [DataArquivo]                DATE          NOT NULL,
    [LastValue]                  BIT           NULL,
    CONSTRAINT [PK_UNIDADEHISTORICO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [Dados],
    CONSTRAINT [FK_UNIDADE_FK_UNIDAD_RETAGUARDA] FOREIGN KEY ([IDRetaguarda]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_UNIDADEH_FK_UNIDAD_FILIALPA] FOREIGN KEY ([IDFilialPARCorretora]) REFERENCES [Dados].[FilialPARCorretora] ([ID]),
    CONSTRAINT [FK_UNIDADEH_FK_UNIDAD_TIPOPV] FOREIGN KEY ([IDTipoPV]) REFERENCES [Dados].[TipoPV] ([ID]),
    CONSTRAINT [FK_UNIDADEH_FK_UNIDAD_TIPOUNID] FOREIGN KEY ([IDTipoUnidade]) REFERENCES [Dados].[TipoUnidade] ([ID]),
    CONSTRAINT [FK_UNIDADEH_FK_UNIDAD_UNIDADEH] FOREIGN KEY ([IDUnidadeEscritorioNegocio]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_UNIDADEHISTORICO_REFERENCE_FILIALFA] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [FK_UNIDADEHISTORICO_UNIDADE] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);


GO
CREATE CLUSTERED INDEX [idx_CL_UnidadeHistorico]
    ON [Dados].[UnidadeHistorico]([IDUnidade] ASC, [DataArquivo] DESC, [ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_UnidadeHistorico]
    ON [Dados].[UnidadeHistorico]([IDUnidade] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [Dados];


GO
CREATE NONCLUSTERED INDEX [IDX_NC_IDTipoPV]
    ON [Dados].[UnidadeHistorico]([IDTipoPV] ASC)
    INCLUDE([IDUnidade]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IDX_NC_IDUnidadeEscritorioNegocio]
    ON [Dados].[UnidadeHistorico]([IDUnidadeEscritorioNegocio] ASC)
    INCLUDE([IDUnidade], [Nome], [IDTipoUnidade], [Endereco], [Bairro], [CEP], [DDD], [DataCriacao], [DataExtincao], [IDTipoPV], [Responsavel], [CodigoEnderecamento], [DataFimOperacao], [NomeMunicipio], [UFMunicipio], [Telefone1], [TipoTelefone1], [Telefone2], [TipoTelefone2], [ASVEN], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_UnidadeHistorico_LastValue]
    ON [Dados].[UnidadeHistorico]([IDUnidade] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [Dados];

