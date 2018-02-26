CREATE TABLE [dbo].[CCP_TMP] (
    [CTT_CUSTO]           VARCHAR (15) NOT NULL,
    [CTT_CCSUP]           VARCHAR (15) NOT NULL,
    [CTT_DESC01]          VARCHAR (40) NOT NULL,
    [CTT_BLOQ]            VARCHAR (1)  NOT NULL,
    [CTT_CLASSE]          VARCHAR (1)  NOT NULL,
    [ID]                  SMALLINT     NULL,
    [IDCentroCustoMestre] SMALLINT     NULL
) ON [PRIMARY];

