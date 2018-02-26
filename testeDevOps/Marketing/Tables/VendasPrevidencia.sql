CREATE TABLE [Marketing].[VendasPrevidencia] (
    [Codigo]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]            BIGINT          NOT NULL,
    [IDUnidade]             SMALLINT        NOT NULL,
    [SobrevidaContratadoPm] DECIMAL (18, 2) NULL,
    [RiscoContratadoPm]     DECIMAL (18, 2) NULL,
    [SobrevidaContratadoPu] DECIMAL (18, 2) NULL,
    [RiscoContratadoPu]     DECIMAL (18, 2) NULL,
    [Prazo]                 INT             NULL,
    [RendaParticipante]     INT             NULL,
    [DtEmissao]             DATE            NULL,
    CONSTRAINT [PK_VendasPrevidencia] PRIMARY KEY CLUSTERED ([Codigo] ASC),
    CONSTRAINT [FK_PropostaVendasPrevidencia] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_UnidadeVendasPrevidencia] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID])
);

