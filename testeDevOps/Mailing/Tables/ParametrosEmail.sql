CREATE TABLE [Mailing].[ParametrosEmail] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Campanha]        VARCHAR (100) NULL,
    [Assunto]         VARCHAR (500) NULL,
    [Corpo]           VARCHAR (MAX) NULL,
    [Destinatarios]   VARCHAR (MAX) NULL,
    [DestinatariosCC] VARCHAR (MAX) NULL,
    [DataReferencia]  DATE          NULL,
    [Empresa]         VARCHAR (100) NULL,
    [Ativo]           BIT           NULL,
    CONSTRAINT [PK_ParametrosEmail] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

