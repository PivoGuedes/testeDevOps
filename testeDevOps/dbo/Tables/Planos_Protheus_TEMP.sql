CREATE TABLE [dbo].[Planos_Protheus_TEMP] (
    [ID]              BIGINT       IDENTITY (1, 1) NOT NULL,
    [IDSeguradora]    INT          CONSTRAINT [DF_Plano_Saude_IDSeguradora] DEFAULT ((18)) NOT NULL,
    [CodigoPlano]     VARCHAR (4)  NOT NULL,
    [VersaoPlano]     VARCHAR (3)  NOT NULL,
    [FormaDeCobranca] INT          NOT NULL,
    [NomePlano]       VARCHAR (60) NOT NULL,
    [NumANS]          INT          NULL,
    [PlanoANS]        VARCHAR (30) NULL,
    [EMPRESA]         VARCHAR (2)  NOT NULL,
    CONSTRAINT [PK_PLANOS_PROTHEUS_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_NumeroModelagem_Proposta_Saude_TEMP]
    ON [dbo].[Planos_Protheus_TEMP]([IDSeguradora] ASC, [CodigoPlano] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

