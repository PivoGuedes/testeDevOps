CREATE TABLE [dbo].[propostaPSM] (
    [ID]                      BIGINT          NOT NULL,
    [NumeroPropostaTratado]   VARCHAR (17)    NULL,
    [NumeroProposta]          VARCHAR (20)    NOT NULL,
    [DataProposta]            DATE            NULL,
    [ValorPremioBrutoEmissao] NUMERIC (16, 2) NOT NULL,
    [CPFCNPJ]                 VARCHAR (18)    NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_psm]
    ON [dbo].[propostaPSM]([NumeroPropostaTratado] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_PrpIDCanalM]
    ON [dbo].[propostaPSM]([ID] ASC)
    INCLUDE([NumeroPropostaTratado], [NumeroProposta]) WITH (FILLFACTOR = 90);

