CREATE TABLE [Dados].[PremiacaoCorrespondente] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProdutor]          INT             NOT NULL,
    [IDOperacao]          TINYINT         NOT NULL,
    [IDCorrespondente]    INT             NOT NULL,
    [IDFilialFaturamento] SMALLINT        NULL,
    [NumeroRecibo]        BIGINT          NULL,
    [IDContrato]          BIGINT          NULL,
    [IDProposta]          BIGINT          NULL,
    [NumeroEndosso]       BIGINT          NULL,
    [NumeroParcela]       SMALLINT        NULL,
    [NumeroBilhete]       VARCHAR (20)    NULL,
    [Grupo]               BIGINT          NULL,
    [Cota]                BIGINT          NULL,
    [ValorCorretagem]     DECIMAL (19, 2) NULL,
    [DataProcessamento]   DATE            NULL,
    [NumeroContrato]      VARCHAR (20)    NULL,
    [NumeroProposta]      VARCHAR (20)    NULL,
    [Arquivo]             VARCHAR (80)    NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    [IDTipoProduto]       TINYINT         NOT NULL,
    [Observacao]          VARCHAR (500)   NULL,
    [AnoMes]              VARCHAR (6)     NULL,
    CONSTRAINT [PK_PremiacaoCorrespondente] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PremiacaoCorrespondente_ComissaoOperacao] FOREIGN KEY ([IDOperacao]) REFERENCES [Dados].[ComissaoOperacao] ([ID]),
    CONSTRAINT [FK_PremiacaoCorrespondente_Contrato] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_PremiacaoCorrespondente_Correspondente] FOREIGN KEY ([IDCorrespondente]) REFERENCES [Dados].[Correspondente] ([ID]),
    CONSTRAINT [FK_PremiacaoCorrespondente_FilialFaturamento] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [FK_PremiacaoCorrespondente_Produtor] FOREIGN KEY ([IDProdutor]) REFERENCES [Dados].[Produtor] ([ID]),
    CONSTRAINT [FK_PremiacaoCorrespondente_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_TipoProduto_PremiacaoCorrespondente] FOREIGN KEY ([IDTipoProduto]) REFERENCES [Dados].[TipoProduto] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_PremiacaoCorrespondente]
    ON [Dados].[PremiacaoCorrespondente]([IDContrato] ASC, [IDProposta] ASC, [NumeroParcela] ASC, [IDProdutor] ASC, [IDOperacao] ASC, [IDCorrespondente] ASC, [DataArquivo] ASC, [Grupo] ASC, [Cota] ASC) WHERE ([Arquivo]<>'CORREÇÃO MANUAL OUVIDORIA CEF - 2015-09-21') WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoCorrespondente_IDProposta]
    ON [Dados].[PremiacaoCorrespondente]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_PremiacaoCorrespondente_IDOperacao]
    ON [Dados].[PremiacaoCorrespondente]([IDOperacao] ASC)
    INCLUDE([IDProdutor], [IDCorrespondente], [IDFilialFaturamento], [ValorCorretagem], [Arquivo], [DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

