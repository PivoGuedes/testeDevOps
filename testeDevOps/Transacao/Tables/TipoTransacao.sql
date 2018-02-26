CREATE TABLE [Transacao].[TipoTransacao] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [IDGrupoTransacao] INT           NOT NULL,
    [Codigo]           INT           NOT NULL,
    [Prioridade]       INT           NOT NULL,
    [JanelaInicio]     INT           DEFAULT ((0)) NOT NULL,
    [JanelaFim]        INT           DEFAULT ((7)) NOT NULL,
    [Descricao]        VARCHAR (200) NOT NULL,
    [FlTipoCliente]    BIT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TIPOTRANSACAO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GrupoTransacao] FOREIGN KEY ([IDGrupoTransacao]) REFERENCES [Transacao].[GrupoTipoTransacao] ([ID])
);

