CREATE TABLE [dbo].[Vincendos_vida] (
    [COD_CLIENTE]             FLOAT (53)     NULL,
    [CPF]                     FLOAT (53)     NULL,
    [Perído Pagamento]        NVARCHAR (255) NULL,
    [Inicio Vigência]         NVARCHAR (255) NULL,
    [Fim Vigência]            NVARCHAR (255) NULL,
    [Código Produto]          FLOAT (53)     NULL,
    [Código Segmento Negócio] FLOAT (53)     NULL,
    [Nome Segmento Negócio]   NVARCHAR (255) NULL,
    [Situação do Contrato]    NVARCHAR (255) NULL,
    [Número da Proposta]      FLOAT (53)     NULL,
    [Seq Pessoa]              FLOAT (53)     NULL,
    [Nome Pessoa]             NVARCHAR (255) NULL,
    [Data Nascimento]         NVARCHAR (255) NULL,
    [Idade]                   FLOAT (53)     NULL,
    [Endereço]                NVARCHAR (255) NULL,
    [Bairro]                  NVARCHAR (255) NULL,
    [Cidade]                  NVARCHAR (255) NULL,
    [CEP]                     FLOAT (53)     NULL,
    [DDD]                     FLOAT (53)     NULL,
    [Telefone]                FLOAT (53)     NULL,
    [Vlr Prêmio]              NVARCHAR (255) NULL,
    [Região]                  NVARCHAR (255) NULL,
    [Faixa Renda]             NVARCHAR (255) NULL,
    [PropostaTratada]         AS             (right('00000000000'+CONVERT([varchar](20),CONVERT([decimal],[Número da Proposta])),(15))) PERSISTED
);


GO
CREATE CLUSTERED INDEX [idx_PropostaTratada]
    ON [dbo].[Vincendos_vida]([PropostaTratada] ASC);

