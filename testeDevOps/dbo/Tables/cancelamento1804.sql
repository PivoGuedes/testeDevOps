CREATE TABLE [dbo].[cancelamento1804] (
    [LIVRO]               FLOAT (53)     NULL,
    [PAGINA]              FLOAT (53)     NULL,
    [ORGAO]               NVARCHAR (255) NULL,
    [COD# RAMO]           FLOAT (53)     NULL,
    [RAMO]                NVARCHAR (255) NULL,
    [MES DE COMPETENCIA]  DATETIME       NULL,
    [PRODUTO]             FLOAT (53)     NULL,
    [APOLICE]             NVARCHAR (255) NULL,
    [ENDOSSO]             FLOAT (53)     NULL,
    [CERTIFICADO]         FLOAT (53)     NULL,
    [PARCELA]             FLOAT (53)     NULL,
    [MOEDA]               NVARCHAR (255) NULL,
    [DT EMISSAO]          DATETIME       NULL,
    [DT INICIO]           DATETIME       NULL,
    [DT TERMINO]          DATETIME       NULL,
    [CPFCNPJ]             NVARCHAR (255) NULL,
    [SEGURADO]            NVARCHAR (255) NULL,
    [COD# SUSEP]          FLOAT (53)     NULL,
    [CORRETOR]            NVARCHAR (255) NULL,
    [LIDER IMP# SEGURADA] FLOAT (53)     NULL,
    [COSS IMP# SEGURADA]  FLOAT (53)     NULL,
    [RESS IMP# SEGURADA]  FLOAT (53)     NULL,
    [LIDER PREMIO TARIF]  FLOAT (53)     NULL,
    [COSS PREMIO TARIF]   FLOAT (53)     NULL,
    [RESS PREMIO TARIF]   FLOAT (53)     NULL,
    [LIDER DESCONTO]      FLOAT (53)     NULL,
    [COSS DESCONTO]       FLOAT (53)     NULL,
    [LIDER ADICIONAL]     FLOAT (53)     NULL,
    [COSS ADICIONAL]      FLOAT (53)     NULL,
    [LIDER CUSTO]         FLOAT (53)     NULL,
    [LIDER IOF]           FLOAT (53)     NULL,
    [LIDER COMISSAO]      FLOAT (53)     NULL,
    [COSS COMISSAO]       FLOAT (53)     NULL,
    [RESS COMISSAO]       FLOAT (53)     NULL,
    [LIDER PREMIO TOTAL]  FLOAT (53)     NULL,
    [COSS PREMIO TOTAL]   FLOAT (53)     NULL,
    [RESS PREMIO TOTAL]   FLOAT (53)     NULL,
    [PropostaTratada]     VARCHAR (20)   NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_Proposta_1804_tmp]
    ON [dbo].[cancelamento1804]([PropostaTratada] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

