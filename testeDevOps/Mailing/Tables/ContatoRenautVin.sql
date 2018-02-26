CREATE TABLE [Mailing].[ContatoRenautVin] (
    [Nome]    VARCHAR (300) NULL,
    [CPFCNPJ] VARCHAR (50)  NULL,
    [DDD]     INT           NULL,
    [FONE]    BIGINT        NULL
);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_contatorenautvin]
    ON [Mailing].[ContatoRenautVin]([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

