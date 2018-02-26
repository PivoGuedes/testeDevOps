CREATE TABLE [dbo].[BaseIndicadoresCache] (
    [AnoMes]             INT          NULL,
    [CPF]                VARCHAR (50) NULL,
    [Conta]              VARCHAR (50) NULL,
    [Matricula]          VARCHAR (50) NULL,
    [MatriculaDV]        VARCHAR (50) NULL,
    [Nome]               VARCHAR (50) NULL,
    [ValorComissao]      VARCHAR (50) NULL,
    [ValorINS]           VARCHAR (50) NULL,
    [ValorINSSemp]       VARCHAR (50) NULL,
    [ValorIRPF]          VARCHAR (50) NULL,
    [ValorISS]           VARCHAR (50) NULL,
    [ValorPontosEnv]     VARCHAR (50) NULL,
    [ValorPontosINS]     VARCHAR (50) NULL,
    [ValorPontosINSSemp] VARCHAR (50) NULL,
    [ValorPontosIRPF]    VARCHAR (50) NULL,
    [ValorPontosISS]     VARCHAR (50) NULL,
    [ValorComissaoCalc]  AS           (CONVERT([decimal](19,2),[ValorComissao])),
    [CPF_Format]         VARCHAR (20) NULL
);

