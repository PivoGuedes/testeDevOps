﻿CREATE TABLE [dbo].[BackUpIndicadores_MatriculasErradas] (
    [Matricula]              BIGINT          NOT NULL,
    [IDCorrespondenteCerto]  INT             NOT NULL,
    [NumeroCNPJCerto]        VARCHAR (18)    NULL,
    [RazaoSocialCerto]       VARCHAR (140)   NULL,
    [IDCorrespondenteErrado] INT             NOT NULL,
    [NumeroCNPJErrado]       VARCHAR (18)    NULL,
    [RazaoSocialErrado]      VARCHAR (140)   NULL,
    [ID]                     BIGINT          NOT NULL,
    [IDProdutor]             INT             NOT NULL,
    [IDOperacao]             TINYINT         NOT NULL,
    [IDCorrespondente]       INT             NOT NULL,
    [IDFilialFaturamento]    SMALLINT        NULL,
    [NumeroRecibo]           INT             NULL,
    [IDContrato]             BIGINT          NULL,
    [IDProposta]             BIGINT          NULL,
    [NumeroEndosso]          INT             NULL,
    [NumeroParcela]          SMALLINT        NULL,
    [NumeroBilhete]          VARCHAR (20)    NULL,
    [Grupo]                  INT             NULL,
    [Cota]                   INT             NULL,
    [ValorCorretagem]        DECIMAL (19, 2) NULL,
    [DataProcessamento]      DATE            NULL,
    [NumeroContrato]         VARCHAR (20)    NULL,
    [NumeroProposta]         VARCHAR (20)    NULL,
    [Arquivo]                VARCHAR (80)    NOT NULL,
    [DataArquivo]            DATE            NOT NULL,
    [IDTipoProduto]          TINYINT         NOT NULL
);

