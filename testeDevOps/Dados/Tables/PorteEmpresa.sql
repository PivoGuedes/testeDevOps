﻿CREATE TABLE [Dados].[PorteEmpresa] (
    [ID]        TINYINT      NOT NULL,
    [Descricao] VARCHAR (30) NULL,
    CONSTRAINT [PK_PORTEEMPRESA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

