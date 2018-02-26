CREATE TABLE [dbo].[prd_propostafinanceiro_temp] (
    [ID]                    BIGINT          NOT NULL,
    [NumeroContrato]        VARCHAR (24)    NULL,
    [NumeroProposta]        VARCHAR (20)    NOT NULL,
    [CodigoProduto]         VARCHAR (5)     NULL,
    [PremioLiquido]         DECIMAL (16, 2) NULL,
    [PremioLiquidoAtrasado] NUMERIC (16, 2) NULL,
    [DataEfetivacao]        DATE            NOT NULL
);

