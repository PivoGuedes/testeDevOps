CREATE TABLE [dbo].[SIMULACOES_TO_DELETE] (
    [NumeroCalculo]     FLOAT (53)     NULL,
    [CPFCNPJ]           NVARCHAR (255) NULL,
    [IdSituacaoCalculo] FLOAT (53)     NULL,
    [DataArquivo]       DATETIME       NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_simu_temp]
    ON [dbo].[SIMULACOES_TO_DELETE]([NumeroCalculo] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

