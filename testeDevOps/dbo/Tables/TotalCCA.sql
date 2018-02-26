﻿CREATE TABLE [dbo].[TotalCCA] (
    [NUMPROPOSTA]     FLOAT (53)     NULL,
    [PROP-NOME]       NVARCHAR (255) NULL,
    [PROP-CNPJ]       NVARCHAR (255) NULL,
    [PROP-ENDERECO]   NVARCHAR (255) NULL,
    [PROP-BAIRRO]     NVARCHAR (255) NULL,
    [PROP-CIDADE]     NVARCHAR (255) NULL,
    [PROP-UF]         NVARCHAR (255) NULL,
    [PROP-CEP]        NVARCHAR (255) NULL,
    [PROP-DDD]        FLOAT (53)     NULL,
    [PROP-TELEFONE]   NVARCHAR (255) NULL,
    [PROP-DDDFAX]     NVARCHAR (255) NULL,
    [PROP-FAX]        NVARCHAR (255) NULL,
    [PROP-EMAIL]      NVARCHAR (255) NULL,
    [PROP-CLASSE]     NVARCHAR (255) NULL,
    [PROP-CODCAIXA]   FLOAT (53)     NULL,
    [PROP-SUPREG]     FLOAT (53)     NULL,
    [SOCIO-NOME]      NVARCHAR (255) NULL,
    [SOCIO-CPF]       NVARCHAR (255) NULL,
    [SOCIO-ENDERECO]  NVARCHAR (255) NULL,
    [SOCIO-BAIRRO]    NVARCHAR (255) NULL,
    [SOCIO-CIDADE]    NVARCHAR (255) NULL,
    [SOCIO-UF]        NVARCHAR (255) NULL,
    [SOCIO-CEP]       NVARCHAR (255) NULL,
    [SOCIO-DDD]       NVARCHAR (255) NULL,
    [SOCIO-TELEFONE]  NVARCHAR (255) NULL,
    [SOCIO-DDDFAX]    NVARCHAR (255) NULL,
    [SOCIO-FAX]       NVARCHAR (255) NULL,
    [SOCIO-EMAIL]     NVARCHAR (255) NULL,
    [SOCIO-FATANUAL]  FLOAT (53)     NULL,
    [DTINIVIGENCIA]   DATETIME       NULL,
    [DTFIMVIGENCIA]   DATETIME       NULL,
    [PREMIOTAR]       FLOAT (53)     NULL,
    [DESCCOBE]        FLOAT (53)     NULL,
    [BONUSREN]        FLOAT (53)     NULL,
    [DESCMEGAF]       FLOAT (53)     NULL,
    [DESCCOFRE]       FLOAT (53)     NULL,
    [DESCCONCE]       FLOAT (53)     NULL,
    [PREMIOLIQ]       FLOAT (53)     NULL,
    [CUSTOAPOL]       FLOAT (53)     NULL,
    [VLRJUROS]        FLOAT (53)     NULL,
    [VLRIOF]          FLOAT (53)     NULL,
    [PREMIOTOT]       FLOAT (53)     NULL,
    [NUMPCL]          FLOAT (53)     NULL,
    [VLRPRIMPCL]      FLOAT (53)     NULL,
    [VLRDEMAIS]       FLOAT (53)     NULL,
    [DTPRIMPCL]       DATETIME       NULL,
    [FORMAPGTO]       NVARCHAR (255) NULL,
    [NUMAPOLIC]       FLOAT (53)     NULL,
    [CODCORRETOR]     FLOAT (53)     NULL,
    [NOMCORRETOR]     NVARCHAR (255) NULL,
    [COBERTURAS1]     NVARCHAR (255) NULL,
    [LIMITEMI1]       FLOAT (53)     NULL,
    [LIMITEMA1]       FLOAT (53)     NULL,
    [LIMMAX1]         FLOAT (53)     NULL,
    [PRELIQ1]         FLOAT (53)     NULL,
    [COBERTURAS2]     NVARCHAR (255) NULL,
    [LIMITEMI2]       FLOAT (53)     NULL,
    [LIMITEMA2]       NVARCHAR (255) NULL,
    [LIMMAX2]         FLOAT (53)     NULL,
    [PRELIQ2]         FLOAT (53)     NULL,
    [COBERTURAS3]     NVARCHAR (255) NULL,
    [LIMITEMI3]       FLOAT (53)     NULL,
    [LIMITEMA3]       FLOAT (53)     NULL,
    [LIMMAX3]         FLOAT (53)     NULL,
    [PRELIQ3]         FLOAT (53)     NULL,
    [COBERTURAS4]     NVARCHAR (255) NULL,
    [LIMITEMI4]       FLOAT (53)     NULL,
    [LIMITEMA4]       FLOAT (53)     NULL,
    [LIMMAX4]         FLOAT (53)     NULL,
    [PRELIQ4]         FLOAT (53)     NULL,
    [COBERTURAS5]     NVARCHAR (255) NULL,
    [LIMITEMI5]       NVARCHAR (255) NULL,
    [LIMITEMA5]       NVARCHAR (255) NULL,
    [LIMMAX5]         FLOAT (53)     NULL,
    [PRELIQ5]         FLOAT (53)     NULL,
    [COBERTURAS6]     NVARCHAR (255) NULL,
    [LIMITEMI6]       FLOAT (53)     NULL,
    [LIMITEMA6]       FLOAT (53)     NULL,
    [LIMMAX6]         FLOAT (53)     NULL,
    [PRELIQ6]         FLOAT (53)     NULL,
    [COBERTURAS7]     NVARCHAR (255) NULL,
    [LIMITEMI7]       FLOAT (53)     NULL,
    [LIMITEMA7]       NVARCHAR (255) NULL,
    [LIMMAX7]         FLOAT (53)     NULL,
    [PRELIQ7]         FLOAT (53)     NULL,
    [COBERTURAS8]     NVARCHAR (255) NULL,
    [LIMITEMI8]       FLOAT (53)     NULL,
    [LIMITEMA8]       FLOAT (53)     NULL,
    [LIMMAX8]         FLOAT (53)     NULL,
    [PRELIQ8]         FLOAT (53)     NULL,
    [COBERTURAS9]     NVARCHAR (255) NULL,
    [LIMITEMI9]       NVARCHAR (255) NULL,
    [LIMITEMA9]       NVARCHAR (255) NULL,
    [LIMMAX9]         NVARCHAR (255) NULL,
    [PRELIQ9]         NVARCHAR (255) NULL,
    [COBERTURAS10]    NVARCHAR (255) NULL,
    [LIMITEMI10]      NVARCHAR (255) NULL,
    [LIMITEMA10]      NVARCHAR (255) NULL,
    [LIMMAX10]        NVARCHAR (255) NULL,
    [PRELIQ10]        NVARCHAR (255) NULL,
    [COBERTURAS11]    NVARCHAR (255) NULL,
    [LIMITEMI11]      NVARCHAR (255) NULL,
    [LIMITEMA11]      NVARCHAR (255) NULL,
    [LIMMAX11]        NVARCHAR (255) NULL,
    [PRELIQ11]        NVARCHAR (255) NULL,
    [TIT-NUMCDBARRA]  NVARCHAR (255) NULL,
    [TIT-DTVENCTO]    NVARCHAR (255) NULL,
    [TIT-NCEDENTE1]   NVARCHAR (255) NULL,
    [TIT-NCEDENTE2]   NVARCHAR (255) NULL,
    [TIT-CEDENTE]     NVARCHAR (255) NULL,
    [TIT-DTDOCTO]     NVARCHAR (255) NULL,
    [TIT-NUMDOCTO]    NVARCHAR (255) NULL,
    [TIT-DTPROCESS]   NVARCHAR (255) NULL,
    [TIT-NSNUMERO]    NVARCHAR (255) NULL,
    [TIT-VALDOCTO]    FLOAT (53)     NULL,
    [TIT-MENSA1]      NVARCHAR (255) NULL,
    [TIT-MENSA2]      NVARCHAR (255) NULL,
    [TIT-MENSA3]      NVARCHAR (255) NULL,
    [TIT-MENSA4]      NVARCHAR (255) NULL,
    [TIT-MENSA5]      NVARCHAR (255) NULL,
    [TIT-MENSA6]      NVARCHAR (255) NULL,
    [TIT-MENSA7]      NVARCHAR (255) NULL,
    [TIT-VALCOBRADO]  FLOAT (53)     NULL,
    [TIT-SACNOME]     NVARCHAR (255) NULL,
    [TIT-SACENDER]    NVARCHAR (255) NULL,
    [TIT-SACCEP]      NVARCHAR (255) NULL,
    [TIT-SACCGC]      NVARCHAR (255) NULL,
    [TIT-CODBAR]      NVARCHAR (255) NULL,
    [FRANQUIA1]       NVARCHAR (255) NULL,
    [FRANQUIA2]       NVARCHAR (255) NULL,
    [FRANQUIA3]       NVARCHAR (255) NULL,
    [FRANQUIA4]       NVARCHAR (255) NULL,
    [FRANQUIA5]       NVARCHAR (255) NULL,
    [FRANQUIA6]       NVARCHAR (255) NULL,
    [FRANQUIA7]       NVARCHAR (255) NULL,
    [FRANQUIA8]       NVARCHAR (255) NULL,
    [FRANQUIA9]       NVARCHAR (255) NULL,
    [FRANQUIA10]      NVARCHAR (255) NULL,
    [FRANQUIA11]      NVARCHAR (255) NULL,
    [BEN-NOME1]       NVARCHAR (255) NULL,
    [BEN-CNPJ1]       NVARCHAR (255) NULL,
    [BEN-NOME2]       NVARCHAR (255) NULL,
    [BEN-CNPJ2]       NVARCHAR (255) NULL,
    [BEN-NOME3]       NVARCHAR (255) NULL,
    [BEN-CNPJ3]       NVARCHAR (255) NULL,
    [AGENCIA]         FLOAT (53)     NULL,
    [OPER]            FLOAT (53)     NULL,
    [CONTA]           NVARCHAR (255) NULL,
    [PROD]            FLOAT (53)     NULL,
    [DS-PRODUTO]      NVARCHAR (255) NULL,
    [RAMO]            FLOAT (53)     NULL,
    [DIA-VENC-DEMAIS] FLOAT (53)     NULL,
    [Tipo]            NVARCHAR (255) NULL,
    [Situação]        NVARCHAR (255) NULL
);

