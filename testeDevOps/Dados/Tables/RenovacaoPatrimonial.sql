CREATE TABLE [Dados].[RenovacaoPatrimonial] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [DataArquivo]           DATE          NULL,
    [NomeArquivo]           VARCHAR (200) NULL,
    [ControleVersao]        VARCHAR (200) NULL,
    [Processo_SUSEP]        VARCHAR (200) NULL,
    [Numero_Apolice]        VARCHAR (50)  NULL,
    [Nome_Produto]          VARCHAR (200) NULL,
    [Codigo_Produto]        VARCHAR (50)  NULL,
    [Codigo_Ramo]           VARCHAR (50)  NULL,
    [Data_Emissao]          VARCHAR (200) NULL,
    [Apolice_Renovada]      VARCHAR (200) NULL,
    [Numero_Proposta]       VARCHAR (200) NULL,
    [Data_Proposta]         VARCHAR (200) NULL,
    [Inicio_Vigencia]       VARCHAR (200) NULL,
    [Fim_Vigencia]          VARCHAR (200) NULL,
    [Razao_Social]          VARCHAR (200) NULL,
    [CNPJ]                  VARCHAR (200) NULL,
    [DataHoraProcessamento] DATE          CONSTRAINT [DF__Renovacao__DataH__4BE319BF] DEFAULT (getdate()) NULL,
    [DataEmissaoDate]       AS            ((((substring([Data_Emissao],(7),(4))+'-')+substring([Data_Emissao],(4),(2)))+'-')+substring([Data_Emissao],(1),(2))),
    CONSTRAINT [PK_RenovacaoPatrimonial] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [IDX_CL_RenovacaoPatrimonial]
    ON [Dados].[RenovacaoPatrimonial]([Numero_Apolice] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

