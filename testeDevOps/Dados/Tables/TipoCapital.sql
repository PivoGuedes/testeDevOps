CREATE TABLE [Dados].[TipoCapital] (
    [ID]        TINYINT      NOT NULL,
    [Descricao] VARCHAR (30) NULL,
    CONSTRAINT [PK_TIPOCAPITAL] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE TRIGGER [Dados].[trg_SendDBMail_TipoCapital]
ON [Dados].[TipoCapital]
AFTER INSERT
AS

DECLARE @ID INT
DECLARE @NomeRegistro VARCHAR(50)
DECLARE @recipients VARCHAR(100)
DECLARE @NomeTabela VARCHAR(30)
DECLARE @bodytext VARCHAR(500)

--Email
SELECT @recipients = NomesEmail 
FROM FuncionariosEmail WHERE IDGrupoEmail = 1

--Inserted
SELECT @ID = ID,
	   @NomeRegistro = Descricao
FROM INSERTED

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.TipoCapital, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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