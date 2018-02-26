CREATE TABLE [Dados].[FinanciamentoCliente] (
    [ID]                          INT           IDENTITY (1, 1) NOT NULL,
    [IDFinanciamentoAuto]         INT           NULL,
    [IDFinanciamentoHabitacional] INT           NULL,
    [Nome]                        VARCHAR (60)  NULL,
    [CPF]                         VARCHAR (14)  NOT NULL,
    [DataNacimento]               DATE          NULL,
    [Endereco]                    VARCHAR (70)  NULL,
    [Complemento]                 VARCHAR (30)  NULL,
    [Cidade]                      VARCHAR (50)  NULL,
    [UF]                          VARCHAR (2)   NULL,
    [CEP]                         VARCHAR (13)  NULL,
    [DDD]                         VARCHAR (4)   NULL,
    [Telefone]                    VARCHAR (10)  NULL,
    [Sexo]                        CHAR (1)      NULL,
    [EstadoCivil]                 VARCHAR (30)  NULL,
    [NomeArquivo]                 VARCHAR (150) NOT NULL,
    [DataArquivo]                 DATE          NOT NULL,
    CONSTRAINT [pk_Financiamento_Cliente_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [fk_FinciamentoAuto_ID] FOREIGN KEY ([IDFinanciamentoAuto]) REFERENCES [Dados].[FinanciamentoAuto] ([ID]),
    CONSTRAINT [fk_FinciamentoHabitacional_ID] FOREIGN KEY ([IDFinanciamentoHabitacional]) REFERENCES [Dados].[FinanciamentoHabitacional] ([ID])
);

