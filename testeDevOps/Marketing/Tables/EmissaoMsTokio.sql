CREATE TABLE [Marketing].[EmissaoMsTokio] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [CPFCNPJ]             VARCHAR (20)  NOT NULL,
    [Produto]             VARCHAR (200) NULL,
    [ApoliceAnterior]     VARCHAR (20)  NOT NULL,
    [NomeCliente]         VARCHAR (200) NOT NULL,
    [Email]               VARCHAR (200) NOT NULL,
    [NomeEmpresaParceira] VARCHAR (200) NOT NULL,
    [Descricao]           VARCHAR (200) NOT NULL,
    [Placa]               VARCHAR (10)  NOT NULL,
    [Chassi]              VARCHAR (50)  NOT NULL,
    [Cep]                 INT           NOT NULL,
    [InicioVigencia]      DATE          NULL,
    [Bonus]               VARCHAR (10)  NULL,
    [RenovacaoFacilitada] VARCHAR (1)   NOT NULL,
    [Dataarquivo]         DATE          NULL,
    CONSTRAINT [PK_EmissaoTokio] PRIMARY KEY CLUSTERED ([ID] ASC)
);

