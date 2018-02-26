CREATE TABLE [Dados].[CorrespondenteDadosBancarios_BKP] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [IDCorrespondente] INT           NOT NULL,
    [IDTipoProduto]    TINYINT       NOT NULL,
    [Banco]            SMALLINT      NOT NULL,
    [Agencia]          VARCHAR (10)  NOT NULL,
    [Operacao]         SMALLINT      NOT NULL,
    [ContaCorrente]    VARCHAR (20)  NOT NULL,
    [NomeArquivo]      VARCHAR (100) NOT NULL,
    [DataArquivo]      DATE          NOT NULL
);

