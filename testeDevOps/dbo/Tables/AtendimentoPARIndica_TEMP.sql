CREATE TABLE [dbo].[AtendimentoPARIndica_TEMP] (
    [ID]                     INT             NOT NULL,
    [Protocolo]              VARCHAR (20)    NULL,
    [NomeCliente]            VARCHAR (150)   NULL,
    [CPF]                    VARCHAR (18)    NOT NULL,
    [NumeroProposta]         VARCHAR (20)    NULL,
    [ValorPremioFinal]       DECIMAL (18, 6) NULL,
    [ValorPremioSemDesconto] DECIMAL (18, 6) NULL,
    [DataNascimento]         DATE            NULL,
    [DataProposta]           DATE            NULL,
    [NomeArquivo]            VARCHAR (100)   NULL,
    [IDFenae]                INT             NULL,
    [DataArquivo]            DATE            NULL,
    [NumeroPropostaTratado]  AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroProposta]))) PERSISTED
);


GO
CREATE CLUSTERED INDEX [idx_CL_AtendimentoPARIndica_TEMP]
    ON [dbo].[AtendimentoPARIndica_TEMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_AtendimentoPARIndica_TEMP]
    ON [dbo].[AtendimentoPARIndica_TEMP]([NumeroPropostaTratado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

