CREATE TABLE [Dados].[Bloco] (
    [ID]              SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Codigo]          CHAR (6)      NOT NULL,
    [Nome]            VARCHAR (40)  NOT NULL,
    [Descricao]       VARCHAR (100) NULL,
    [IDBlocoSuperior] SMALLINT      NULL,
    [PossuiObjetivo]  BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Dados_Bloco_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Dados_Bloco_Bloco_ID] FOREIGN KEY ([IDBlocoSuperior]) REFERENCES [Dados].[Bloco] ([ID]),
    CONSTRAINT [UNQ_Dados_Bloco_Codigo] UNIQUE NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
ALTER TABLE [Dados].[Bloco] NOCHECK CONSTRAINT [FK_Dados_Bloco_Bloco_ID];


GO
CREATE TRIGGER [Dados].[trg_SendDBMail_Bloco]
ON [Dados].[Bloco]
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
	   @NomeRegistro = Descricao,
	   @Codigo = Codigo
FROM Inserted

;WITH Dados AS
(
SELECT 'Inserção dos Registros na Tabela - Dados.Bloco, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Código ' + ISNULL(CAST(@Codigo AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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
