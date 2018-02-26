CREATE TABLE [Dados].[FuncionarioCAIXA] (
    [Id]                            BIGINT        IDENTITY (1, 1) NOT NULL,
    [cUsuario]                      VARCHAR (7)   NOT NULL,
    [cMatricula]                    VARCHAR (6)   NOT NULL,
    [cMatricula_Digito_Verificador] VARCHAR (1)   NOT NULL,
    [vNome_Empregado]               VARCHAR (150) NULL,
    [iCGC_Lotacao]                  INT           NOT NULL,
    [iCGC_Lotacao_Fisica]           INT           NOT NULL,
    [dData_Nascimento]              DATE          NULL,
    [dData_Admissao]                DATE          NOT NULL,
    [iCodigo_Funcao_Comissionada]   INT           NULL,
    [vNome_Funcao_Comissionada]     VARCHAR (150) NULL,
    [iAinda_Nao_Sei]                SMALLINT      NULL,
    [cE_Funcionario_Desligado]      CHAR (1)      NULL,
    [dData_Desligamento]            DATE          NULL,
    [cE_Marcado_Absenteismo_Cedido] CHAR (1)      NULL,
    [NomeArquivo]                   VARCHAR (100) NOT NULL,
    [DataArquivo]                   DATE          NOT NULL,
    CONSTRAINT [PK_ID_FuncionarioCAIXA] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

