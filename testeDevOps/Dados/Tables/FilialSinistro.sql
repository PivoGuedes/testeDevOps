CREATE TABLE [Dados].[FilialSinistro] (
    [ID]     SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Codigo] SMALLINT     NOT NULL,
    [Nome]   VARCHAR (50) NULL,
    CONSTRAINT [PK_FILIALSINISTRO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO

CREATE TRIGGER [Dados].[trg_SendDBMail_FilialSinistro]
ON [Dados].[FilialSinistro]
AFTER INSERT
AS
DECLARE @ID INT
DECLARE @Codigo INT
DECLARE @NomeRegistro NVARCHAR(50)
DECLARE @recipients NVARCHAR(100)
DECLARE @NomeTabela NVARCHAR(30)
DECLARE @bodytext NVARCHAR(500)

--Email
SELECT @recipients = NomesEmail 
FROM FuncionariosEmail WHERE IDGrupoEmail = 1

--Inserted
SELECT @ID = ID,
	   @NomeRegistro = Nome,
	   @Codigo = Codigo
FROM Inserted

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.FilialSinistro, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Código ' + ISNULL(CAST(@Codigo AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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
	