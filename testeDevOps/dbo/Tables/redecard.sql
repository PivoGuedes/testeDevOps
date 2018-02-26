CREATE TABLE [dbo].[redecard] (
    [COD_SN]        FLOAT (53)     NULL,
    [SG_SN]         NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [SG_SR]         FLOAT (53)     NULL,
    [NOME_SR]       NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [ANOMES]        NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [CNPJCPF]       NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [PV]            BIGINT         NULL,
    [COD_AGENCIA]   NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [DT_INSTALACAO] NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [CREDENCIADORA] NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
    [dataarquivo]   DATETIME       NOT NULL,
    [nomearquivo]   VARCHAR (8)    NOT NULL
);

