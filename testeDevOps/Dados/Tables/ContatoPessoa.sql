﻿CREATE TABLE [Dados].[ContatoPessoa] (
    [ID]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [CPFCNPJ]        VARCHAR (20)  NOT NULL,
    [DataSistema]    DATETIME2 (7) DEFAULT (getdate()) NULL,
    [Nome]           VARCHAR (200) NULL,
    [DataNascimento] DATE          NULL,
    [CPFCNPJ_AS]     AS            ([CPFCNPJ] collate SQL_Latin1_General_CP1_CS_AS),
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_ContatoPessoa_CPFCNPJ] UNIQUE NONCLUSTERED ([CPFCNPJ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_ContatoPessoa_CPFCNPJ_AS]
    ON [Dados].[ContatoPessoa]([CPFCNPJ_AS] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

