CREATE TABLE [dbo].[PropostaPlano_TEMP] (
    [ID]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [CodigoPlano]    VARCHAR (4)  NOT NULL,
    [VersaoPlano]    VARCHAR (3)  NOT NULL,
    [NumeroProposta] VARCHAR (20) NOT NULL,
    [IDSeguradora]   INT          CONSTRAINT [DF_PropostaPlano_IDSeguradora] DEFAULT ((18)) NOT NULL,
    [SubGrupo]       INT          NOT NULL,
    [Empresa]        VARCHAR (2)  NOT NULL,
    CONSTRAINT [PK_PROPOSTAPLANO_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_NumeroPropostaPlano_TEMP]
    ON [dbo].[PropostaPlano_TEMP]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

