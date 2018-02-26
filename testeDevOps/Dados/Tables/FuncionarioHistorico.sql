CREATE TABLE [Dados].[FuncionarioHistorico] (
    [ID]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]               INT             NOT NULL,
    [IDFuncao]                    SMALLINT        NULL,
    [IDUnidade]                   SMALLINT        NULL,
    [IDSituacaoFuncionario]       SMALLINT        NULL,
    [DataSituacao]                DATE            NULL,
    [CodigoOcupacao]              VARCHAR (7)     NULL,
    [Nome]                        VARCHAR (100)   NULL,
    [DataAdmissao]                DATE            NULL,
    [DataAtualizacaoCargo]        DATE            NULL,
    [DataAtualizacaoVolta]        DATE            NULL,
    [Salario]                     DECIMAL (20, 2) NULL,
    [Cargo]                       VARCHAR (100)   NULL,
    [LotacaoUF]                   VARCHAR (4)     NULL,
    [LotacaoCidade]               VARCHAR (60)    NULL,
    [LotacaoDataInicio]           DATE            NULL,
    [LotacaoSigla]                VARCHAR (30)    NULL,
    [LotacaoEmail]                VARCHAR (60)    NULL,
    [ParticipanteEmail]           VARCHAR (60)    NULL,
    [ParticipanteLotacaoDDD]      VARCHAR (5)     NULL,
    [ParticipanteLotacaoTelefone] VARCHAR (10)    NULL,
    [FuncaoDataInicio]            DATE            NULL,
    [NomeArquivo]                 VARCHAR (70)    NOT NULL,
    [DataArquivo]                 DATE            NOT NULL,
    [LastValue]                   BIT             CONSTRAINT [DF_FuncionarioHistorico_LastValue] DEFAULT ((0)) NOT NULL,
    [CargoCaixaSeguros]           VARCHAR (70)    NULL,
    [Lotacao]                     VARCHAR (70)    NULL,
    [IDCargoPropay]               SMALLINT        NULL,
    [IDIndicadorArea]             TINYINT         NULL,
    [IDCentroCusto]               SMALLINT        NULL,
    [VIP]                         BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_FuncionarioHistorico] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_FUNCIONAHISTORICO_REFERENCE_FUNCAO] FOREIGN KEY ([IDFuncao]) REFERENCES [Dados].[Funcao] ([ID]),
    CONSTRAINT [FK_FUNCIONAHISTORICO_REFERENCE_FUNCIONARIO] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_FUNCIONAHISTORICO_REFERENCE_SITUACAOFUNCIONARIO] FOREIGN KEY ([IDSituacaoFuncionario]) REFERENCES [Dados].[SituacaoFuncionario] ([ID]),
    CONSTRAINT [FK_FUNCIONAHISTORICO_REFERENCE_UNIDADE] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_FuncionarioHistorico_Ocupacao] FOREIGN KEY ([CodigoOcupacao]) REFERENCES [Dados].[Ocupacao] ([Codigo]),
    CONSTRAINT [FK_FUNCIONARIOHISTORICO_REFERENCE_CARGOPROPAY] FOREIGN KEY ([IDCargoPropay]) REFERENCES [Dados].[CargoPROPAY] ([ID])
);


GO
CREATE CLUSTERED INDEX [INX_CL_FuncionarioHistorico]
    ON [Dados].[FuncionarioHistorico]([IDFuncionario] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_FuncionarioHistorico_LastValue]
    ON [Dados].[FuncionarioHistorico]([IDFuncionario] ASC, [LastValue] ASC)
    INCLUDE([ID], [DataArquivo]) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_FuncionarioHistorico_ChangeControl]
    ON [Dados].[FuncionarioHistorico]([IDFuncionario] ASC, [IDUnidade] ASC, [IDFuncao] ASC, [IDSituacaoFuncionario] ASC, [DataAtualizacaoCargo] ASC, [DataSituacao] ASC, [LotacaoDataInicio] ASC, [Cargo] ASC, [LotacaoCidade] ASC, [LotacaoSigla] ASC, [ParticipanteLotacaoTelefone] ASC, [FuncaoDataInicio] ASC, [ParticipanteEmail] ASC, [Nome] ASC, [IDIndicadorArea] ASC, [DataArquivo] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_FuncionarioHistorico_CuboIndicadores]
    ON [Dados].[FuncionarioHistorico]([IDFuncionario] ASC, [DataArquivo] DESC, [IDUnidade] ASC)
    INCLUDE([IDSituacaoFuncionario]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

