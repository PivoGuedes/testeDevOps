CREATE TABLE [dbo].[cancelamentos_e_declinios_2016] (
    [Apólice   Proposta]         VARCHAR (800) NULL,
    [Produto]                    VARCHAR (800) NULL,
    [Agência de venda]           VARCHAR (800) NULL,
    [Canal de venda]             VARCHAR (800) NULL,
    [Início de vigência]         VARCHAR (800) NULL,
    [Fim de vigência]            VARCHAR (800) NULL,
    [Nome segurado]              VARCHAR (800) NULL,
    [CPF CNPJ do Segurado]       VARCHAR (800) NULL,
    [Endereço do local de risco] VARCHAR (800) NULL,
    [Bairro do local de risco]   VARCHAR (800) NULL,
    [Cidade local de risco]      VARCHAR (800) NULL,
    [UF local de risco]          VARCHAR (800) NULL,
    [CEP local de risco]         VARCHAR (800) NULL,
    [DDD 1 - Telefone 1]         VARCHAR (800) NULL,
    [DDD 2 - Telefone 2]         VARCHAR (800) NULL,
    [E-mail cliente]             VARCHAR (800) NULL,
    [Tipo]                       VARCHAR (800) NULL,
    [Motivo da recusa]           VARCHAR (800) NULL,
    [Descrição texto]            VARCHAR (800) NULL,
    [Tipo cancelamento]          VARCHAR (800) NULL,
    [Motivo do cancelamento]     VARCHAR (800) NULL,
    [Usuário]                    VARCHAR (800) NULL,
    [Situação pagamento]         VARCHAR (800) NULL,
    [Data declínio cancelamento] VARCHAR (800) NULL,
    [Data devolucao]             VARCHAR (800) NULL,
    [Valor pago]                 VARCHAR (800) NULL,
    [Valor devolvido]            VARCHAR (800) NULL,
    [Forma pagamento]            VARCHAR (800) NULL,
    [Conta de devolução]         VARCHAR (800) NULL,
    [Corretor]                   VARCHAR (800) NULL,
    [Matricula indicador]        VARCHAR (800) NULL,
    [Nome indicador]             VARCHAR (800) NULL,
    [ASVEN]                      VARCHAR (800) NULL
);


GO
CREATE CLUSTERED INDEX [cl_idx_prpapolice_temp]
    ON [dbo].[cancelamentos_e_declinios_2016]([Apólice   Proposta] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

