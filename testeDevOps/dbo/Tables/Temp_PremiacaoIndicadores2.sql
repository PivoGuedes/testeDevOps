CREATE TABLE [dbo].[Temp_PremiacaoIndicadores2] (
    [CPF]             VARCHAR (20)    NULL,
    [DataCompetencia] DATE            NULL,
    [Gerente]         BIT             NOT NULL,
    [ValorBruto]      DECIMAL (38, 2) NULL,
    [ValorLiquido]    DECIMAL (38, 2) NULL,
    [TotalProdutos]   INT             NULL,
    [ProdutosUnicos]  INT             NULL
);

