CREATE TABLE [Marketing].[Endereco] (
    [ID]                      INT            IDENTITY (1, 1) NOT NULL,
    [IDFuncionarioMundoCaixa] INT            NULL,
    [IdTipoEndereco]          TINYINT        NULL,
    [Endereco]                VARCHAR (1000) NULL,
    [UF]                      VARCHAR (2)    NULL,
    CONSTRAINT [PK_EnderecoMundoCaixa] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_FuncionarioMundoCaixaEndereco] FOREIGN KEY ([IDFuncionarioMundoCaixa]) REFERENCES [Marketing].[FuncionarioMundoCaixa] ([ID])
);

