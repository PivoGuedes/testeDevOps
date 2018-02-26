CREATE TABLE [dbo].[Financ_Auto_ODS_TEMP] (
    [ID]           INT             NOT NULL,
    [DT_LIB]       DATE            NULL,
    [AG]           VARCHAR (255)   NOT NULL,
    [CONT]         VARCHAR (255)   NOT NULL,
    [NOME]         VARCHAR (255)   NOT NULL,
    [CPF]          VARCHAR (50)    NOT NULL,
    [DT_NAS]       DATE            NOT NULL,
    [END]          VARCHAR (250)   NOT NULL,
    [COMPLEMENTO]  VARCHAR (255)   NULL,
    [CID]          VARCHAR (255)   NOT NULL,
    [UF]           VARCHAR (255)   NOT NULL,
    [CEP]          VARCHAR (255)   NOT NULL,
    [DDD]          VARCHAR (255)   NULL,
    [FONE]         VARCHAR (255)   NULL,
    [SEXO]         CHAR (255)      NOT NULL,
    [EST_CIVIL]    VARCHAR (255)   NOT NULL,
    [ANO_FABR]     VARCHAR (255)   NOT NULL,
    [ANO_MODE]     VARCHAR (255)   NOT NULL,
    [CHASSI]       VARCHAR (255)   NULL,
    [PZ_VENC]      INT             NOT NULL,
    [VL_CONTRATO ] DECIMAL (24, 8) NULL,
    [NomeArquivo]  VARCHAR (150)   NOT NULL,
    [DataArquivo]  DATE            NOT NULL,
    [CPFTRATADO]   VARCHAR (20)    NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_Financ_Auto_CPF_TEMP]
    ON [dbo].[Financ_Auto_ODS_TEMP]([CPFTRATADO] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

