CREATE TABLE [Dados].[SituacaoCobranca] (
    [ID]        TINYINT       IDENTITY (1, 1) NOT NULL,
    [Sigla]     CHAR (3)      NOT NULL,
    [Descricao] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_SituacaoCobranca] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO

CREATE TRIGGER [Dados].[trg_SendDBMail_SituacaoCobranca]
ON [Dados].[SituacaoCobranca]
AFTER INSERT
AS

DECLARE @ID INT
DECLARE @NomeRegistro NVARCHAR(50)
DECLARE @recipients NVARCHAR(100)
DECLARE @NomeTabela NVARCHAR(30)
DECLARE @bodytext NVARCHAR(500)
DECLARE @Sigla CHAR(10)

--Email
SELECT @recipients = NomesEmail 
FROM FuncionariosEmail WHERE IDGrupoEmail = 1

--Inserted
SELECT @ID = ID,
	   @Sigla = Sigla,
	   @NomeRegistro = Descricao
FROM INSERTED

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.SituacaoCobranca, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Sigla ' + ISNULL(CAST(@Sigla AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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