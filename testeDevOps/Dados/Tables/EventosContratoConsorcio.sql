CREATE TABLE [Dados].[EventosContratoConsorcio] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [IDContrato]               INT             NOT NULL,
    [IDUnidade]                INT             NULL,
    [NUMERO_GRUPO]             INT             NULL,
    [NUMERO_COTA]              INT             NULL,
    [NUMERO_VERSAO]            INT             NULL,
    [DATA_EVENTO]              DATE            NULL,
    [VALOR_EVENTO_PARCELA]     DECIMAL (19, 2) NULL,
    [VALOR_CREDITO_ATUALIZADO] DECIMAL (19, 2) NULL,
    [BRANCOS]                  VARCHAR (300)   NULL,
    [NomeArquivo]              VARCHAR (200)   NULL,
    [DataArquivo]              DATE            NULL,
    [IDTipoEvento]             INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_EventosContratoConsorcio_TipoEvento] FOREIGN KEY ([IDTipoEvento]) REFERENCES [Dados].[TipoEventoConsorcio] ([ID])
);

