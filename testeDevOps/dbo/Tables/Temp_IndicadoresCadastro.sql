CREATE TABLE [dbo].[Temp_IndicadoresCadastro] (
    [Coluna 0]                 VARCHAR (150) NULL,
    [MATRÍCULA]                VARCHAR (150) NULL,
    [NOME]                     VARCHAR (150) NULL,
    [ADMISSÃO]                 VARCHAR (150) NULL,
    [DESLIG ]                  VARCHAR (150) NULL,
    [CPF]                      VARCHAR (150) NULL,
    [SEXO]                     VARCHAR (150) NULL,
    [LOTACAO NO AJUIZAMENTO]   VARCHAR (150) NULL,
    [FUNCAO NO AJUIZAMENTO]    VARCHAR (150) NULL,
    [TOTAL LÍQUIDO  REPASSADO] VARCHAR (150) NULL,
    [MatriculaM]               AS            (right('00000'+[Matrícula],(8)))
);

