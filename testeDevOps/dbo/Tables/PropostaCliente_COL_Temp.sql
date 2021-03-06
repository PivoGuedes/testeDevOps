﻿CREATE TABLE [dbo].[PropostaCliente_COL_Temp] (
    [CODIGOSEGURADORA]          INT             NULL,
    [NOMESEGURADORA]            VARCHAR (50)    NULL,
    [CODIGOPRODUTO]             INT             NULL,
    [NOMEPRODUTO]               VARCHAR (50)    NULL,
    [NUMEROAPOLICE]             VARCHAR (20)    NULL,
    [NUMEROPROPOSTA]            VARCHAR (20)    NULL,
    [NUMEROENDOSSO]             VARCHAR (15)    NULL,
    [APOLICEANTERIOR]           VARCHAR (30)    NULL,
    [SITUACAOENDOSSO]           CHAR (1)        NULL,
    [DATAINICIOVIGENCIAENDOSSO] DATE            NULL,
    [DATAFIMVIGENCIAENDOSSO]    DATE            NULL,
    [DATAEMISSAO]               DATE            NULL,
    [DATAPROPOSTA]              DATE            NULL,
    [DATASITUACAO]              DATE            NULL,
    [DIAVENCIMENTO]             INT             NULL,
    [VALORPREMIOLIQUIDO]        DECIMAL (19, 2) NULL,
    [VALORPREMIOBRUTO]          DECIMAL (19, 2) NULL,
    [VALORIOF]                  DECIMAL (19, 2) NULL,
    [SITUACAOPROPOSTA]          VARCHAR (1)     NULL,
    [MOTIVODASITUACAO]          VARCHAR (40)    NULL,
    [TIPOSEGURO]                CHAR (1)        NULL,
    [QUANTIDADEPARCELAS]        INT             NULL,
    [VALORPRIMEIRAPARCELA]      DECIMAL (19, 2) NULL,
    [VALORDEMAISPARCELAS]       DECIMAL (19, 2) NULL,
    [Cliente]                   INT             NULL,
    [CPFCNPJ]                   VARCHAR (19)    NULL,
    [Nome]                      VARCHAR (50)    NULL,
    [TipoPessoa]                CHAR (1)        NULL,
    [Sexo]                      CHAR (1)        NULL,
    [Complemento]               VARCHAR (20)    NULL,
    [Bairro]                    VARCHAR (30)    NULL,
    [Estado]                    VARCHAR (3)     NULL,
    [Cidade]                    VARCHAR (30)    NULL,
    [Endereco]                  VARCHAR (50)    NULL,
    [CEP]                       VARCHAR (9)     NULL,
    [DDDTelefoneComercial]      VARCHAR (5)     NULL,
    [TelefoneComercial]         VARCHAR (12)    NULL,
    [DDDTelefoneResidencia]     VARCHAR (5)     NULL,
    [TelefoneResidencia]        VARCHAR (12)    NULL,
    [DDDTelefoneMovel]          VARCHAR (5)     NULL,
    [TelefoneMovel]             VARCHAR (12)    NULL,
    [RendaFamiliar]             DECIMAL (19, 2) NULL
);

