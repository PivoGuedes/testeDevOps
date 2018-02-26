CREATE TABLE [dbo].[APOLICE_SWISSRE_TEMP] (
    [ID]                    INT             NOT NULL,
    [NumeroProposta]        VARCHAR (12)    NOT NULL,
    [NumeroApolice]         VARCHAR (11)    NULL,
    [DatadeEmissao]         DATE            NULL,
    [Endosso]               VARCHAR (6)     NULL,
    [IniciodaVigencia]      DATE            NOT NULL,
    [FimdaVigencia]         DATE            NOT NULL,
    [Produto]               VARCHAR (70)    NULL,
    [Segurado]              VARCHAR (100)   NULL,
    [CPFCNPJ]               VARCHAR (18)    NULL,
    [Cidade]                VARCHAR (40)    NULL,
    [Estado]                VARCHAR (2)     NULL,
    [Categoria]             VARCHAR (40)    NULL,
    [ImportanciaSegurada]   DECIMAL (24, 4) NULL,
    [DatadoRiscoPlantio]    DATE            NULL,
    [PercentualFranquia]    DECIMAL (5, 2)  NULL,
    [ValorFranquia]         DECIMAL (24, 6) NULL,
    [PremioLiquido]         DECIMAL (24, 6) NULL,
    [Comissao]              DECIMAL (24, 6) NULL,
    [PremioTotal]           DECIMAL (24, 6) NULL,
    [VenctoPrimeiraParcela] DATE            NULL,
    [DDDRes]                VARCHAR (4)     NULL,
    [TelefoneRes]           VARCHAR (15)    NULL,
    [DDDCom]                VARCHAR (4)     NULL,
    [TelefoneCom]           VARCHAR (15)    NULL,
    [NomePropriedade]       VARCHAR (80)    NULL,
    [Endereco]              VARCHAR (150)   NULL,
    [Bairro]                VARCHAR (80)    NULL,
    [CEP]                   VARCHAR (9)     NULL,
    [Complemento]           VARCHAR (60)    NULL,
    [TipoDado]              VARCHAR (50)    NOT NULL,
    [DataArquivo]           DATE            NOT NULL,
    [DatadaProposta]        DATE            NOT NULL,
    [Ocupacao]              VARCHAR (80)    NULL,
    [Area_Segurada]         DECIMAL (38, 8) NULL
);


GO
CREATE CLUSTERED INDEX [IDX_APOLICE_SWISSRE_TEMP_ID]
    ON [dbo].[APOLICE_SWISSRE_TEMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_APOLICE_SWISSRE_TEMP_Proposta]
    ON [dbo].[APOLICE_SWISSRE_TEMP]([NumeroProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_APOLICE_SWISSRE_TEMP_Apolice]
    ON [dbo].[APOLICE_SWISSRE_TEMP]([NumeroApolice] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

