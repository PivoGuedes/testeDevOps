CREATE TABLE [Dados].[Atendimento] (
    [ID]                            INT             IDENTITY (1, 1) NOT NULL,
    [Protocolo]                     CHAR (10)       NULL,
    [TMA]                           INT             NULL,
    [CPF]                           VARCHAR (18)    NOT NULL,
    [DataNascimento]                DATE            NULL,
    [IDStatus_Ligacao]              TINYINT         NULL,
    [IDStatus_Final]                TINYINT         NULL,
    [IDTelefoneEfetivo]             INT             NULL,
    [IDTelefone]                    INT             NULL,
    [IDTelefoneAdicional]           INT             NULL,
    [IDEmail]                       INT             NULL,
    [IDProduto]                     INT             NULL,
    [DateTime_Contato_Efetivo]      DATETIME        NULL,
    [IDAgenciaLotacao]              SMALLINT        NULL,
    [IDAgenciaIndicacao]            SMALLINT        NULL,
    [ProdutosAdquiridos]            VARCHAR (150)   NULL,
    [Contato_Mkt_Direto]            VARCHAR (150)   NULL,
    [Produto_Efetivado]             VARCHAR (150)   NULL,
    [IDVeiculo]                     INT             NULL,
    [BitVistoria]                   CHAR (2)        NULL,
    [NomeProduto]                   VARCHAR (150)   NULL,
    [ProdutoOferta]                 VARCHAR (150)   NULL,
    [CotacaoRealizada]              CHAR (2)        NULL,
    [IDProspectOferta]              INT             NULL,
    [Termino_Vigencia]              DATE            NULL,
    [Data_Renovacao]                DATE            NULL,
    [Premio_Atual]                  DECIMAL (18, 6) NULL,
    [Premio_Sem_Desconto]           DECIMAL (18, 6) NULL,
    [FormaPagamento]                CHAR (150)      NULL,
    [QtdParcelas]                   CHAR (4)        NULL,
    [IDInforme_Seguradora]          SMALLINT        NULL,
    [IDSeguradora_Atual]            SMALLINT        NULL,
    [NomeMailing]                   VARCHAR (150)   NULL,
    [NomeCampanha]                  VARCHAR (150)   NULL,
    [IDUnidade]                     SMALLINT        NULL,
    [Regional_Par]                  VARCHAR (100)   NULL,
    [CPF_Solicitante]               VARCHAR (18)    NULL,
    [Nome]                          VARCHAR (150)   NULL,
    [Contatante]                    VARCHAR (150)   NULL,
    [Contato_Retorno]               VARCHAR (150)   NULL,
    [Cliente_Interessado]           BIT             NULL,
    [TipoArquivo]                   VARCHAR (60)    NULL,
    [IDMotivo]                      TINYINT         NULL,
    [Realizacao_Calculo_Solicitada] INT             NULL,
    [Importancia_Assegurada]        VARCHAR (200)   NULL,
    [Banco]                         VARCHAR (100)   NULL,
    [IDTipoFone]                    TINYINT         NULL,
    [IDTipoDoador]                  TINYINT         NULL,
    [IDTipoAcao]                    TINYINT         NULL,
    [IDTipoSubAcao]                 TINYINT         NULL,
    [IDTipoCliente]                 TINYINT         NULL,
    [NumeroTitulo]                  VARCHAR (35)    NULL,
    [Cod_Cliente]                   VARCHAR (20)    NULL,
    [UF]                            CHAR (2)        NULL,
    [APPL]                          CHAR (2)        NULL,
    [DataArquivo]                   DATE            NULL,
    [Arquivo]                       VARCHAR (60)    NULL,
    [CPF_NOFORMAT]                  AS              (CONVERT([varchar](18),replace(replace([CPF],'.',''),'-',''))) PERSISTED,
    [DataArquivoCalculada]          AS              (case left([Arquivo],(8)) when 'SSIS_PAR' then CONVERT([date],left(right(replace(replace([Arquivo],' ',''),'__','_'),(16)),(8)),(101)) when 'SSIS_DEV' then CONVERT([date],(((substring([Arquivo],(20),(4))+'-')+substring([Arquivo],(24),(2)))+'-')+substring([Arquivo],(26),(2))) else CONVERT([date],right(left([Arquivo],(12)),(6)),(101)) end),
    CONSTRAINT [PK_Atendimento_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Atendimento_Seguradora] FOREIGN KEY ([IDSeguradora_Atual]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_Atendimento_Seguradora1] FOREIGN KEY ([IDInforme_Seguradora]) REFERENCES [Dados].[Seguradora] ([ID]),
    CONSTRAINT [FK_Atendimento_Status_Final] FOREIGN KEY ([IDStatus_Final]) REFERENCES [Dados].[Status_Final] ([ID]),
    CONSTRAINT [FK_Atendimento_Status_Ligacao] FOREIGN KEY ([IDStatus_Ligacao]) REFERENCES [Dados].[Status_Ligacao] ([ID]),
    CONSTRAINT [FK_Atendimento_Unidade] FOREIGN KEY ([IDAgenciaIndicacao]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Atendimento_Unidade1] FOREIGN KEY ([IDAgenciaLotacao]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Atendimento_Unidade2] FOREIGN KEY ([IDUnidade]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_Atendimento_Veiculo] FOREIGN KEY ([IDVeiculo]) REFERENCES [Dados].[Veiculo] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosAtendimentoContatos_IDEmail] FOREIGN KEY ([IDEmail]) REFERENCES [Dados].[AtendimentoContatos] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosAtendimentoContatos_IDTelefone] FOREIGN KEY ([IDTelefone]) REFERENCES [Dados].[AtendimentoContatos] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosAtendimentoContatos_IDTelefoneAdicional] FOREIGN KEY ([IDTelefoneAdicional]) REFERENCES [Dados].[AtendimentoContatos] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosAtendimentoContatos_IDTelefoneEfetivo] FOREIGN KEY ([IDTelefoneEfetivo]) REFERENCES [Dados].[AtendimentoContatos] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosMotivo_IDMotivo] FOREIGN KEY ([IDMotivo]) REFERENCES [Dados].[Motivo_Contato] ([ID]),
    CONSTRAINT [FK_DadosAtendimento_DadosProspectOferta_IDProspectOferta] FOREIGN KEY ([IDProspectOferta]) REFERENCES [Dados].[ProspectOferta] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_Protocolo_CPF_KPN]
    ON [Dados].[Atendimento]([Protocolo] ASC, [CPF] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Nonclustered_Mailing]
    ON [Dados].[Atendimento]([NomeCampanha] ASC)
    INCLUDE([ID], [CPF], [DataNascimento], [IDStatus_Ligacao], [IDStatus_Final], [IDTelefoneEfetivo], [DateTime_Contato_Efetivo], [IDAgenciaIndicacao], [CotacaoRealizada], [Nome], [IDTipoCliente], [Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Nonclustered_CPF20151013]
    ON [Dados].[Atendimento]([CPF] ASC)
    INCLUDE([IDStatus_Ligacao], [IDStatus_Final], [Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NDX_AtendimentoDataArquivo]
    ON [Dados].[Atendimento]([DataArquivo] ASC)
    INCLUDE([ID], [NomeCampanha], [Arquivo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_DadosAtendimento_CPFNoFormat]
    ON [Dados].[Atendimento]([CPF_NOFORMAT] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_Idx_Atendimento_IdLigacao_Status_Arquivo]
    ON [Dados].[Atendimento]([ID] ASC, [IDStatus_Ligacao] ASC, [IDStatus_Final] ASC, [Arquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

