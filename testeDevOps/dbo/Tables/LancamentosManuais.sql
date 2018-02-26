CREATE TABLE [dbo].[LancamentosManuais] (
    [Código Produto/Campos Box] INT            NULL,
    [Ramo]                      NVARCHAR (255) NULL,
    [data cálculo]              DATETIME       NULL,
    [data recibo]               DATETIME       NULL,
    [operação]                  NVARCHAR (255) NULL,
    [filial faturamento]        NVARCHAR (255) NULL,
    [canal venda]               NVARCHAR (255) NULL,
    [agência]                   NVARCHAR (255) NULL,
    [seguradora]                NVARCHAR (255) NULL,
    [valor corretagem: ajuste]  FLOAT (53)     NULL
);

