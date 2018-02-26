CREATE TABLE [Transacao].[DmCCA] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [CdCCA]         INT           NOT NULL,
    [CdCCACliente]  VARCHAR (20)  NOT NULL,
    [NmCCA]         VARCHAR (300) NOT NULL,
    [NmCCASegmento] VARCHAR (200) NULL,
    CONSTRAINT [PK_DmCCA] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

