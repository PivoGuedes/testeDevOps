CREATE TABLE [dbo].[PropostasConciergeTemp] (
    [PropostaFctApolice]       VARCHAR (50)    NULL,
    [PropostaOds]              VARCHAR (20)    NOT NULL,
    [NuPropostaSIAS]           VARCHAR (20)    COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [FimVigenciaFctapolice]    DATE            NULL,
    [DataFimVigencia]          DATE            NULL,
    [InicioVigenciaFctApolice] DATE            NULL,
    [DataInicioVigencia]       DATE            NULL,
    [PremioODS]                NUMERIC (16, 2) NULL,
    [PremioFctapolice]         DECIMAL (19, 2) NOT NULL
);

