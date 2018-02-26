CREATE TABLE [Dados].[Endosso] (
    [ID]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDContrato]           BIGINT          NOT NULL,
    [IDProduto]            INT             NOT NULL,
    [IDProposta]           BIGINT          NULL,
    [CodigoSubestipulante] SMALLINT        NULL,
    [NumeroEndosso]        INT             NOT NULL,
    [DataEmissao]          DATE            NULL,
    [DataInicioVigencia]   DATE            NULL,
    [DataFimVigencia]      DATE            NULL,
    [ValorPremioTotal]     DECIMAL (19, 2) NULL,
    [ValorPremioLiquido]   DECIMAL (19, 2) NULL,
    [IDTipoEndosso]        TINYINT         NULL,
    [IDSituacaoEndosso]    TINYINT         NULL,
    [QuantidadeParcelas]   TINYINT         NULL,
    [DataArquivo]          DATE            NOT NULL,
    [Arquivo]              VARCHAR (80)    NOT NULL,
    [ValorPremioTarifario] DECIMAL (19, 2) NULL,
    [ValorIOF]             DECIMAL (19, 2) NULL,
    [IDRamo]               SMALLINT        NULL,
    [IDFilialFaturamento]  SMALLINT        NULL,
    [Rowversion]           ROWVERSION      NOT NULL,
    CONSTRAINT [PK_ENDOSSO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Endosso_Contrato] FOREIGN KEY ([IDContrato]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_ENDOSSO_FK_ENDOSS_TIPOENDO] FOREIGN KEY ([IDTipoEndosso]) REFERENCES [Dados].[TipoEndosso] ([ID]),
    CONSTRAINT [FK_Endosso_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_EndossoFilialFaturamento] FOREIGN KEY ([IDFilialFaturamento]) REFERENCES [Dados].[FilialFaturamento] ([ID]),
    CONSTRAINT [FK_EndossoRamoEmissor] FOREIGN KEY ([IDRamo]) REFERENCES [Dados].[Ramo] ([ID]),
    CONSTRAINT [UNQ_Contrato_Endosso] UNIQUE NONCLUSTERED ([IDContrato] ASC, [NumeroEndosso] ASC, [IDProposta] ASC, [IDProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE CLUSTERED INDEX [IDX_CL_Endosso]
    ON [Dados].[Endosso]([IDContrato] ASC, [DataArquivo] DESC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_Endosso_IDProposta]
    ON [Dados].[Endosso]([IDProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_IDTipoEndosso_NumeroEndosso]
    ON [Dados].[Endosso]([NumeroEndosso] ASC, [IDTipoEndosso] ASC)
    INCLUDE([IDContrato], [DataEmissao], [DataInicioVigencia], [ValorPremioTotal], [QuantidadeParcelas]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_NumeroEndosso]
    ON [Dados].[Endosso]([NumeroEndosso] ASC)
    INCLUDE([ID], [IDContrato], [IDProduto], [IDProposta], [DataEmissao]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_temp_endosso_idproduto]
    ON [Dados].[Endosso]([IDProduto] ASC)
    INCLUDE([IDContrato]);

