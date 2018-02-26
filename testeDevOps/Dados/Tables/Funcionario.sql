CREATE TABLE [Dados].[Funcionario] (
    [ID]                            INT              IDENTITY (1, 1) NOT NULL,
    [Nome]                          VARCHAR (100)    NULL,
    [CPF]                           CHAR (14)        NULL,
    [Email]                         VARCHAR (100)    NULL,
    [Matricula]                     VARCHAR (20)     NULL,
    [PIS]                           VARCHAR (20)     NULL,
    [IDEmpresa]                     SMALLINT         NOT NULL,
    [DDD]                           VARCHAR (5)      NULL,
    [Telefone]                      VARCHAR (20)     NULL,
    [IDMediaFile]                   UNIQUEIDENTIFIER NULL,
    [IDUsuario]                     UNIQUEIDENTIFIER NULL,
    [Salario]                       DECIMAL (20, 2)  NULL,
    [IDCentroCusto]                 SMALLINT         NULL,
    [IDGerenteRegional]             INT              NULL,
    [IDGerenteVenda]                INT              NULL,
    [IDGerenteNacional]             INT              NULL,
    [DataCriacao]                   DATE             NULL,
    [UltimoCargo]                   VARCHAR (100)    NULL,
    [DataAdmissao]                  DATE             NULL,
    [IDTipoVinculo]                 TINYINT          NULL,
    [IDUltimaFuncao]                SMALLINT         NULL,
    [IDUltimaSituacaoFuncionario]   SMALLINT         NULL,
    [DataAtualizacaoCentroCusto]    DATE             NULL,
    [DataAtualizacaoCargo]          DATE             NULL,
    [DataAtualizacaoVolta]          DATE             NULL,
    [DataSistema]                   DATETIME2 (7)    CONSTRAINT [DF__Funcionar__DataS__268672C9] DEFAULT (getdate()) NULL,
    [IDSexo]                        TINYINT          NULL,
    [DataNascimento]                DATE             NULL,
    [IDUltimaUnidade]               SMALLINT         NULL,
    [UltimoLotacaoEmail]            VARCHAR (100)    NULL,
    [UltimoParticipanteEmail]       VARCHAR (100)    NULL,
    [FuncaoIndicadorFaixa]          VARCHAR (30)     NULL,
    [NomeArquivo]                   VARCHAR (60)     NULL,
    [DataArquivo]                   DATE             NULL,
    [IDCargoPROPAY]                 SMALLINT         NULL,
    [DataUltimaSituacaoFuncionario] DATE             NULL,
    [IDEstadoCivil]                 TINYINT          NULL,
    [IDCargo]                       SMALLINT         NULL,
    [IDLotacao]                     SMALLINT         NULL,
    [DDDCelular]                    VARCHAR (5)      NULL,
    [Celular]                       VARCHAR (20)     NULL,
    [Endereco]                      VARCHAR (100)    NULL,
    [ComplementoEndereco]           VARCHAR (80)     NULL,
    [CEP]                           VARCHAR (9)      NULL,
    [Municipio]                     VARCHAR (80)     NULL,
    [Bairro]                        VARCHAR (80)     NULL,
    [UF]                            CHAR (2)         NULL,
    [IDIndicadorArea]               TINYINT          NULL,
    [VIP]                           BIT              DEFAULT ((0)) NULL,
    [SiglaLotacao]                  VARCHAR (10)     NULL,
    [Hierarquia]                    VARCHAR (50)     NULL,
    CONSTRAINT [PK_FUNCIONARIO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_DadosFuncionario_DadosCargo_IDCargo] FOREIGN KEY ([IDCargo]) REFERENCES [Dados].[Cargo] ([ID]),
    CONSTRAINT [FK_DadosFuncionario_DadosLotacao_IDLotacao] FOREIGN KEY ([IDLotacao]) REFERENCES [Dados].[Lotacao] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_CARGOPROPAY] FOREIGN KEY ([IDCargoPROPAY]) REFERENCES [Dados].[CargoPROPAY] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_CENTROCUSTO] FOREIGN KEY ([IDCentroCusto]) REFERENCES [Dados].[CentroCusto] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_EMPRESA] FOREIGN KEY ([IDEmpresa]) REFERENCES [Dados].[Empresa] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_ESTADOCIVIL] FOREIGN KEY ([IDEstadoCivil]) REFERENCES [Dados].[EstadoCivil] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_FUNCAO] FOREIGN KEY ([IDUltimaFuncao]) REFERENCES [Dados].[Funcao] ([ID]),
    CONSTRAINT [FK_FUNCIONA_FK_FUNCIO_TIPOVINC] FOREIGN KEY ([IDTipoVinculo]) REFERENCES [Dados].[TipoVinculo] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_GERENTENAC] FOREIGN KEY ([IDGerenteNacional]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_GERENTEREG] FOREIGN KEY ([IDGerenteRegional]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_GERENTEVEN] FOREIGN KEY ([IDGerenteVenda]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_SEXO] FOREIGN KEY ([IDSexo]) REFERENCES [Dados].[Sexo] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_SITUACAOFUNCIONARIO] FOREIGN KEY ([IDUltimaSituacaoFuncionario]) REFERENCES [Dados].[SituacaoFuncionario] ([ID]),
    CONSTRAINT [FK_FUNCIONA_REFERENCE_UNIDADE] FOREIGN KEY ([IDUltimaUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Funcionario_IndicadorArea] FOREIGN KEY ([IDIndicadorArea]) REFERENCES [Dados].[IndicadorArea] ([ID]),
    CONSTRAINT [FK_FuncionarioHistorico_IndicadorArea] FOREIGN KEY ([IDIndicadorArea]) REFERENCES [Dados].[IndicadorArea] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_FuncionarioMatricula]
    ON [Dados].[Funcionario]([Matricula] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_Funcionario_IDEmpresa_CPF_Matricula]
    ON [Dados].[Funcionario]([IDEmpresa] ASC, [CPF] ASC)
    INCLUDE([ID], [Matricula]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NCL_UNQ_Funcionario]
    ON [Dados].[Funcionario]([CPF] ASC, [Matricula] ASC, [IDEmpresa] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

