CREATE TABLE [Dados].[filialfaturamento_Backup_guedes] (
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
    [idempresa]       SMALLINT     NULL
);

