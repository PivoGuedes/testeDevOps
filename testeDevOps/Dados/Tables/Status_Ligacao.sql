CREATE TABLE [Dados].[Status_Ligacao] (
    [ID]           TINYINT       IDENTITY (1, 1) NOT NULL,
    [Nome]         VARCHAR (100) NOT NULL,
    [DataCadastro] DATETIME      CONSTRAINT [DF__Status_Li__DataC__5206524D] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Status_Ligacao_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

