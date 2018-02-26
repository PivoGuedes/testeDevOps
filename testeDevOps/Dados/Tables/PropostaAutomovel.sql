CREATE TABLE [Dados].[PropostaAutomovel] (
    [ID]                            BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]                    BIGINT          NOT NULL,
    [IDClasseBonus]                 TINYINT         NULL,
    [IDClasseFranquia]              TINYINT         NULL,
    [IDTipoSeguro]                  TINYINT         NULL,
    [IDVeiculo]                     INT             NULL,
    [Placa]                         CHAR (8)        NULL,
    [Chassis]                       VARCHAR (18)    NULL,
    [AnoFabricacao]                 SMALLINT        NULL,
    [AnoModelo]                     SMALLINT        NULL,
    [Capacidade]                    TINYINT         NULL,
    [Combustivel]                   VARCHAR (35)    NULL,
    [CodigoSeguradora]              INT             NULL,
    [CodigoSubProduto]              VARCHAR (6)     NULL,
    [NomeCondutor1]                 VARCHAR (100)   NULL,
    [DataNascimentoCondutor1]       DATE            NULL,
    [EstadoCivilCondutor1]          VARCHAR (20)    NULL,
    [SexoCondutor1]                 VARCHAR (9)     NULL,
    [RGCondutor1]                   VARCHAR (20)    NULL,
    [CNHCondutor1]                  VARCHAR (20)    NULL,
    [DataCNHCondutor1]              DATE            NULL,
    [CodigoRelacionamento]          VARCHAR (2)     NULL,
    [NomeCondutor2]                 VARCHAR (100)   NULL,
    [DataNascimentoCondutor2]       DATE            NULL,
    [EstadoCivilCondutor2]          VARCHAR (20)    NULL,
    [SexoCondutor2]                 VARCHAR (9)     NULL,
    [RGCondutor2]                   VARCHAR (20)    NULL,
    [CNHCondutor2]                  VARCHAR (20)    NULL,
    [DataCNHCondutor2]              DATE            NULL,
    [CodigoRelacionamentoCondutor2] VARCHAR (2)     NULL,
    [NumeroApoliceAnterior]         VARCHAR (20)    NULL,
    [QuantidadeParcelas]            TINYINT         NULL,
    [DataInicioVigencia]            DATE            NULL,
    [DataFimVigencia]               DATE            NULL,
    [LastValue]                     BIT             NULL,
    [DataArquivo]                   DATE            NULL,
    [TipoDado]                      VARCHAR (30)    NULL,
    [Arquivo]                       VARCHAR (80)    NULL,
    [ValorPrimeiraParcela]          DECIMAL (19, 2) NULL,
    CONSTRAINT [PK_PropostaAutomovel] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaAutomovel_ClasseBonus] FOREIGN KEY ([IDClasseBonus]) REFERENCES [Dados].[ClasseBonus] ([ID]),
    CONSTRAINT [FK_PropostaAutomovel_ClasseFranquia] FOREIGN KEY ([IDClasseFranquia]) REFERENCES [Dados].[ClasseFranquia] ([ID]),
    CONSTRAINT [FK_PropostaAutomovel_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PropostaAutomovel_TipoSeguro] FOREIGN KEY ([IDTipoSeguro]) REFERENCES [Dados].[TipoSeguro] ([ID]),
    CONSTRAINT [FK_VEICULO_PROPOSTA] FOREIGN KEY ([IDVeiculo]) REFERENCES [Dados].[Veiculo] ([ID]),
    CONSTRAINT [UNQ_PropostaAutomovel_Chassis] UNIQUE NONCLUSTERED ([IDProposta] ASC, [Chassis] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [idx_NCLPropostaAutomovel]
    ON [Dados].[PropostaAutomovel]([IDProposta] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PropostaAutomovel_LastValue]
    ON [Dados].[PropostaAutomovel]([IDProposta] ASC, [LastValue] ASC) WHERE ([LastValue]=(1)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

