CREATE TABLE [dbo].[PAR_2015_vida_runoff2] (
    [Num Apolice]                   BIGINT        NULL,
    [Produtor]                      VARCHAR (255) NULL,
    [Código do Produto]             SMALLINT      NULL,
    [Código do Subgrupo do Produto] SMALLINT      NULL,
    [Num Endosso Comissao]          INT           NULL,
    [Numero Recibo Comissao]        BIGINT        NULL,
    [Data Recibo]                   DATETIME      NULL,
    [Valor Comissao]                DECIMAL (28)  NULL,
    [NumeroContrato]                VARCHAR (24)  NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_Apolice]
    ON [dbo].[PAR_2015_vida_runoff2]([NumeroContrato] ASC, [Numero Recibo Comissao] ASC, [Num Endosso Comissao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

