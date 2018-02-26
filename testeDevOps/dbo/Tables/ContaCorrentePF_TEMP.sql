CREATE TABLE [dbo].[ContaCorrentePF_TEMP] (
    [ID]             INT          NOT NULL,
    [CPF]            VARCHAR (15) NOT NULL,
    [CDPRODUTO]      INT          NOT NULL,
    [CDUNIDADE]      INT          NOT NULL,
    [NUMEROCONTRATO] VARCHAR (50) NOT NULL,
    [DTCONTRATO]     DATETIME     NOT NULL,
    [DTNASCIMENTO]   DATETIME     NULL,
    [DataImportacao] DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContaCorrente_Temp] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

