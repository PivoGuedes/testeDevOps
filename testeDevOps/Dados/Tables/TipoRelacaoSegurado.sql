﻿CREATE TABLE [Dados].[TipoRelacaoSegurado] (
    [ID]           TINYINT      IDENTITY (1, 1) NOT NULL,
    [Descricao]    VARCHAR (60) NOT NULL,
    [DataCadastro] DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TipoRelacaoSegurado_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

