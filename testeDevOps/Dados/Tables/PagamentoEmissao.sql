CREATE TABLE [Dados].[PagamentoEmissao] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]           BIGINT          NULL,
    [IDMotivo]             SMALLINT        NULL,
    [IDSituacaoProposta]   TINYINT         NULL,
    [Valor]                NUMERIC (16, 2) NULL,
    [ValorIOF]             NUMERIC (16, 2) NULL,
    [DataInicioVigencia]   DATE            NULL,
    [DataFimVigencia]      DATE            NULL,
    [DataEfetivacao]       DATE            NULL,
    [DataArquivo]          DATE            NULL,
    [CodigoNaFonte]        BIGINT          NULL,
    [TipoDado]             VARCHAR (30)    NULL,
    [SinalLancamento]      CHAR (1)        NULL,
    [ExpectativaDeReceita] NCHAR (10)      NULL,
    [Arquivo]              VARCHAR (80)    NULL,
    [ValorCustoEmissao]    NUMERIC (16, 2) NULL,
    CONSTRAINT [PK_PAGAMENTOEMISSAO] PRIMARY KEY NONCLUSTERED ([ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PAGAMENT_FK_PAGAMENTOEMISSAOTIPOMOTI] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PAGAMENTOEMISSAO__PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_PAGAMENTOEMISSAO_FK_PAGAMENTOEMISSAOSITUACAO] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [UNQ_CHAVE_PAGAMENTOEMISSAO] UNIQUE NONCLUSTERED ([IDProposta] ASC, [IDMotivo] ASC, [Valor] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [idx_CLPagamentoEmissao_IDProposta_DataArquivo]
    ON [Dados].[PagamentoEmissao]([IDProposta] ASC, [DataArquivo] DESC, [ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLPagamentoEmissao_DataArquivo]
    ON [Dados].[PagamentoEmissao]([DataArquivo] ASC)
    INCLUDE([IDProposta], [IDMotivo], [IDSituacaoProposta], [Valor], [ValorIOF], [TipoDado], [DataEfetivacao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
EXECUTE sp_addextendedproperty @name = N'd', @value = N'd', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'PagamentoEmissao';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'PagamentoEmissao';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A data do arquivo representa a data da confirmação do pagamento, quando o dado for do TIPO 8 ou data de emissão quando o dado for do TIPO 2', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'PagamentoEmissao', @level2type = N'COLUMN', @level2name = N'DataArquivo';

