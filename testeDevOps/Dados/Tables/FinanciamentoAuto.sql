CREATE TABLE [Dados].[FinanciamentoAuto] (
    [ID]              INT             DEFAULT (NEXT VALUE FOR [Dados].[SequenceFinanciamento]) NOT NULL,
    [DataLiberacao]   DATE            NOT NULL,
    [Agencia]         VARCHAR (4)     NOT NULL,
    [NumeroContrato]  VARCHAR (20)    NOT NULL,
    [AnoFabricacao]   VARCHAR (4)     NOT NULL,
    [AnoModelo]       VARCHAR (4)     NOT NULL,
    [Chassi]          VARCHAR (20)    NOT NULL,
    [PrazoVencimento] INT             NOT NULL,
    [Valor]           DECIMAL (18, 4) NOT NULL,
    [NomeArquivo]     VARCHAR (50)    NOT NULL,
    [DataArquivo]     DATE            NOT NULL,
    CONSTRAINT [PK_DADOS_FINANCIAMENTOAUTO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

