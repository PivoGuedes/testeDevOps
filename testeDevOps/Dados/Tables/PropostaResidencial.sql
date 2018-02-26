CREATE TABLE [Dados].[PropostaResidencial] (
    [ID]                           INT             IDENTITY (1, 1) NOT NULL,
    [IDProposta]                   BIGINT          NULL,
    [IDTipoMoradia]                TINYINT         NULL,
    [IDTipoOcupacao]               TINYINT         NULL,
    [IDTipoSeguro]                 TINYINT         NULL,
    [NumeroApoliceAnterior]        VARCHAR (20)    NULL,
    [NumeroVersao]                 SMALLINT        NULL,
    [DescontoFidelidade]           DECIMAL (8, 4)  NULL,
    [DescontoAgrupCobertura]       DECIMAL (8, 4)  NULL,
    [DescontoExperiencia]          DECIMAL (8, 4)  NULL,
    [DescontoFuncionarioPublico]   DECIMAL (8, 4)  NULL,
    [ValorPremioLiquido]           DECIMAL (19, 2) NULL,
    [ValorPremioTotal]             DECIMAL (19, 2) NULL,
    [ValorAdicionalFracionamento]  DECIMAL (19, 2) NULL,
    [ValorCustoApolice]            REAL            NULL,
    [ValorIOF]                     REAL            NULL,
    [ValorDescAgrupCobertura]      AS              ([DescontoAgrupCobertura]*[ValorPremioLiquido]),
    [QuantidadeParcelas]           TINYINT         NULL,
    [ValorPrimeiraParcela]         DECIMAL (10, 2) NULL,
    [ValorDemaisParcelas]          DECIMAL (10, 2) NULL,
    [IndicadorRenovacaoAutomatica] BIT             NULL,
    [LastValue]                    BIT             CONSTRAINT [DF_PropostaResidencial_LastValue] DEFAULT ((0)) NULL,
    [DataArquivo]                  DATE            NULL,
    [Arquivo]                      VARCHAR (100)   NULL,
    CONSTRAINT [PK_PropostaResidencial] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaResidencial_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PropostaResidencial_TipoMoradia] FOREIGN KEY ([IDTipoMoradia]) REFERENCES [Dados].[TipoMoradia] ([ID]),
    CONSTRAINT [FK_PropostaResidencial_TipoOcupacao] FOREIGN KEY ([IDTipoOcupacao]) REFERENCES [Dados].[TipoOcupacao] ([ID]),
    CONSTRAINT [FK_PropostaResidencial_TipoSeguro] FOREIGN KEY ([IDTipoSeguro]) REFERENCES [Dados].[TipoSeguro] ([ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDX_UNQ_PropostaResidencial_VersaoDataArquivo]
    ON [Dados].[PropostaResidencial]([IDProposta] ASC, [NumeroVersao] ASC, [DataArquivo] ASC, [ValorPremioTotal] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PropostaResidencial_LastValue]
    ON [Dados].[PropostaResidencial]([IDProposta] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

