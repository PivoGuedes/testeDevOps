CREATE TABLE [dbo].[CAD_TEMP_TMP] (
    [Codigo]                    INT             NULL,
    [CodigoEmpresa]             VARCHAR (5)     NULL,
    [DataCalculo]               DATE            NULL,
    [DataRecibo]                DATE            NULL,
    [DataCompetencia]           DATE            NULL,
    [CodigoFilial]              SMALLINT        NULL,
    [CodigoFilialProposta]      SMALLINT        NULL,
    [CodigoOperacao]            SMALLINT        NULL,
    [CodigoPontoVenda]          SMALLINT        NULL,
    [CodigoRamo]                SMALLINT        NULL,
    [NumeroParcela]             SMALLINT        NULL,
    [CodigoProduto]             VARCHAR (5)     NULL,
    [TipoCorretagem]            SMALLINT        NULL,
    [CodigoProdutor]            INT             NULL,
    [CodigoSubgrupoRamoVida]    INT             NULL,
    [NomeCliente]               VARCHAR (140)   NULL,
    [NumeroContrato]            VARCHAR (20)    NULL,
    [NumeroBilhete]             NUMERIC (15)    NULL,
    [NumeroTitulo]              NUMERIC (15)    NULL,
    [NumeroSerieTitulo]         NUMERIC (15)    NULL,
    [IndicadorTipoContribuicao] NUMERIC (15)    NULL,
    [Grupo]                     NUMERIC (15)    NULL,
    [NumeroCota]                NUMERIC (15)    NULL,
    [NumeroEndosso]             NUMERIC (9)     NULL,
    [NumeroProposta]            NUMERIC (16)    NULL,
    [NumeroPropostaTratado]     AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroProposta]))) PERSISTED,
    [NumeroPropostaInterno]     NUMERIC (16)    NULL,
    [NumeroCertificado]         NUMERIC (15)    NULL,
    [NumeroCertificadoTratado]  AS              (CONVERT([varchar](20),[dbo].[fn_TrataNumeroPropostaZeroExtra]([NumeroCertificado]))) PERSISTED,
    [NumeroReciboOriginal]      BIGINT          NULL,
    [NumeroRecibo]              BIGINT          NULL,
    [PercentualCorretagem]      NUMERIC (5, 2)  NULL,
    [ValorBase]                 NUMERIC (20, 6) NULL,
    [ValorCorretagem]           NUMERIC (20, 6) NULL,
    [DataQuitacaoParcela]       DATE            NULL,
    [RangeCEP]                  BIGINT          NULL,
    [AliquotaISS]               NUMERIC (5, 2)  NULL,
    [NomeArquivo]               VARCHAR (200)   NULL,
    [DataArquivo]               DATE            NULL,
    [IDSeguradora]              AS              (CONVERT([smallint],case [CodigoEmpresa] when '00003' then (1) when '00005' then (4) when '00004' then (3) when '00006' then (5) when '00001' then (1) when '00002' then (1) else case when CONVERT([int],[CodigoProduto])>(9400) then (4) when CONVERT([int],[CodigoProduto])>=(9201) AND CONVERT([int],[CodigoProduto])<=(9250) then (4) when CONVERT([int],[CodigoProduto])>=(5501) AND CONVERT([int],[CodigoProduto])<=(5627) then (4) when CONVERT([int],[CodigoProduto])=(60) then (5) when CONVERT([int],[CodigoProduto])>=(222) AND CONVERT([int],[CodigoProduto])<=(413) then (3) when CONVERT([int],[CodigoProduto])>=(1403) AND CONVERT([int],[CodigoProduto])<=(3180) then (1) when CONVERT([int],[CodigoProduto])=(8209) OR CONVERT([int],[CodigoProduto])=(8205) OR CONVERT([int],[CodigoProduto])=(8203) OR CONVERT([int],[CodigoProduto])=(8105) OR CONVERT([int],[CodigoProduto])=(7709) OR CONVERT([int],[CodigoProduto])=(7701) OR CONVERT([int],[CodigoProduto])=(5302) OR CONVERT([int],[CodigoProduto])=(3709) then (0) when CONVERT([int],[CodigoProduto])>=(9311) AND CONVERT([int],[CodigoProduto])<=(9361) then (0) when CONVERT([int],[CodigoProduto])=(8201) OR CONVERT([int],[CodigoProduto])=(8113) OR CONVERT([int],[CodigoProduto])=(8112) OR CONVERT([int],[CodigoProduto])=(7114) OR CONVERT([int],[CodigoProduto])=(6814) then (1) else (0) end end)) PERSISTED
);


GO
CREATE CLUSTERED INDEX [idx_CLProposta]
    ON [dbo].[CAD_TEMP_TMP]([NumeroContrato] ASC, [NumeroEndosso] ASC, [CodigoProduto] ASC, [CodigoOperacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLFilialProposta]
    ON [dbo].[CAD_TEMP_TMP]([CodigoFilialProposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCL_NumeroPropostaTratado]
    ON [dbo].[CAD_TEMP_TMP]([NumeroPropostaTratado] ASC)
    INCLUDE([NomeCliente]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLRamo]
    ON [dbo].[CAD_TEMP_TMP]([CodigoRamo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLProduto]
    ON [dbo].[CAD_TEMP_TMP]([CodigoProduto] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLOperacao]
    ON [dbo].[CAD_TEMP_TMP]([CodigoOperacao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLPontoVenda]
    ON [dbo].[CAD_TEMP_TMP]([CodigoPontoVenda] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLProposta]
    ON [dbo].[CAD_TEMP_TMP]([NumeroPropostaTratado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLCertificado]
    ON [dbo].[CAD_TEMP_TMP]([NumeroCertificadoTratado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLCodigoProdutor]
    ON [dbo].[CAD_TEMP_TMP]([CodigoProdutor] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [idx_NCLContrato]
    ON [dbo].[CAD_TEMP_TMP]([NumeroContrato] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

