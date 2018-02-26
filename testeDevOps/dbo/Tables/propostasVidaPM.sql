CREATE TABLE [dbo].[propostasVidaPM] (
    [NumeroCertificado]    VARCHAR (20)    NOT NULL,
    [CPF]                  VARCHAR (18)    NULL,
    [ValorPremioBruto]     DECIMAL (19, 2) NULL,
    [NumeroProposta]       VARCHAR (20)    NOT NULL,
    [CodigoComercializado] VARCHAR (5)     NOT NULL,
    [Descricao]            VARCHAR (100)   NULL,
    [DataInicioVigencia]   DATE            NULL,
    [ANO_INI]              INT             NULL,
    [REF_INI_VIG]          VARCHAR (25)    NOT NULL,
    [DataFimVigencia]      DATE            NULL,
    [ANO_FIM]              INT             NULL,
    [REF_FIM_VIG]          VARCHAR (25)    NOT NULL,
    [DataCancelamento]     DATE            NULL,
    [ANO_CANC]             INT             NULL,
    [REF_CANC]             VARCHAR (25)    NOT NULL,
    [FREQ_ATIVO]           INT             NOT NULL,
    [ProdutoSias]          VARCHAR (5)     NOT NULL,
    [DescProdutoSias]      VARCHAR (100)   NULL,
    [DescPeriodoPagamento] VARCHAR (20)    NULL
);

