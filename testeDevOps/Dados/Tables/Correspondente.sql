CREATE TABLE [Dados].[Correspondente] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [Matricula]            BIGINT        NOT NULL,
    [CPFCNPJ]              VARCHAR (18)  NULL,
    [Nome]                 VARCHAR (140) NULL,
    [IDTipoCorrespondente] TINYINT       NULL,
    [IDUnidade]            SMALLINT      NULL,
    [UF]                   CHAR (2)      NULL,
    [Cidade]               VARCHAR (70)  NULL,
    [NomeArquivo]          VARCHAR (100) NOT NULL,
    [DataArquivo]          DATE          NULL,
    [MatriculaErrada]      BIGINT        NULL,
    [Endereco]             VARCHAR (200) NULL,
    [Municipio]            VARCHAR (50)  NULL,
    [Bairro]               VARCHAR (100) NULL,
    [Complemento]          VARCHAR (200) NULL,
    [Email]                VARCHAR (200) NULL,
    [CEP]                  VARCHAR (10)  NULL,
    [DDD]                  VARCHAR (3)   NULL,
    [Telefone]             VARCHAR (15)  NULL,
    [DDDFAX]               VARCHAR (3)   NULL,
    [FAX]                  VARCHAR (15)  NULL,
    [Equipe]               INT           NULL,
    [NomeEquipe]           VARCHAR (100) NULL,
    [RamoAtividade]        INT           NULL,
    [ICSituacao]           CHAR (2)      NULL,
    [NUClasse]             VARCHAR (5)   NULL,
    [TipoCorrespondente]   VARCHAR (30)  NULL,
    CONSTRAINT [PK_Correspondente] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Correspontente_TipoCorrespondente] FOREIGN KEY ([IDTipoCorrespondente]) REFERENCES [Dados].[TipoCorrespondente] ([ID]),
    CONSTRAINT [FK_Correspontente_Unidade] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [UNQ_Correspondente] UNIQUE NONCLUSTERED ([Matricula] ASC, [CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_CorrespondenteSAFCBN]
    ON [Dados].[Correspondente]([Matricula] ASC, [IDTipoCorrespondente] ASC) WHERE ([IDTipoCorrespondente]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

