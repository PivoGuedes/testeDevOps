CREATE TABLE [Indicadores].[Funcionarios_tmp] (
    [Matricula]             VARCHAR (20)  NULL,
    [CPF]                   CHAR (14)     NULL,
    [Nome]                  VARCHAR (100) NULL,
    [DataInicioFuncao]      DATE          NULL,
    [Cargo]                 VARCHAR (100) NULL,
    [DataAtualizacaoFuncao] DATE          NULL,
    [IndicadorArea]         TINYINT       NULL,
    [LotacaoCidade]         VARCHAR (60)  NULL,
    [LotacaoUF]             VARCHAR (4)   NULL,
    [LotacaoUnidade]        SMALLINT      NOT NULL,
    [Data]                  DATE          NOT NULL,
    [IDSituacaoFuncionario] SMALLINT      NULL
);

