CREATE TABLE [Dados].[CentroCusto] (
    [ID]                  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [IDCentroCustoMestre] SMALLINT      NULL,
    [Codigo]              VARCHAR (30)  NULL,
    [Descricao]           VARCHAR (150) NOT NULL,
    [IDClasse]            TINYINT       NULL,
    [Classe]              AS            (case when [IDClasse]=(1) then 'SINTÉTICO' when [IDClasse]=(2) then 'ANALÍTICO'  end) PERSISTED,
    [FL_Bloqueio]         BIT           NULL,
    CONSTRAINT [PK_CentroCusto] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_CentroCusto_CentroCusto] FOREIGN KEY ([IDCentroCustoMestre]) REFERENCES [Dados].[CentroCusto] ([ID])
);

