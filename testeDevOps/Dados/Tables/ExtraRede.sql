CREATE TABLE [Dados].[ExtraRede] (
    [ID]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [CodigoProduto]     VARCHAR (5)     NOT NULL,
    [ValorAgenciamento] DECIMAL (38, 6) NOT NULL,
    [ValorCorretagem]   DECIMAL (38, 6) NOT NULL,
    [NumeroRecibo]      BIGINT          NOT NULL,
    [DataCompetencia]   DATE            NOT NULL,
    [DataCalculo]       DATE            NOT NULL,
    [DataRecibo]        DATE            NOT NULL,
    [IDEmpresa]         SMALLINT        NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

