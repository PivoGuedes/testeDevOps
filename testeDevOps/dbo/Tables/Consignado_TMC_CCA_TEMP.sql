CREATE TABLE [dbo].[Consignado_TMC_CCA_TEMP] (
    [ID]                  BIGINT          NOT NULL,
    [CONTRATO]            VARCHAR (20)    NOT NULL,
    [CPF_CGC]             VARCHAR (14)    NOT NULL,
    [DTA_LIBERACAO]       DATE            NOT NULL,
    [VAL_CONTRATO]        DECIMAL (24, 4) NULL,
    [COD_SUREG]           VARCHAR (4)     NOT NULL,
    [COD_AGENCIA]         VARCHAR (4)     NOT NULL,
    [COD_TIPO_CONTRATO]   SMALLINT        NULL,
    [COD_CANAL_CONCESSAO] VARCHAR (2)     NULL,
    [COD_CONVENENTE]      INT             NULL,
    [COD_CORRESPONDENTE]  INT             NULL,
    [SEGURO]              BIT             DEFAULT ((0)) NOT NULL,
    [VAL_SEGURO]          DECIMAL (24, 4) NULL,
    [SITUACAO_CONTRATO]   VARCHAR (10)    NULL,
    [MATRICULA]           VARCHAR (7)     NULL,
    [NOME_FUNCIONARIO]    VARCHAR (20)    NULL,
    [DataArquivo]         DATE            NULL,
    [NomeArquivo]         VARCHAR (150)   DEFAULT ('[DBM_MKT].[dbo].[CREDITO_CONSIGNADO_DTMART]') NULL,
    [CpfTratado]          VARCHAR (14)    NOT NULL,
    [CONTRATO2]           VARCHAR (60)    NOT NULL
);


GO
CREATE CLUSTERED INDEX [idx_ConsignadoID_TEMP]
    ON [dbo].[Consignado_TMC_CCA_TEMP]([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

