CREATE TABLE [Dados].[FilialFaturamento] (
    [ID]              SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Codigo]          SMALLINT     NOT NULL,
    [Nome]            VARCHAR (50) NULL,
    [Cidade]          VARCHAR (80) NULL,
    [RetemIR]         BIT          NULL,
    [BaseISS]         CHAR (1)     NULL,
    [IBGE]            DECIMAL (8)  NULL,
    [RangeCEPInicio1] BIGINT       NULL,
    [RangeCEPFim1]    BIGINT       NULL,
    [RangeCEPInicio2] BIGINT       NULL,
    [RangeCEPFim2]    BIGINT       NULL,
    [idempresa]       SMALLINT     NULL,
    CONSTRAINT [PK_KEY_1_FILIALPR] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [CKC_BASEISS_FILIALFA] CHECK ([BaseISS] IS NULL OR ([BaseISS]='R' OR [BaseISS]='T')),
    CONSTRAINT [fk_IDFilialFaturamento_IDEmpresa] FOREIGN KEY ([idempresa]) REFERENCES [Dados].[Empresa] ([ID]),
    CONSTRAINT [AK_UNQ_FILIALPROPOSTA_FILIALFA] UNIQUE NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

