CREATE TABLE [dbo].[propostasVidaPMresumo] (
    [ProdutoSias]      VARCHAR (5)     NOT NULL,
    [DescProdutoSias]  VARCHAR (100)   NULL,
    [REF_INI_VIG]      VARCHAR (25)    NOT NULL,
    [ANO_INI]          INT             NULL,
    [REF_FIM_VIG]      VARCHAR (25)    NOT NULL,
    [ANO_FIM]          INT             NULL,
    [REF_CANC]         VARCHAR (25)    NOT NULL,
    [ANO_CANC]         INT             NULL,
    [FREQ_ATIVO]       INT             NOT NULL,
    [ValorPremioBruto] DECIMAL (19, 2) NULL,
    [FREQ]             INT             NULL
);

