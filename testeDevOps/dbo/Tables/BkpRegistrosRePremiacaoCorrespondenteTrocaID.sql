CREATE TABLE [dbo].[BkpRegistrosRePremiacaoCorrespondenteTrocaID] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
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
    [IDTipoProduto]          TINYINT         NOT NULL
);

