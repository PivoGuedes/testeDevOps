﻿CREATE TABLE [ControleDados].[LogDMDB13Riscos] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [DataGravacao]            DATETIME2 (7) NOT NULL,
    [DataRestore]             DATETIME2 (7) NULL,
    [NomeArquivo]             VARCHAR (100) NOT NULL,
    [ProcessouArquivo]        BIT           NOT NULL,
    [DataFimProcessamento]    DATETIME2 (7) NULL,
    [DataInicioProcessamento] DATETIME2 (7) NULL,	
	[Teste]					BIT NULL,
	[TESTE2] bit null,
	[TESTE3] bit null
);

