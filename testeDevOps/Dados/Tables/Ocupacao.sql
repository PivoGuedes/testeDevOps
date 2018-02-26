﻿CREATE TABLE [Dados].[Ocupacao] (
    [Codigo]    VARCHAR (7)   NOT NULL,
    [Descricao] VARCHAR (160) NULL,
    CONSTRAINT [PK_Ocupacao] PRIMARY KEY CLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

