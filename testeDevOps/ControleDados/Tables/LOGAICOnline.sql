CREATE TABLE [ControleDados].[LOGAICOnline] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [nomearquivo] VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

