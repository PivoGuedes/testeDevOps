CREATE TABLE [dbo].[CORRECAO_VIDACAPITALGLOBAL_IDsPropostasCOMISSAO] (
    [IDContrato]             BIGINT        NULL,
    [IDCertificado]          INT           NULL,
    [NumeroCertificado]      VARCHAR (20)  NOT NULL,
    [IDProdutoComissao]      INT           NULL,
    [IDProdutoPropostaCerta] INT           NULL,
    [CodigoComercializado]   VARCHAR (5)   NOT NULL,
    [Descricao]              VARCHAR (100) NULL,
    [IDPropostaErrada]       BIGINT        NULL,
    [NumeroPropostaErrada]   VARCHAR (20)  NOT NULL,
    [IDPRopostaCerta]        BIGINT        NULL,
    [NumeroPropostaCerta]    VARCHAR (20)  NOT NULL
);

