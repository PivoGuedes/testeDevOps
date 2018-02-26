CREATE TABLE [dbo].[Temp_PremiacaoIndicadores] (
    [CPF]                  VARCHAR (20)    NULL,
    [ValorBruto]           DECIMAL (19, 2) NULL,
    [ValorLiquido]         DECIMAL (19, 2) NOT NULL,
    [DataCompetencia]      DATE            NULL,
    [Gerente]              BIT             NOT NULL,
    [IDLote]               INT             NULL,
    [IDFuncionario]        INT             NULL,
    [DataArquivo]          DATE            NOT NULL,
    [ValorBrutoAnalitico]  DECIMAL (38, 5) NULL,
    [TotalProdutos]        INT             NULL,
    [ProdutosUnicos]       INT             NULL,
    [ValorBrutoAnalitico1] DECIMAL (38, 5) NULL,
    [TotalProdutos1]       INT             NULL,
    [ProdutosUnicos1]      INT             NULL
);

