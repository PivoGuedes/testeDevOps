CREATE TABLE [Dados].[ClasseFranquia] (
    [ID]        TINYINT      NOT NULL,
    [Descricao] VARCHAR (15) NULL,
    CONSTRAINT [PK_ClasseFranquia] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE TRIGGER [Dados].[trg_SendDBMail_ClasseFranquia]
ON [Dados].[ClasseFranquia]
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
FROM Inserted

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.ClasseFranquia, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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
