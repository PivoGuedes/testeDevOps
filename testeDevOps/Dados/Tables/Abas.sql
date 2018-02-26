﻿CREATE TABLE [Dados].[Abas] (
    [ID]        TINYINT      IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Aba] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);
