CREATE TABLE [ControleDados].[LogSTATP2] (
    [ID]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [NumeroProposta]        VARCHAR (20)    NOT NULL,
    [NumeroContrato]        VARCHAR (20)    NULL,
    [DataInicioVigencia]    DATE            NULL,
    [DataFimVigencia]       DATE            NULL,
    [ValorPremioTotal]      DECIMAL (19, 2) NULL,
    [Ocorrencia]            VARCHAR (MAX)   NULL,
    [DataHoraProcessamento] DATETIME        CONSTRAINT [DF_LogSTATP2_DataHoraProcessamento] DEFAULT (getdate()) NOT NULL,
    [DataArquivo]           DATE            NOT NULL,
    [NomeArquivo]           VARCHAR (100)   NOT NULL,
    CONSTRAINT [PK_LogSTATP2_1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [PK_LogSTATP2] UNIQUE NONCLUSTERED ([NumeroProposta] ASC, [DataArquivo] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

