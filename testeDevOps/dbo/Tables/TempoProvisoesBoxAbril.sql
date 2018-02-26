CREATE TABLE [dbo].[TempoProvisoesBoxAbril] (
    [IDOperacao]             TINYINT         NULL,
    [IDFilialFaturamento]    SMALLINT        NULL,
    [IDUnidadeVenda]         INT             NOT NULL,
    [IDCanalVendaPAR]        INT             NOT NULL,
    [IDSeguradora]           INT             NOT NULL,
    [IDEmpresa]              INT             NOT NULL,
    [IDCanalMestre]          INT             NOT NULL,
    [IDProduto]              INT             NULL,
    [IDProdutor]             INT             NOT NULL,
    [percentualcorretagem]   FLOAT (53)      NULL,
    [valorcorretagem]        DECIMAL (19, 2) NULL,
    [valorbase]              DECIMAL (19, 2) NULL,
    [datacompetencia]        DATE            NULL,
    [datacalculo]            DATE            NULL,
    [codigoproduto]          FLOAT (53)      NULL,
    [LancamentoManual]       INT             NOT NULL,
    [canalcodigo]            VARCHAR (4)     NOT NULL,
    [canalcodigohierarquico] VARCHAR (4)     NOT NULL,
    [canalnome]              VARCHAR (21)    NOT NULL,
    [canaldatainicio]        VARCHAR (10)    NOT NULL,
    [valorcorretagem1]       DECIMAL (19, 2) NULL
);

