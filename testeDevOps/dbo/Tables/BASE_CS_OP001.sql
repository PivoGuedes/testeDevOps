CREATE TABLE [dbo].[BASE_CS_OP001] (
    [iCodigo_Unidade]         NVARCHAR (4)  NULL,
    [iCodigo_Operacao]        VARCHAR (4)   NULL,
    [iNumero_Conta]           VARCHAR (21)  NULL,
    [dData_Abertura_da_Conta] DATE          NULL,
    [DT_NASCIMENTO]           NVARCHAR (10) NULL,
    [iCPF_CNPJ]               NVARCHAR (21) NULL,
    [CPFCNPJ]                 NVARCHAR (18) NULL,
    [AgenciaInt]              INT           NULL,
    [MesBase]                 INT           NULL,
    [AnoBase]                 INT           NULL,
    [cpfInt]                  AS            (CONVERT([bigint],[iCPF_CNPJ],0)) PERSISTED
);


GO
CREATE CLUSTERED INDEX [cl_idx_iNumeroConta]
    ON [dbo].[BASE_CS_OP001]([iNumero_Conta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_Idx_cpfInt_BASECSOP001]
    ON [dbo].[BASE_CS_OP001]([cpfInt] ASC)
    INCLUDE([iCodigo_Unidade], [iCodigo_Operacao], [iNumero_Conta], [dData_Abertura_da_Conta], [DT_NASCIMENTO], [iCPF_CNPJ], [CPFCNPJ], [AgenciaInt], [MesBase], [AnoBase]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

