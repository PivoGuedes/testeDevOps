CREATE TABLE [Marketing].[Prorej] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [IdProposta]   BIGINT        NOT NULL,
    [IDCliente]    BIGINT        NOT NULL,
    [IdAgencia]    SMALLINT      NOT NULL,
    [IdTipoErro]   INT           NOT NULL,
    [EndossoProv]  VARCHAR (5)   NULL,
    [CdCorretor]   INT           NULL,
    [DtRecusa]     DATE          NULL,
    [ApoliceProv]  VARCHAR (20)  NULL,
    [Recusa]       VARCHAR (20)  NULL,
    [CdCorretorVC] INT           NULL,
    [Mensagem]     VARCHAR (200) NULL,
    [Descricao]    VARCHAR (150) NULL,
    [DataArquivo]  DATE          NULL,
    CONSTRAINT [PK_Prorej] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agencia_Prorej] FOREIGN KEY ([IdAgencia]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Cliente_Prorej] FOREIGN KEY ([IDCliente]) REFERENCES [Dados].[PropostaCliente] ([ID]),
    CONSTRAINT [FK_Proposta_Prorej] FOREIGN KEY ([IdProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_TipoErro_Prorej] FOREIGN KEY ([IdTipoErro]) REFERENCES [Marketing].[TipoErro] ([ID])
);

