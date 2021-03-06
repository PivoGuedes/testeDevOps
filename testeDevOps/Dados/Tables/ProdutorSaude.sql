﻿CREATE TABLE [Dados].[ProdutorSaude] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Codigo] INT          NULL,
    [Nome]   VARCHAR (60) NULL,
    CONSTRAINT [PK_PRODUTORSAUDE] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [AK_UNQ_PRODUTOR_PRODUTORSAUDE] UNIQUE NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

