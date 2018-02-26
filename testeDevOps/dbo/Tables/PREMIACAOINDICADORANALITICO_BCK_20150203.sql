CREATE TABLE [dbo].[PREMIACAOINDICADORANALITICO_BCK_20150203] (
    [ID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]       INT             NULL,
    [IDEscritorioNegocio] SMALLINT        NULL,
    [IDUnidade]           SMALLINT        NULL,
    [IDProduto]           INT             NULL,
    [ValorBruto]          DECIMAL (19, 2) NULL,
    [TipoPagamento]       CHAR (1)        NULL,
    [IDContrato]          BIGINT          NULL,
    [NumeroEndosso]       INT             NULL,
    [NumeroParcela]       INT             NULL,
    [IDProposta]          BIGINT          NULL,
    [NumeroOcorrencia]    INT             NULL,
    [NomeArquivo]         VARCHAR (60)    NOT NULL,
    [DataArquivo]         DATE            NOT NULL,
    [NumeroApolice]       VARCHAR (20)    NULL,
    [CodigoSubGrupo]      SMALLINT        NULL,
    [NomeSegurado]        VARCHAR (200)   NULL,
    [NumeroTitulo]        VARCHAR (20)    NULL,
    [IDProdutoPremiacao]  INT             NULL
);

