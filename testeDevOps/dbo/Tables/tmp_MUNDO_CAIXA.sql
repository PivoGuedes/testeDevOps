CREATE TABLE [dbo].[tmp_MUNDO_CAIXA] (
    [Nome]                VARCHAR (255)  NULL,
    [CPFCNPJ]             VARCHAR (20)   NULL,
    [DataNascimento]      NVARCHAR (255) NULL,
    [EmailPessoal]        VARCHAR (255)  NULL,
    [DDDResidencial]      VARCHAR (3)    NULL,
    [TelefoneResidencial] VARCHAR (11)   NULL,
    [DDDCelular]          VARCHAR (3)    NULL,
    [TelefoneCelular]     VARCHAR (11)   NULL,
    [DDDComercial]        VARCHAR (3)    NULL,
    [TelefoneComercial]   VARCHAR (11)   NULL,
    [DDDFax]              VARCHAR (3)    NULL,
    [TelefoneFax]         VARCHAR (10)   NULL
);


GO
CREATE CLUSTERED INDEX [IDX_CL_tmp_MUNDO_CAIXA]
    ON [dbo].[tmp_MUNDO_CAIXA]([CPFCNPJ] ASC) WITH (FILLFACTOR = 90);

