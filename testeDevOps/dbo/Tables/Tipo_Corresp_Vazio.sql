﻿CREATE TABLE [dbo].[Tipo_Corresp_Vazio] (
    [CODIGO   ] NVARCHAR (50) NOT NULL,
    CONSTRAINT [pk_codigo_vazio] PRIMARY KEY CLUSTERED ([CODIGO   ] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

