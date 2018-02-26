CREATE TABLE [DataBroker].[PessoaFisica] (
    [ID]                  INT              IDENTITY (1, 1) NOT NULL,
    [Nome]                VARCHAR (100)    NULL,
    [CPF]                 CHAR (14)        NULL,
    [DataNascimento]      DATE             NULL,
    [IDEstadoCivil]       TINYINT          NULL,
    [IDSexo]              TINYINT          NULL,
    [IDProfissao]         SMALLINT         NULL,
    [Profissao]           VARCHAR (100)    NULL,
    [RendaIndividual]     DECIMAL (10)     NULL,
    [RendaFamiliar]       DECIMAL (10)     NULL,
    [IdentificadorGlobal] UNIQUEIDENTIFIER NOT NULL
);


GO
CREATE CLUSTERED INDEX [PK_PessoaFisica]
    ON [DataBroker].[PessoaFisica]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

