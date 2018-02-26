CREATE TABLE [Dados].[RePremiacaoCorrespondente] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [IDProdutor]             INT             NOT NULL,
    [IDCorrespondente]       INT             NOT NULL,
    [IDFilialFaturamento]    SMALLINT        NULL,
    [Cidade]                 VARCHAR (70)    NULL,
    [UF]                     CHAR (2)        NULL,
    [ValorCorretagem]        DECIMAL (38, 2) NULL,
    [DataCompetencia]        DATE            NOT NULL,
    [LoteImportacaoPROTHEUS] VARCHAR (6)     NULL,
    [ItemImportacaoPROTHEUS] VARCHAR (6)     NULL,
    [DataProcessamento]      DATETIME        NULL,
    [Status]                 VARCHAR (25)    NULL,
    [IDTipoProduto]          TINYINT         NOT NULL,
    [Observacao]             VARCHAR (500)   NULL,
    CONSTRAINT [PK_RePremiacaoCorrespondente] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_RePremiacaoCorrespondente_Correspondente] FOREIGN KEY ([IDCorrespondente]) REFERENCES [Dados].[Correspondente] ([ID]),
    CONSTRAINT [FK_RePremiacaoCorrespondente_FilialFaturamento] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [FK_RePremiacaoCorrespondente_Produtor] FOREIGN KEY ([IDProdutor]) REFERENCES [Dados].[Produtor] ([ID]),
    CONSTRAINT [FK_TipoProduto_RepremiacaoCorrespondente] FOREIGN KEY ([IDTipoProduto]) REFERENCES [Dados].[TipoProduto] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNQ_NCL_RePremiacaoCorrespondente]
    ON [Dados].[RePremiacaoCorrespondente]([IDProdutor] ASC, [IDCorrespondente] ASC, [IDTipoProduto] ASC, [IDFilialFaturamento] ASC, [DataCompetencia] ASC) WHERE ([id]<(90188) AND [id]>(90379)) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RePremiacaoCorrespondente_DataCompetencia_IDTipoProduto]
    ON [Dados].[RePremiacaoCorrespondente]([DataCompetencia] ASC, [IDTipoProduto] ASC)
    INCLUDE([ID], [IDCorrespondente], [ValorCorretagem], [LoteImportacaoPROTHEUS], [ItemImportacaoPROTHEUS], [DataProcessamento], [Status]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

