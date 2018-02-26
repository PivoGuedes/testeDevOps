CREATE TABLE [dbo].[FuncionarioSituacaoPROPAY_TEMP] (
    [CodigoEmpresaPropay]   VARCHAR (10)    NULL,
    [MatriculaTratada]      VARCHAR (20)    NULL,
    [Matricula]             VARCHAR (20)    NULL,
    [DataNascimentoTratada] DATE            NULL,
    [DataNascimento]        VARCHAR (20)    NULL,
    [SexoCodigo]            TINYINT         NULL,
    [Sexo]                  VARCHAR (20)    NULL,
    [Nome]                  VARCHAR (150)   NULL,
    [PIS]                   VARCHAR (30)    NULL,
    [Situacao]              VARCHAR (100)   NULL,
    [DataSituacaoTratada]   DATE            NULL,
    [DataSituacao]          VARCHAR (20)    NULL,
    [DataAdmissaoTratada]   DATE            NULL,
    [DataAdmissao]          VARCHAR (20)    NULL,
    [BancoAgenciaCCorrente] VARCHAR (100)   NULL,
    [GrupoHierarquico]      VARCHAR (100)   NULL,
    [CodigoCargo]           VARCHAR (30)    NULL,
    [DescricaoCargo]        VARCHAR (130)   NULL,
    [CodigoCentroCusto]     VARCHAR (30)    NULL,
    [DescricaoCentroCusto]  VARCHAR (130)   NULL,
    [SalarioTratado]        DECIMAL (13, 2) NULL,
    [DataArquivo]           DATE            NULL,
    [CodigoOcupacao]        VARCHAR (7)     NULL,
    [NomeArquivo]           VARCHAR (100)   NOT NULL,
    [ORDEM]                 VARCHAR (10)    NULL
);


GO
CREATE CLUSTERED INDEX [idxMatricula_FuncionarioSituacaoPROPAY_TEMP]
    ON [dbo].[FuncionarioSituacaoPROPAY_TEMP]([MatriculaTratada] ASC) WITH (FILLFACTOR = 90);

