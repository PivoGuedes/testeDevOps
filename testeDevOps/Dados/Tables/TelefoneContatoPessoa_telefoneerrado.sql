CREATE TABLE [Dados].[TelefoneContatoPessoa_telefoneerrado] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [IDContatoPessoa]     INT           NOT NULL,
    [IDOrigemDadoContato] INT           NOT NULL,
    [Telefone]            VARCHAR (20)  NOT NULL,
    [Ordem]               INT           NULL,
    [DataAtualizacao]     DATETIME2 (7) NULL,
    [IsMobile]            BIT           NULL
);

