﻿CREATE TABLE [Dados].[TipoSeguradoCertificado] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Codigo]    TINYINT      NOT NULL,
    [Descricao] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_TipoSeguradoCertificado_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [UNQ_TipoSegurado] UNIQUE NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO


--------------------------------------------

--                                        --

--        TipoSeguradoCertificado  

--                                        --

--------------------------------------------

CREATE TRIGGER [Dados].[Dados_TipoSeguradoCertificado_ChangeTracking] on [Dados].[TipoSeguradoCertificado] for insert, update, delete

AS

SET NOCOUNT ON

DECLARE @bit INT ,

@field INT ,

@maxfield INT ,

@char INT ,

@fieldname VARCHAR(64) ,

@TableName VARCHAR(64) ,

@TableSchema VARCHAR(64) ,

@TableName_Full varchar(256) ,

@PKCols VARCHAR(1000) ,

@sql VARCHAR(2000) ,

@UpdateDate VARCHAR(21) ,

@UserName VARCHAR(64) ,

@Type CHAR(1) ,

@PKFieldSelect varchar(1000),

--@PKValueSelect varchar(1000), 

@OldValueSQL VARCHAR(128) ,

@NewValueSQL VARCHAR(128) ,

@fieldtype VARCHAR(32) ,

@compatible_triggerfield BIT

--You will need to change @TableName to match the table to be audited

select @TableName = 'TipoSeguradoCertificado'

select @TableSchema = 'Dados'

SELECT @TableName_Full = '[Dados].[TipoSeguradoCertificado]'

-- date and user

SELECT	@UserName = SYSTEM_USER , @UpdateDate = CONVERT(VARCHAR(8), GETDATE(), 112)

+ ' ' + CONVERT(VARCHAR(12), GETDATE(), 114)

-- Action

IF EXISTS (SELECT * FROM inserted)

IF EXISTS (SELECT * FROM deleted)

SELECT @Type = 'U'

ELSE

SELECT @Type = 'I'

ELSE

SELECT @Type = 'D'

-- get list of columns

SELECT [ID],[Codigo],[Descricao] INTO #ins FROM inserted

SELECT [ID],[Codigo],[Descricao] INTO #del FROM deleted

-- Get primary key columns for full outer join

SELECT @PKCols = COALESCE(@PKCols + ' and', ' on')

  + ' i.' + cu.COLUMN_NAME + ' = d.' + cu.COLUMN_NAME

  FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,

 INFORMATION_SCHEMA.KEY_COLUMN_USAGE cu

  WHERE   pk.TABLE_NAME = @TableName
  
  AND    pk.TABLE_SCHEMA = @TableSchema

  AND     CONSTRAINT_TYPE = 'PRIMARY KEY'

  AND     cu.TABLE_NAME = pk.TABLE_NAME

  AND     cu.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

-- Get primary key select for insert

SELECT @PKFieldSelect = COALESCE(@PKFieldSelect+'+','')

  + '''<' + COLUMN_NAME

  + '=''+convert(varchar(100), coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+''>'''


  FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,

  INFORMATION_SCHEMA.KEY_COLUMN_USAGE cu

  WHERE   pk.TABLE_NAME = @TableName
  
  AND    pk.TABLE_SCHEMA = @TableSchema

  AND     CONSTRAINT_TYPE = 'PRIMARY KEY'

  AND     cu.TABLE_NAME = pk.TABLE_NAME

  AND     cu.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

IF @PKCols IS NULL

BEGIN

  RAISERROR('no PK on table %s', 16, -1, @TableName)

  RETURN

END

SELECT @field = 0,

  @maxfield = MAX(ORDINAL_POSITION)

  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName

WHILE @field < @maxfield

BEGIN

SELECT @field = MIN(ORDINAL_POSITION)

  FROM INFORMATION_SCHEMA.COLUMNS

  WHERE TABLE_NAME = @TableName
  
  AND   TABLE_SCHEMA = @TableSchema

  AND ORDINAL_POSITION > @field

SELECT @bit = (@field - 1 )% 8 + 1

SELECT @bit = POWER(2,@bit - 1)

SELECT @char = ((@field - 1) / 8) + 1

IF SUBSTRING(COLUMNS_UPDATED(),@char, 1) & @bit > 0

  OR @Type IN ('I','D')

BEGIN

SELECT @fieldname = COLUMN_NAME, @fieldtype = DATA_TYPE  

  FROM INFORMATION_SCHEMA.COLUMNS

  WHERE TABLE_NAME = @TableName
  
  AND   TABLE_SCHEMA = @TableSchema

  AND ORDINAL_POSITION = @field

IF @fieldtype = 'text' or @fieldtype = 'ntext' or @fieldtype = 'image' SET @compatible_triggerfield = 0 else SET @compatible_triggerfield = 1

SET @OldValueSQL = ',convert(varchar(1000),d.' + @fieldname + ')'

SET @NewValueSQL = ',convert(varchar(1000),i.' + @fieldname + ')'

IF @compatible_triggerfield = 0

BEGIN

SET @OldValueSQL = ',''n/a'''

SET @NewValueSQL = ',''n/a'''

END	  

SELECT @sql = '

insert ControleDados.Auditoria (    Type,

  TableName,

  PrimaryKeyField,

--  PrimaryKeyValue,
  
  FieldName,

  FieldType,	    

  OldValue,

  NewValue,

  UpdateDate,

  UserName)

select ''' + @Type + ''','''

+ @TableName + ''',' + @PKFieldSelect

--+ ',''' + @PKValueSelect + ''''

+ ',''' + @fieldname + ''''

+ ',''' + @fieldtype + ''''

+ @OldValueSQL

+ @NewValueSQL

+ ',''' + @UpdateDate + ''''

+ ',''' + @UserName + ''''

+ ' from #ins i full outer join #del d'

+ @PKCols

IF @compatible_triggerfield = 1

BEGIN

  SET @sql = @sql

  + ' where i.' + @fieldname + ' <> d.' + @fieldname

  + ' or (i.' + @fieldname + ' is null and  d.'

+ @fieldname

+ ' is not null)'

  + ' or (i.' + @fieldname + ' is not null and  d.'

+ @fieldname

+ ' is null)'

END

EXEC (@sql)

--EXECUTE spWriteStringToFile @sql,'c:\','test.txt'

END

END


GO

CREATE TRIGGER [Dados].[trg_SendDBMail_TipoSeguradoCertificado]
ON [Dados].[TipoSeguradoCertificado]
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
SELECT 'Inserção dos Registros na Tabela - Dados.TipoSeguradoCertificado, ID do Registro: ' + ISNULL(CAST(@ID AS VARCHAR),'') + ', Código ' + ISNULL(CAST(@Codigo AS VARCHAR),'') + ', Nome do Registro: ' + ISNULL(@NomeRegistro,'') + '' AS Nome
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
	