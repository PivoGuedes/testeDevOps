CREATE TABLE [Dados].[ParcelaSaude] (
    [ID]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [IDParcela]      BIGINT       NOT NULL,
    [NumeroTitulo]   VARCHAR (13) NOT NULL,
    [DataVencimento] DATE         NOT NULL,
    [IDSeguradora]   SMALLINT     NOT NULL,
    [NumeroProposta] VARCHAR (20) NOT NULL,
    [IDProposta]     BIGINT       NOT NULL,
    [DataEmissao]    DATE         NOT NULL,
    CONSTRAINT [PK_PARCELASAUDE] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);

