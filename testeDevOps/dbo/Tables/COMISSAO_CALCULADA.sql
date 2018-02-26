CREATE TABLE [dbo].[COMISSAO_CALCULADA] (
    [NumeroContrato]       VARCHAR (20)    NOT NULL,
    [CodigoComercializado] VARCHAR (5)     NOT NULL,
    [IDCertificado]        INT             NULL,
    [CodigoSubestipulante] SMALLINT        NULL,
    [NumeroProposta]       VARCHAR (20)    NULL,
    [DataEmissao]          DATE            NULL,
    [CodigoOperacao]       SMALLINT        NULL,
    [PercentualCorretagem] DECIMAL (5, 2)  NULL,
    [NumeroEndosso]        INT             NULL,
    [NumeroRecibo]         INT             NULL,
    [NumeroParcela]        SMALLINT        NULL,
    [DataRecibo]           DATE            NULL,
    [ValorBase]            DECIMAL (38, 6) NULL,
    [ValorCorretagem]      DECIMAL (38, 6) NULL,
    [ComissaoCalculada]    NUMERIC (38, 6) NULL,
    [ValorComissaoPAR]     DECIMAL (38, 6) NULL,
    [ValorRepasse]         DECIMAL (38, 6) NULL
);

