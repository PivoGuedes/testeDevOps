CREATE TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP] (
    [ID]                          INT           IDENTITY (1, 1) NOT NULL,
    [FilialProtheus]              VARCHAR (2)   NOT NULL,
    [OperadoraProposta]           VARCHAR (4)   NOT NULL,
    [GrupoEmpresa]                VARCHAR (4)   NOT NULL,
    [NumeroContrato]              VARCHAR (12)  NOT NULL,
    [VersaoContrato]              VARCHAR (3)   NOT NULL,
    [SubContrato]                 VARCHAR (9)   NOT NULL,
    [VersaoSubContrato]           VARCHAR (3)   NOT NULL,
    [PropostaProtheus]            VARCHAR (12)  NOT NULL,
    [OperadoraVida]               VARCHAR (4)   NOT NULL,
    [GrupoEmpresaVida]            VARCHAR (4)   NOT NULL,
    [Matricula]                   VARCHAR (6)   NOT NULL,
    [ContratoVida]                VARCHAR (12)  NOT NULL,
    [NomeSegurado]                VARCHAR (70)  NOT NULL,
    [Empresa]                     VARCHAR (2)   NOT NULL,
    [Carteirinha]                 VARCHAR (25)  NULL,
    [NumeroProposta]              VARCHAR (25)  NOT NULL,
    [GrauParentesco]              VARCHAR (2)   NOT NULL,
    [CPF]                         VARCHAR (14)  NOT NULL,
    [EstadoCivil]                 VARCHAR (2)   NOT NULL,
    [NomeMae]                     VARCHAR (120) NOT NULL,
    [TipoUsuario]                 VARCHAR (1)   NOT NULL,
    [GrupoCarencia]               VARCHAR (3)   NULL,
    [SubContratoVida]             VARCHAR (9)   NOT NULL,
    [VersaoSubContratoVida]       VARCHAR (3)   NOT NULL,
    [VersaoContratoVida]          VARCHAR (3)   NOT NULL,
    [FilialVida]                  VARCHAR (2)   NOT NULL,
    [PropostaFamilia]             VARCHAR (30)  NOT NULL,
    [TipoKit]                     VARCHAR (16)  NULL,
    [DescKit]                     VARCHAR (65)  NULL,
    [TipoVida]                    VARCHAR (40)  NULL,
    [CodigoPlano]                 VARCHAR (4)   NOT NULL,
    [VersaoPlano]                 VARCHAR (3)   NOT NULL,
    [DescGrauParentesco]          VARCHAR (30)  NOT NULL,
    [DataVigencia]                DATE          NOT NULL,
    [DataFimVigencia]             DATE          NULL,
    [CodigoMotivoCancelamento]    VARCHAR (3)   NULL,
    [DescricaoMotivoCancelamento] VARCHAR (60)  NULL,
    [TipoBloqueio]                VARCHAR (21)  NULL,
    [TipoRegistro]                VARCHAR (2)   NOT NULL,
    [Digito]                      VARCHAR (1)   NOT NULL,
    CONSTRAINT [PK_PropostaSaudeFamiliaEVida_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_NumeroModelagem_PlanoFaixaEtaria_TEMP]
    ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]([OperadoraProposta] ASC, [NumeroProposta] ASC, [Matricula] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_PropostaSaudeFamilia]
    ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]([NumeroProposta] ASC)
    INCLUDE([OperadoraProposta], [Matricula], [Empresa], [CodigoPlano], [VersaoPlano], [CPF], [NomeSegurado], [TipoUsuario], [TipoRegistro], [Digito], [DataFimVigencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Plano]
    ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]([CodigoPlano] ASC, [VersaoPlano] ASC, [Empresa] ASC)
    INCLUDE([Carteirinha], [CPF], [GrupoCarencia], [DataVigencia], [EstadoCivil], [NomeMae], [DataFimVigencia], [NomeSegurado], [TipoRegistro], [Digito]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Kit]
    ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]([TipoKit] ASC, [DescKit] ASC)
    INCLUDE([Carteirinha], [CPF], [GrupoCarencia], [DataVigencia], [EstadoCivil], [NomeMae], [DataFimVigencia], [NomeSegurado], [TipoRegistro], [Digito]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Carteirinha]
    ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]([Carteirinha] ASC, [NomeSegurado] ASC)
    INCLUDE([CPF], [GrupoCarencia], [DataVigencia], [EstadoCivil], [NomeMae], [DataFimVigencia], [TipoRegistro], [Digito]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

