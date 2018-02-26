CREATE TABLE [Dados].[PropostaSaudeVida] (
    [ID]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDPropostaSaudeFamilia] BIGINT        NOT NULL,
    [IDParentesco]           INT           NOT NULL,
    [IDTipoVida]             INT           NOT NULL,
    [NumeroCarteirinha]      VARCHAR (25)  NULL,
    [CPF]                    VARCHAR (14)  NULL,
    [IDGrupoCarencia]        INT           NULL,
    [DataVigencia]           DATE          NOT NULL,
    [EstadoCivil]            INT           NULL,
    [NomeDaMae]              VARCHAR (120) NOT NULL,
    [IDTipoKit]              INT           NULL,
    [DataFimVigencia]        DATE          NULL,
    [NomeSegurado]           VARCHAR (70)  NOT NULL,
    [TipoRegistro]           VARCHAR (2)   NOT NULL,
    [Digito]                 VARCHAR (1)   NOT NULL,
    CONSTRAINT [PK_PROPOSTASAUDEVIDA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY],
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_GRAUPARE] FOREIGN KEY ([IDParentesco]) REFERENCES [Dados].[GrauParentesco] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_TIPOKIT] FOREIGN KEY ([IDTipoKit]) REFERENCES [Dados].[TipoKit] ([ID]),
    CONSTRAINT [FK_PROPOSTA_FK_PROPOS_TIPOVIDA] FOREIGN KEY ([IDTipoVida]) REFERENCES [Dados].[TipoVida] ([ID]),
    CONSTRAINT [FK_PROPOSTA_REFERENCE_PROPOSTA] FOREIGN KEY ([IDPropostaSaudeFamilia]) REFERENCES [Dados].[PropostaSaudeFamilia] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20140806-104309]
    ON [Dados].[PropostaSaudeVida]([ID] ASC)
    INCLUDE([IDPropostaSaudeFamilia], [IDTipoVida], [NumeroCarteirinha], [CPF], [DataFimVigencia], [NomeSegurado], [TipoRegistro], [Digito]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141112-172656]
    ON [Dados].[PropostaSaudeVida]([IDPropostaSaudeFamilia] ASC, [NumeroCarteirinha] ASC, [NomeSegurado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];

