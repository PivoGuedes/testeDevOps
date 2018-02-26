CREATE TABLE [dbo].[HB_LARMAIS_VENDAS_tmp] (
    [id]                   BIGINT        NOT NULL,
    [idContrato]           VARCHAR (20)  NULL,
    [CPFCGCMutuario]       VARCHAR (50)  NULL,
    [nomeMutuario]         VARCHAR (150) NULL,
    [idCodigoCCA]          VARCHAR (10)  NULL,
    [idUnidadeOperacional] VARCHAR (50)  NULL,
    [idApoliceSeguro]      VARCHAR (20)  NULL,
    [dscApoliceSeguro]     VARCHAR (50)  NULL,
    [idSolicitante]        VARCHAR (50)  NULL,
    [DataArquivo]          DATE          NULL,
    [NomeArquivo]          VARCHAR (150) NULL,
    [CPFTRATADO]           AS            ((((((substring(right([CPFCGCMutuario],(11)),(1),(3))+'.')+substring(right([CPFCGCMutuario],(11)),(4),(3)))+'.')+substring(right([CPFCGCMutuario],(11)),(7),(3)))+'-')+right([CPFCGCMutuario],(2)))
);

