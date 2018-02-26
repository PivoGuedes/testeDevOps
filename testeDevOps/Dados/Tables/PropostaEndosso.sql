CREATE TABLE [Dados].[PropostaEndosso] (
    [ID]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [IDProposta]            BIGINT          NOT NULL,
    [DataInicioVigencia]    DATE            NOT NULL,
    [DataFimVigencia]       DATE            NULL,
    [ValorDiferencaEndosso] NUMERIC (16, 2) NOT NULL,
    [ValorPremioLiquido]    NUMERIC (16, 2) NOT NULL,
    [ValorIOF]              NUMERIC (16, 2) NOT NULL,
    [NumeroEndosso]         INT             CONSTRAINT [DF_PropostaEndosso_NumeroEndosso] DEFAULT ((-1)) NOT NULL,
    [DataEmissao]           DATE            NOT NULL,
    [NumeroContrato]        VARCHAR (20)    NOT NULL,
    [DataArquivo]           DATE            NULL,
    CONSTRAINT [PK_PropostaEndosso_1] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_PropostaEndosso_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [UNQ_PropostaEndosso] UNIQUE CLUSTERED ([IDProposta] ASC, [DataInicioVigencia] ASC, [ValorPremioLiquido] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idxNCL_PropostaEndosso_Dados]
    ON [Dados].[PropostaEndosso]([DataInicioVigencia] ASC, [IDProposta] ASC)
    INCLUDE([NumeroEndosso]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

