CREATE TABLE [Dados].[SinistroHistorico] (
    [ID]                        BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDSinistro]                BIGINT          NULL,
    [NumeroOcorrencia]          SMALLINT        NULL,
    [IDSinistroOperacao]        SMALLINT        NULL,
    [ValorOperacao]             DECIMAL (19, 2) NULL,
    [DataMovimentoContabil]     DATE            NULL,
    [NomeBeneficiario]          VARCHAR (140)   NULL,
    [IDCobertura]               SMALLINT        NULL,
    [IDSituacaoSinistro]        TINYINT         NULL,
    [DescricaoSituacaoSinistro] VARCHAR (40)    NULL,
    [NumeroSinistroMAPFRE]      BIGINT          NULL,
    [DataArquivo]               DATE            NULL,
    [Arquivo]                   VARCHAR (100)   NULL,
    CONSTRAINT [PK_SINISTROHISTORICO] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_SINISTRO_SINISTROHISTORICO] FOREIGN KEY ([IDSinistro]) REFERENCES [Dados].[Sinistro] ([ID]),
    CONSTRAINT [FK_SINISTROHISORICO_SINISTROOPERACAO] FOREIGN KEY ([IDSinistroOperacao]) REFERENCES [Dados].[SinistroOperacao] ([ID]),
    CONSTRAINT [FK_SINISTROHISTORICO_COBERTURA] FOREIGN KEY ([IDCobertura]) REFERENCES [Dados].[Cobertura] ([ID]),
    CONSTRAINT [UNQ_SINISTRO_HISTO_SINISTRO] UNIQUE CLUSTERED ([IDSinistro] ASC, [NumeroOcorrencia] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

