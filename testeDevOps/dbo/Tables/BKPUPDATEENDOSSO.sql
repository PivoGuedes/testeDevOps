CREATE TABLE [dbo].[BKPUPDATEENDOSSO] (
    [id]             BIGINT       NOT NULL,
    [NumeroProposta] VARCHAR (20) NOT NULL,
    [IDErrada]       BIGINT       NOT NULL,
    [DataEmissao]    DATE         NULL,
    [NumeroEndosso]  INT          NOT NULL,
    [IDEndosso]      BIGINT       NOT NULL
);

