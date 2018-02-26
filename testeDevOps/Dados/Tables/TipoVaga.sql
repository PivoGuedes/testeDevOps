﻿CREATE TABLE [Dados].[TipoVaga] (
    [Id]        INT           NOT NULL,
    [Descricao] NVARCHAR (50) NULL,
    CONSTRAINT [PK_TipoVaga] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

