CREATE TABLE [dbo].[PropostaSaudeComissao_TEMP] (
    [ID]                     INT          IDENTITY (1, 1) NOT NULL,
    [NumeroProposta]         VARCHAR (20) NULL,
    [TipoComissao]           CHAR (1)     NULL,
    [PercentualComissao]     INT          NULL,
    [ParcelaInicialComissao] INT          NULL,
    [ParcelaFinalComissao]   INT          NULL,
    [BaseCalculoComissao]    INT          NULL,
    [Operadora]              VARCHAR (4)  NOT NULL,
    [CodigoVendedor]         INT          NOT NULL,
    [NomeVendedor]           VARCHAR (60) NOT NULL,
    CONSTRAINT [PK_PropostaSaudeComissao_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_PropostaSaudeComissao_TEMP]
    ON [dbo].[PropostaSaudeComissao_TEMP]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

