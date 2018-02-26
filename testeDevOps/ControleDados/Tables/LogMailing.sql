CREATE TABLE [ControleDados].[LogMailing] (
    [ID]                     INT           IDENTITY (1, 1) NOT NULL,
    [DataRefMailing]         DATE          NOT NULL,
    [QtdRegistros]           INT           NOT NULL,
    [NomeArquivo]            VARCHAR (100) NOT NULL,
    [Empresa]                VARCHAR (100) NOT NULL,
    [Campanha]               VARCHAR (100) NOT NULL,
    [Enviado]                BIT           CONSTRAINT [DF_LogMailingFlex_Enviado] DEFAULT ((0)) NOT NULL,
    [DataHoraSistema]        DATETIME2 (7) DEFAULT (getdate()) NULL,
    [QuantidadeEconomiarios] INT           NULL,
    [QuantidadeMotos]        INT           NULL,
    [TextoVariavel]          VARCHAR (800) NULL,
    CONSTRAINT [PK_LogMailingFlex] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_UNQ_NCL_LogMailing]
    ON [ControleDados].[LogMailing]([DataRefMailing] ASC, [Campanha] ASC, [Empresa] ASC, [NomeArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

