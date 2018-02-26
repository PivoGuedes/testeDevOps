CREATE TABLE [dbo].[D150804#VP7000B$] (
    [COD_PRODUTO]                               FLOAT (53)     NULL,
    [NOME_SEGURADO]                             NVARCHAR (255) NULL,
    [NUM_CPF]                                   FLOAT (53)     NULL,
    [NUM_CERTIFICADO]                           FLOAT (53)     NULL,
    [SITUACAO]                                  NVARCHAR (255) NULL,
    [DTH_INI_VIGENCIA]                          DATETIME       NULL,
    [DTH_FIM_VIGENCIA]                          DATETIME       NULL,
    [CODIGO_SR/COOPERATIVA]                     FLOAT (53)     NULL,
    [CAPITAL_SEGURADO]                          FLOAT (53)     NULL,
    [VLR_PREMIO]                                FLOAT (53)     NULL,
    [DATA_DE_VENDA]                             DATETIME       NULL,
    [ano/mês]                                   NVARCHAR (255) NULL,
    [NUM_ENDOSSO]                               FLOAT (53)     NULL,
    [NUM_SICOB                                ] FLOAT (53)     NULL,
    [F15]                                       NVARCHAR (255) NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_certif]
    ON [dbo].[D150804#VP7000B$]([NUM_CERTIFICADO] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

