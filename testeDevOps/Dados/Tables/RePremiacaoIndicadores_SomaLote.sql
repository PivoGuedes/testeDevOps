CREATE TABLE [Dados].[RePremiacaoIndicadores_SomaLote] (
    [ValorBruto]    DECIMAL (38, 2) NULL,
    [ValorISS]      DECIMAL (38, 2) NULL,
    [ValorIRF]      DECIMAL (38, 2) NULL,
    [ValorLiquido]  DECIMAL (38, 2) NULL,
    [ValorINSS]     DECIMAL (38, 2) NULL,
    [Gerente]       BIT             NULL,
    [IDFuncionario] INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [nclidx_somalote]
    ON [Dados].[RePremiacaoIndicadores_SomaLote]([IDFuncionario] ASC, [Gerente] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

