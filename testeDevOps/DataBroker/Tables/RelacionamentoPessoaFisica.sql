CREATE TABLE [DataBroker].[RelacionamentoPessoaFisica] (
    [ID]                    INT     IDENTITY (1, 1) NOT NULL,
    [IDPessoaFisicaOrigem]  INT     NOT NULL,
    [IDPessoaFisicaDestino] INT     NOT NULL,
    [IDTipoRelacionamento]  TINYINT NOT NULL
);

