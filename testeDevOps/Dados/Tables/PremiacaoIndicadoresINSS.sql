CREATE TABLE [Dados].[PremiacaoIndicadoresINSS] (
    [ID]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDFuncionario]  INT             NOT NULL,
    [ValorRubrica]   DECIMAL (19, 2) NOT NULL,
    [NumOcorrencia]  TINYINT         NOT NULL,
    [DataReferencia] DATE            NOT NULL,
    [DataArquivo]    DATE            NOT NULL,
    [NomeArquivo]    VARCHAR (60)    NOT NULL,
    CONSTRAINT [PK_PremiacaoIndicadoresINSS] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PremiacaoIndicadoresINSS_Funcionario] FOREIGN KEY ([IDFuncionario]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [UNQ_PremiacaoIndicadoresINSS] UNIQUE NONCLUSTERED ([IDFuncionario] ASC, [DataReferencia] ASC, [NumOcorrencia] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

