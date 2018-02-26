﻿CREATE TABLE [dbo].[TOP_SP] (
    [SP_NOME]    VARCHAR (20) CONSTRAINT [TOP_SP_SP_NOME_DF] DEFAULT ('                    ') NOT NULL,
    [SP_VERSAO]  VARCHAR (20) CONSTRAINT [TOP_SP_SP_VERSAO_DF] DEFAULT ('                    ') NOT NULL,
    [SP_DATA]    VARCHAR (8)  CONSTRAINT [TOP_SP_SP_DATA_DF] DEFAULT ('        ') NOT NULL,
    [SP_HORA]    VARCHAR (8)  CONSTRAINT [TOP_SP_SP_HORA_DF] DEFAULT ('        ') NOT NULL,
    [SP_ASSINAT] VARCHAR (3)  CONSTRAINT [TOP_SP_SP_ASSINAT_DF] DEFAULT ('   ') NOT NULL
) ON [PRIMARY];
