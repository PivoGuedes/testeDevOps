CREATE TABLE [Dados].[TipoCliente] (
    [ID]           TINYINT      IDENTITY (1, 1) NOT NULL,
    [Codigo]       VARCHAR (10) NULL,
    [Descricao]    VARCHAR (60) NOT NULL,
    [DataCadastro] DATETIME     CONSTRAINT [DF__TipoClien__DataC__7B993611] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TipoCliente_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

