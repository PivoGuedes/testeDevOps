CREATE TABLE [dbo].[ARQUIVO_PROPOSTA] (
    [NumeroCertificado]  VARCHAR (50) NULL,
    [NumeroApolice]      VARCHAR (50) NULL,
    [NumeroProposta]     VARCHAR (50) NULL,
    [NumeroEndosso]      VARCHAR (50) NULL,
    [Parcela]            VARCHAR (50) NULL,
    [Valor]              VARCHAR (50) NULL,
    [certificado2]       AS           ('0'+[numerocertificado]) PERSISTED,
    [apolice2]           AS           ('000000'+[NUMEROAPOLICE]) PERSISTED,
    [parcela2]           AS           (right('0000'+[parcela],(4))) PERSISTED,
    [CertificadoTratado] AS           (case when left([NumeroCertificado],(2))='77' then right([numerocertificado],(15)) else [NumeroCertificado] end) PERSISTED,
    [proposta2]          AS           ([dbo].[fn_TrataNumeroPropostaZeroExtra]([numeroproposta])) PERSISTED
);


GO
CREATE CLUSTERED INDEX [cl_ix_tmp]
    ON [dbo].[ARQUIVO_PROPOSTA]([certificado2] ASC, [apolice2] ASC, [parcela2] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_ix_cert_tmp]
    ON [dbo].[ARQUIVO_PROPOSTA]([CertificadoTratado] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

