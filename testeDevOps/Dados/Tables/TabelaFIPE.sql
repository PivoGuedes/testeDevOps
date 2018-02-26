CREATE TABLE [Dados].[TabelaFIPE] (
    [Codigo]         INT             NULL,
    [DV]             INT             NULL,
    [Modelo]         VARCHAR (50)    NULL,
    [Versão]         VARCHAR (50)    NULL,
    [Desconhecido]   VARCHAR (50)    NULL,
    [Valor]          DECIMAL (19, 2) NULL,
    [FaixaAno]       VARCHAR (50)    NULL,
    [TipoVeiculo]    VARCHAR (50)    NULL,
    [CodigoCompleto] INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [IdxNCL_TabelaFIPE_TipoVeiculo]
    ON [Dados].[TabelaFIPE]([TipoVeiculo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IdxNCL_TabelaFIPE_CodigoCompleto]
    ON [Dados].[TabelaFIPE]([CodigoCompleto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

