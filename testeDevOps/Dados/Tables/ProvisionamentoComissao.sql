CREATE TABLE [Dados].[ProvisionamentoComissao] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [IdProduto]            INT             NOT NULL,
    [IdEmpresa]            SMALLINT        NOT NULL,
    [NumeroRecibo]         BIGINT          NOT NULL,
    [DataCompetencia]      DATE            NOT NULL,
    [DataProvisionamento]  DATE            NOT NULL,
    [CalculoComissao]      DECIMAL (38, 6) NOT NULL,
    [ValorProvisionamento] DECIMAL (38, 6) NOT NULL,
    [Situacao]             CHAR (1)        NULL,
    [UndNegocio]           SMALLINT        NOT NULL,
    [Estorno]              BIT             NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

