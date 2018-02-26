CREATE TABLE [dbo].[VALIDACOES_JANAINA] (
    [NumeroContrato]         VARCHAR (20)    NOT NULL,
    [NumeroPropostaComissao] VARCHAR (20)    NULL,
    [IDCertificado]          INT             NULL,
    [CodigoComercializado]   VARCHAR (5)     NOT NULL,
    [NumeroProposta]         VARCHAR (20)    NULL,
    [DataEmissao]            DATE            NULL,
    [CodigoOperacao]         SMALLINT        NULL,
    [TipoDado]               VARCHAR (80)    NULL,
    [Arquivo]                VARCHAR (80)    NOT NULL,
    [CodigoSubestipulante]   SMALLINT        NULL,
    [PercentualCorretagem]   DECIMAL (5, 2)  NULL,
    [NumeroEndosso]          INT             NULL,
    [NumeroRecibo]           INT             NULL,
    [NumeroParcela]          SMALLINT        NULL,
    [DataRecibo]             DATE            NULL,
    [ValorBase]              DECIMAL (38, 6) NULL,
    [ValorCorretagem]        DECIMAL (38, 6) NULL,
    [ValorComissaoPAR]       DECIMAL (38, 6) NULL,
    [ValorRepasse]           DECIMAL (38, 6) NULL,
    [ID]                     INT             IDENTITY (1, 1) NOT NULL
);


GO
CREATE CLUSTERED INDEX [IDX_NCL_VJ_0]
    ON [dbo].[VALIDACOES_JANAINA]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_VJ_1]
    ON [dbo].[VALIDACOES_JANAINA]([NumeroContrato] ASC, [NumeroEndosso] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_VJ_2]
    ON [dbo].[VALIDACOES_JANAINA]([NumeroContrato] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_VJ_3]
    ON [dbo].[VALIDACOES_JANAINA]([NumeroEndosso] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_VJ_4]
    ON [dbo].[VALIDACOES_JANAINA]([IDCertificado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

