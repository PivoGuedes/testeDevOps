CREATE TABLE [dbo].[propostaPS] (
    [NumeroProposta]          VARCHAR (20)    NOT NULL,
    [ID]                      BIGINT          NOT NULL,
    [PropostaSemCanal]        VARCHAR (26)    NULL,
    [NumeroPropostaTratado]   VARCHAR (17)    NULL,
    [DataProposta]            DATE            NULL,
    [ValorPremioBrutoEmissao] NUMERIC (16, 2) NULL,
    [CPFCNPJ]                 VARCHAR (8000)  NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_ps]
    ON [dbo].[propostaPS]([NumeroPropostaTratado] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_PrpIDCanal]
    ON [dbo].[propostaPS]([ID] ASC)
    INCLUDE([NumeroPropostaTratado], [PropostaSemCanal], [NumeroProposta]) WITH (FILLFACTOR = 90);

