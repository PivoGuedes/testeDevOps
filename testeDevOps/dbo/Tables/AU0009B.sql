CREATE TABLE [dbo].[AU0009B] (
    [EndossoContrato] VARCHAR (9)     NULL,
    [NumeroApolice]   NVARCHAR (4000) NULL,
    [Parcela]         VARCHAR (3)     NULL,
    [Operacao]        VARCHAR (4)     NULL,
    [Endosso]         AS              (CONVERT([int],[EndossoContrato])) PERSISTED,
    [Apolice]         AS              (CONVERT([varchar](24),CONVERT([bigint],[NumeroApolice]))) PERSISTED
);


GO
CREATE CLUSTERED INDEX [cl_idx_endossocontrato]
    ON [dbo].[AU0009B]([Apolice] ASC, [Endosso] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

