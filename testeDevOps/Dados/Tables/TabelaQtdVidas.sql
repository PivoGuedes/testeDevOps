CREATE TABLE [Dados].[TabelaQtdVidas] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [Descricao]       VARCHAR (30) NULL,
    [EmpresaProtheus] VARCHAR (2)  NOT NULL,
    [CodigoProtheus]  VARCHAR (2)  NOT NULL,
    CONSTRAINT [PK_TABELAQTDVIDAS] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);

