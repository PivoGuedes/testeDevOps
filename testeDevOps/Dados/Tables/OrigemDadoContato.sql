CREATE TABLE [Dados].[OrigemDadoContato] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [OrigemDado] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

