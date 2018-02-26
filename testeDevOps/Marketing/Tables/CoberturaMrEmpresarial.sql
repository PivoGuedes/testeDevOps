CREATE TABLE [Marketing].[CoberturaMrEmpresarial] (
    [Codigo]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [CodigoRenovacao] BIGINT          NOT NULL,
    [Descricao]       VARCHAR (200)   NOT NULL,
    [ValorIS]         DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_CoberturaMrEmpresarial] PRIMARY KEY CLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Renovacao_CoberturaMrEmpresarial] FOREIGN KEY ([CodigoRenovacao]) REFERENCES [Marketing].[RenovacaoMrEmpresarial] ([Codigo])
);

