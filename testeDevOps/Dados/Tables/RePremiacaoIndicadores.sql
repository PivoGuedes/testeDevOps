CREATE TABLE [Dados].[RePremiacaoIndicadores] (
    [ID]                       BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]            INT             NULL,
    [IDUnidade]                SMALLINT        NULL,
    [TipoPagamento]            CHAR (1)        NULL,
    [Banco]                    SMALLINT        NOT NULL,
    [Operacao]                 VARCHAR (10)    NOT NULL,
    [ContaCorrente]            VARCHAR (20)    NOT NULL,
    [ValorBruto]               DECIMAL (19, 2) NULL,
    [ValorISS]                 DECIMAL (19, 2) NOT NULL,
    [ValorIRF]                 DECIMAL (19, 2) NOT NULL,
    [ValorLiquido]             DECIMAL (19, 2) NOT NULL,
    [ValorINSS]                DECIMAL (19, 2) NOT NULL,
    [ValorINSSRecolhidoCEF]    DECIMAL (19, 2) NULL,
    [NomeArquivo]              VARCHAR (60)    NOT NULL,
    [DataArquivo]              DATE            NOT NULL,
    [NomeIndicador]            VARCHAR (200)   NULL,
    [CPF]                      VARCHAR (20)    NULL,
    [DataReferencia]           DATE            NULL,
    [Autorizado]               BIT             NULL,
    [CalculadoAliquotaISS]     DECIMAL (19, 2) NULL,
    [CalculadoValorISS]        DECIMAL (19, 2) NULL,
    [CalculadoAliquotaIRRF]    DECIMAL (19, 2) NULL,
    [CalculadoValorIRRF]       DECIMAL (19, 2) NULL,
    [CalculadoAliquotaINSS]    DECIMAL (19, 2) NULL,
    [CalculadoValorINSS]       DECIMAL (19, 2) NULL,
    [CalculadoTetoINSS]        DECIMAL (19, 2) NULL,
    [CodigoEmpresaProtheus]    VARCHAR (2)     NULL,
    [CodigoFilialProtheus]     VARCHAR (2)     NULL,
    [CodigoImportacaoPROTHEUS] VARCHAR (6)     NULL,
    [LoteImportacaoPROTHEUS]   VARCHAR (6)     NULL,
    [ItemImportacaoPROTHEUS]   VARCHAR (6)     NULL,
    [DataCalculo]              DATETIME2 (7)   NULL,
    [Cancelado]                BIT             NULL,
    [DataCompetencia]          DATE            NULL,
    [Gerente]                  BIT             NULL,
    [IDLote]                   INT             NULL,
    [AnoMesArquivo]            AS              (CONVERT([varchar](10),datepart(year,[dataarquivo]))+right('0'+CONVERT([varchar](10),datepart(month,[dataarquivo])),(2))),
    CONSTRAINT [PK_RePremiacaoIndicadores_1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_RePremiacaoIndicadores_Funcionario1] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_RePremiacaoIndicadores_LoteProtheus] FOREIGN KEY ([IDLote]) REFERENCES [ControleDados].[LoteProtheus] ([ID]),
    CONSTRAINT [FK_RePremiacaoIndicadores_Unidade] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [UNQ_RePremiacaoIndicadores] UNIQUE NONCLUSTERED ([DataArquivo] ASC, [IDFuncionario] ASC, [Gerente] ASC, [DataReferencia] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RepremiacaoIndicadores_DataReferencia]
    ON [Dados].[RePremiacaoIndicadores]([DataReferencia] ASC, [IDFuncionario] ASC, [Gerente] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RepremiacaoIndicadores_Autorizado]
    ON [Dados].[RePremiacaoIndicadores]([Autorizado] ASC, [IDUnidade] ASC)
    INCLUDE([IDFuncionario], [ValorBruto], [DataCompetencia]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RePremiacaoIndicadores_IDIndicadorDataArquivo]
    ON [Dados].[RePremiacaoIndicadores]([IDFuncionario] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RePremiacaoIndicadores_SuporteCargaDeLote]
    ON [Dados].[RePremiacaoIndicadores]([IDLote] ASC)
    INCLUDE([DataArquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_RePremiacaoIndicadores_IDLote]
    ON [Dados].[RePremiacaoIndicadores]([IDLote] ASC)
    INCLUDE([ValorBruto], [ValorISS], [ValorIRF], [ValorLiquido], [ValorINSS], [ValorINSSRecolhidoCEF], [Autorizado]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

