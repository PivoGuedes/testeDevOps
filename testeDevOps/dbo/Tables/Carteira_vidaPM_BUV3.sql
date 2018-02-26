CREATE TABLE [dbo].[Carteira_vidaPM_BUV3] (
    [Número da Proposta]       VARCHAR (20)  NULL,
    [Código Produto]           VARCHAR (4)   NULL,
    [Número Situação Contrato] VARCHAR (50)  NULL,
    [Código Tipo Proposta]     VARCHAR (50)  NULL,
    [Código Segmento Negócio]  VARCHAR (50)  NULL,
    [Segmento Negócio]         VARCHAR (255) NULL,
    [Nome do Produto]          VARCHAR (255) NULL,
    [Tipo Segmento]            VARCHAR (50)  NULL,
    [Período Segmento]         VARCHAR (50)  NULL,
    [Código Cliente]           VARCHAR (50)  NULL,
    [CPF]                      VARCHAR (50)  NULL,
    [Nome Pessoa]              VARCHAR (255) NULL,
    [Data Nascimento]          VARCHAR (50)  NULL,
    [Valor Proposta]           VARCHAR (50)  NULL,
    [Data Quitação]            VARCHAR (50)  NULL,
    [Qtd Propostas]            VARCHAR (50)  NULL,
    [Qtd Certificados]         VARCHAR (50)  NULL,
    [PropostaFormatada]        AS            (right('000000000000000'+[Número da Proposta],(15))) PERSISTED
);


GO
CREATE CLUSTERED INDEX [idx_PropostaBU]
    ON [dbo].[Carteira_vidaPM_BUV3]([PropostaFormatada] ASC) WITH (FILLFACTOR = 90);

