CREATE TABLE [Dados].[CorrespondenteDadosBancarios] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [IDCorrespondente] INT           NOT NULL,
    [IDTipoProduto]    TINYINT       NOT NULL,
    [Banco]            SMALLINT      NOT NULL,
    [Agencia]          VARCHAR (10)  NOT NULL,
    [Operacao]         SMALLINT      NOT NULL,
    [ContaCorrente]    VARCHAR (20)  NOT NULL,
    [NomeArquivo]      VARCHAR (100) NOT NULL,
    [DataArquivo]      DATE          NOT NULL,
    CONSTRAINT [PK__Correspo__3214EC2735491643] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Correspondente_CorrespondenteDadosBancarios] FOREIGN KEY ([IDCorrespondente]) REFERENCES [Dados].[Correspondente] ([ID]),
    CONSTRAINT [FK_TipoProduto_CorrespondenteDadosBancarios] FOREIGN KEY ([IDTipoProduto]) REFERENCES [Dados].[TipoProduto] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_CorrespondenteDadosBancarios_IDTipoProduto_ContaCorrente]
    ON [Dados].[CorrespondenteDadosBancarios]([IDTipoProduto] ASC, [ContaCorrente] ASC)
    INCLUDE([IDCorrespondente], [Banco], [Agencia], [Operacao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_CorrespondenteDadosBancarios_IDTipoProduto_IDCorrespondente]
    ON [Dados].[CorrespondenteDadosBancarios]([IDTipoProduto] ASC, [IDCorrespondente] ASC)
    INCLUDE([ContaCorrente], [Banco], [Agencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

