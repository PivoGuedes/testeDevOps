CREATE TABLE [Dados].[PropostaCliente] (
    [ID]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [IDProposta]             BIGINT        NOT NULL,
    [CPFCNPJ]                VARCHAR (18)  NULL,
    [Nome]                   VARCHAR (140) NULL,
    [DataNascimento]         DATE          NULL,
    [TipoPessoa]             VARCHAR (15)  NULL,
    [IDSexo]                 TINYINT       NULL,
    [IDEstadoCivil]          TINYINT       NULL,
    [Identidade]             VARCHAR (15)  NULL,
    [OrgaoExpedidor]         VARCHAR (5)   NULL,
    [UFOrgaoExpedidor]       VARCHAR (2)   NULL,
    [DataExpedicaoRG]        DATE          NULL,
    [DDDComercial]           VARCHAR (4)   NULL,
    [TelefoneComercial]      VARCHAR (10)  NULL,
    [DDDFax]                 VARCHAR (4)   NULL,
    [TelefoneFax]            VARCHAR (10)  NULL,
    [DDDResidencial]         VARCHAR (4)   NULL,
    [TelefoneResidencial]    VARCHAR (10)  NULL,
    [Email]                  VARCHAR (80)  NULL,
    [CodigoProfissao]        VARCHAR (3)   NULL,
    [Profissao]              VARCHAR (60)  NULL,
    [NomeConjuge]            VARCHAR (140) NULL,
    [ProfissaoConjuge]       VARCHAR (60)  NULL,
    [TipoDado]               VARCHAR (50)  NULL,
    [DataArquivo]            DATE          NULL,
    [Emailcomercial]         VARCHAR (80)  NULL,
    [DDDCelular]             VARCHAR (4)   NULL,
    [TelefoneCelular]        VARCHAR (10)  NULL,
    [CPFConjuge]             VARCHAR (18)  NULL,
    [IDSexoConjuge]          TINYINT       NULL,
    [DataNascimentoConjuge]  DATE          NULL,
    [CodigoProfissaoConjuge] VARCHAR (3)   NULL,
    [Matricula]              VARCHAR (20)  NULL,
    CONSTRAINT [PK_PropostaCliente] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NCLPropostaCliente_IDProposta]
    ON [Dados].[PropostaCliente]([IDProposta] ASC)
    INCLUDE([CPFCNPJ], [Nome], [IDSexo], [TipoPessoa], [IDEstadoCivil], [DDDResidencial], [TelefoneResidencial], [DDDFax], [TelefoneFax], [Email], [Profissao], [DDDComercial], [TelefoneComercial], [DataNascimento], [Emailcomercial]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLPropostaCliente_CPFCNPJ]
    ON [Dados].[PropostaCliente]([CPFCNPJ] ASC)
    INCLUDE([IDProposta], [Nome], [DataNascimento], [DDDCelular], [TelefoneCelular]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLPropostaCliente_CPFCNPJ_Nome]
    ON [Dados].[PropostaCliente]([CPFCNPJ] ASC, [Nome] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

