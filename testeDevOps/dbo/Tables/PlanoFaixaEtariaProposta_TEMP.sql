CREATE TABLE [dbo].[PlanoFaixaEtariaProposta_TEMP] (
    [ID]                    INT          IDENTITY (1, 1) NOT NULL,
    [IDSeguradora]          INT          CONSTRAINT [DF_PlanoFaixaEtaria_IDSeguradora] DEFAULT ((18)) NOT NULL,
    [NumeroProposta]        VARCHAR (20) NOT NULL,
    [NumeroPropostaEMISSAO] VARCHAR (20) NOT NULL,
    [SubGrupo]              INT          NULL,
    [CodigoRamoPAR]         VARCHAR (2)  NOT NULL,
    [CodigoPlano]           VARCHAR (4)  NOT NULL,
    [VersaoPlano]           VARCHAR (3)  NOT NULL,
    [VALFAI]                FLOAT (53)   NOT NULL,
    [IDAINI]                INT          NOT NULL,
    [IDAFIN]                INT          NOT NULL,
    [TIPOTABVIDAS]          VARCHAR (2)  NOT NULL,
    [TIPOADESAO]            VARCHAR (1)  NOT NULL,
    [ESTADO]                VARCHAR (2)  NOT NULL,
    [COPARTICIPACAO]        VARCHAR (1)  NOT NULL,
    [DescriTabVidas]        VARCHAR (30) NULL,
    [EMPRESA]               VARCHAR (2)  NOT NULL,
    CONSTRAINT [PK_PlanoFaixaEtaria_TEMP] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NDX_NumeroModelagem_PlanoFaixaEtaria_TEMP]
    ON [dbo].[PlanoFaixaEtariaProposta_TEMP]([IDSeguradora] ASC, [NumeroProposta] ASC, [IDAINI] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

