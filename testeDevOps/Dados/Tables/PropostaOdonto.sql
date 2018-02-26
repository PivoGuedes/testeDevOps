CREATE TABLE [Dados].[PropostaOdonto] (
    [ID]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]            BIGINT          NOT NULL,
    [IDSubestipulante]      INT             NOT NULL,
    [NomeSegurado]          VARCHAR (80)    NOT NULL,
    [CPF]                   VARCHAR (11)    NOT NULL,
    [IDElegibilidade]       SMALLINT        NOT NULL,
    [IDGrauParentesco]      INT             NOT NULL,
    [IDSituacao]            SMALLINT        NOT NULL,
    [IDSexo]                TINYINT         NOT NULL,
    [IDEstadoCivil]         TINYINT         NOT NULL,
    [IDModalidadePagamento] SMALLINT        NOT NULL,
    [IDPlano]               INT             NOT NULL,
    [ValorMensal]           DECIMAL (10, 4) NOT NULL,
    [NumeroCartao]          VARCHAR (10)    NOT NULL,
    [DataInicioVigencia]    DATE            NOT NULL,
    [DataFimVigencia]       DATE            NULL,
    [NomeArquivo]           VARCHAR (100)   NOT NULL,
    [DataArquivo]           DATE            NOT NULL,
    CONSTRAINT [PK_PROPOSTAODONTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_EstadoCivil] FOREIGN KEY ([IDEstadoCivil]) REFERENCES [Dados].[EstadoCivil] ([ID]),
    CONSTRAINT [fk_IDElegibilidade] FOREIGN KEY ([IDElegibilidade]) REFERENCES [Dados].[TipoElegibilidade] ([ID]),
    CONSTRAINT [fk_IDoModalidade] FOREIGN KEY ([IDModalidadePagamento]) REFERENCES [Dados].[TipoModalidadePagamentoPropostaOdonto] ([ID]),
    CONSTRAINT [fk_IDSituacao] FOREIGN KEY ([IDSituacao]) REFERENCES [Dados].[TipoSituacaoSeguradoOdonto] ([ID]),
    CONSTRAINT [fk_Odonto_Grauparentesco_ID] FOREIGN KEY ([IDGrauParentesco]) REFERENCES [Dados].[GrauParentesco] ([ID]),
    CONSTRAINT [fk_Odonto_Proposta_ID] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [fk_Odonto_Sexo_ID] FOREIGN KEY ([IDSexo]) REFERENCES [Dados].[Sexo] ([ID]),
    CONSTRAINT [fk_Odonto_Subestip_ID] FOREIGN KEY ([IDSubestipulante]) REFERENCES [Dados].[PropostaOdontoSubestipulante] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_IDPROPOSTA_Odonto]
    ON [Dados].[PropostaOdonto]([IDProposta] ASC);

