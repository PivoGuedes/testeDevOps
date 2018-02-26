CREATE TABLE [dbo].[REPREMIACAOTMP2] (
    [ID]                     INT             NOT NULL,
    [IDProdutor]             INT             NOT NULL,
    [IDCorrespondente]       INT             NOT NULL,
    [IDFilialFaturamento]    SMALLINT        NULL,
    [Cidade]                 VARCHAR (70)    NULL,
    [UF]                     CHAR (2)        NULL,
    [ValorCorretagem]        DECIMAL (38, 2) NULL,
    [DataCompetencia]        DATE            NOT NULL,
    [LoteImportacaoPROTHEUS] VARCHAR (6)     NULL,
    [ItemImportacaoPROTHEUS] VARCHAR (6)     NULL,
    [DataProcessamento]      DATETIME        NULL,
    [Status]                 VARCHAR (25)    NULL,
    [IDTipoProduto]          TINYINT         NOT NULL,
    [IDCerto]                INT             NOT NULL,
    [CNPJCerto]              VARCHAR (18)    NULL,
    [ORDEM]                  BIGINT          NULL,
    [IDErrado]               INT             NOT NULL,
    [CPFCNPJErrado]          VARCHAR (18)    NULL
);

