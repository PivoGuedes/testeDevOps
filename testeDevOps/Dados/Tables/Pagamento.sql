CREATE TABLE [Dados].[Pagamento] (
    [ID]                                BIGINT           IDENTITY (1, 1) NOT NULL,
    [IDProposta]                        BIGINT           NULL,
    [IDMotivo]                          SMALLINT         NULL,
    [IDMotivoSituacao]                  SMALLINT         NULL,
    [IDSituacaoProposta]                TINYINT          NULL,
    [NumeroParcela]                     SMALLINT         NULL,
    [IDTipoMovimento]                   SMALLINT         NULL,
    [NumeroEndosso]                     INT              NULL,
    [Valor]                             DECIMAL (24, 10) NULL,
    [ValorIOF]                          DECIMAL (24, 10) NULL,
    [ValorPremioLiquido]                DECIMAL (24, 10) NULL,
    [ValorPremioVG]                     DECIMAL (24, 10) NULL,
    [ValorPremioAP]                     DECIMAL (24, 10) NULL,
    [ValorTarifa]                       DECIMAL (24, 10) NULL,
    [ValorBalcao]                       DECIMAL (24, 10) NULL,
    [NumeroTitulo]                      VARCHAR (20)     NULL,
    [DataEfetivacao]                    DATE             NULL,
    [CodigoNaFonte]                     BIGINT           NULL,
    [TipoDado]                          VARCHAR (30)     NULL,
    [EfetivacaoPgtoEstimadoPelaEmissao] BIGINT           CONSTRAINT [DF_Pagamento_PgtoEstimadoPelaEmissao] DEFAULT ((0)) NULL,
    [SinalLancamento]                   CHAR (1)         NULL,
    [ExpectativaDeReceita]              NCHAR (10)       NULL,
    [DataInicioVigencia]                DATE             NULL,
    [DataFimVigencia]                   DATE             NULL,
    [ParcelaCalculada]                  BIT              CONSTRAINT [DF_Pagamento_ParcelaCalculada] DEFAULT ((0)) NULL,
    [SaldoProcessado]                   BIT              CONSTRAINT [DF_Pagamento_SaldoProcessado] DEFAULT ((0)) NULL,
    [DataArquivo]                       DATE             NULL,
    [Arquivo]                           VARCHAR (80)     NULL,
    [VendaNova]                         BIT              NULL,
    [DataEndosso]                       DATE             NULL,
    CONSTRAINT [PK_PAGAMENTO] PRIMARY KEY NONCLUSTERED ([ID] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PAGAMENT_FK_PAGAME_SITUACAO] FOREIGN KEY ([IDSituacaoProposta]) REFERENCES [Dados].[SituacaoProposta] ([ID]),
    CONSTRAINT [FK_PAGAMENT_FK_PAGAME_TIPOMOTI] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PAGAMENT1_FK_PAGAME_TIPOMOTI] FOREIGN KEY ([IDMotivoSituacao]) REFERENCES [Dados].[TipoMotivo] ([ID]),
    CONSTRAINT [FK_PAGAMENTO__PROPOSTA] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID])
);


GO
CREATE CLUSTERED INDEX [ix_Pagamento_TipoDado_DataEfetivacao]
    ON [Dados].[Pagamento]([TipoDado] ASC, [DataEfetivacao] DESC, [IDProposta] ASC, [NumeroEndosso] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_CHAVE_PAGAMENT]
    ON [Dados].[Pagamento]([IDProposta] ASC, [NumeroParcela] ASC, [IDMotivo] ASC, [DataArquivo] ASC, [NumeroEndosso] ASC, [NumeroTitulo] ASC, [Valor] ASC)
    INCLUDE([Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_DataArquivo]
    ON [Dados].[Pagamento]([DataArquivo] ASC)
    INCLUDE([IDProposta], [IDMotivo], [IDMotivoSituacao], [IDSituacaoProposta], [NumeroParcela], [IDTipoMovimento], [Valor], [ValorIOF], [ValorPremioLiquido], [DataEfetivacao], [CodigoNaFonte], [TipoDado], [EfetivacaoPgtoEstimadoPelaEmissao], [ExpectativaDeReceita], [ParcelaCalculada], [SaldoProcessado], [Arquivo], [VendaNova], [DataEndosso]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Pagamento_TipoDado]
    ON [Dados].[Pagamento]([TipoDado] ASC)
    INCLUDE([IDProposta], [NumeroParcela], [NumeroEndosso]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_Pagamento_TipoDado]
    ON [Dados].[Pagamento]([IDProposta] ASC, [NumeroEndosso] ASC, [TipoDado] ASC)
    INCLUDE([NumeroParcela], [ValorPremioLiquido], [NumeroTitulo], [DataEfetivacao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_tipodado_parcela_propostsa_endosso]
    ON [Dados].[Pagamento]([TipoDado] ASC)
    INCLUDE([IDProposta], [NumeroParcela], [NumeroEndosso], [ValorPremioLiquido], [NumeroTitulo], [DataEfetivacao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ix_Pagamento_TipoDado_DataEfetivacao_includes2]
    ON [Dados].[Pagamento]([TipoDado] ASC, [DataEfetivacao] ASC, [IDProposta] ASC, [NumeroEndosso] ASC)
    INCLUDE([NumeroParcela], [ValorPremioLiquido], [NumeroTitulo]) WHERE ([TipoDado] IN ('MR0009B', 'AU0009B')) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_SaldoProcessado]
    ON [Dados].[Pagamento]([SaldoProcessado] ASC)
    INCLUDE([IDProposta], [Valor]) WHERE ([saldoprocessado]=(0));


GO
EXECUTE sp_addextendedproperty @name = N'd', @value = N'd', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Pagamento';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Pagamento';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Pagamento', @level2type = N'COLUMN', @level2name = N'EfetivacaoPgtoEstimadoPelaEmissao';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A data do arquivo representa a data da confirmação do pagamento, quando o dado for do TIPO 8 ou data de emissão quando o dado for do TIPO 2', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'TABLE', @level1name = N'Pagamento', @level2type = N'COLUMN', @level2name = N'DataArquivo';

