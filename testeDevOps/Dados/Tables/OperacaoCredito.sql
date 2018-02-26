CREATE TABLE [Dados].[OperacaoCredito] (
    [ID]        TINYINT      IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (30) NULL,
    CONSTRAINT [PK_OPERACAOCREDITO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_OPERACAO] UNIQUE NONCLUSTERED ([Descricao] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE TRIGGER [Dados].[trg_SendDBMail_OperacaoCredito]
ON [Dados].[OperacaoCredito]
AFTER INSERT
AS

DECLARE @ID INT
DECLARE @NomeRegistro NVARCHAR(50)
DECLARE @recipients NVARCHAR(100)
DECLARE @NomeTabela NVARCHAR(30)
DECLARE @bodytext NVARCHAR(500)

--Email
SELECT @recipients = NomesEmail 
FROM FuncionariosEmail WHERE IDGrupoEmail = 1

--Inserted
SELECT @ID = ID,
	   @NomeRegistro = Descricao
FROM INSERTED

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.OperacaoCredito, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'')+ ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
)
SELECT @bodytext = Nome
FROM Dados

IF (SELECT COUNT(*) FROM inserted) > 0
BEGIN

--SendDBMail
EXEC dbo.Dados_SendDBMail 
	@recipients = @recipients,
	@body = @bodytext

END
	