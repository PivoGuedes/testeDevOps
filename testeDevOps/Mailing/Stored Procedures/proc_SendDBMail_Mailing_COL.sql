
CREATE PROCEDURE [Mailing].[proc_SendDBMail_Mailing_COL]
	@DataReferencia date,
	@Campanha varchar(100),
	@Empresa varchar(100)
	
AS
BEGIN
--DECLARE @DataReferencia date = '2014-09-19'
--DECLARE	@Campanha varchar(100) = 'AQAUTSIS20130704'
--DECLARE	@Empresa varchar(100) = 'BGeK'

DECLARE @Corpo NVARCHAR(MAX)
DECLARE @Destinatarios VARCHAR(MAX)
DECLARE @DestinatariosCC VARCHAR(MAX)
DECLARE @Assunto NVARCHAR(500)
DECLARE @NomeArquivo VARCHAR(100)
DECLARE @QtdRegistros INT

SELECT TOP 1 @NomeArquivo = NomeArquivo, @QtdRegistros = QtdRegistros 
FROM ControleDados.[LogMailing] 
WHERE Empresa = @Empresa
AND Campanha = @Campanha
AND DataRefMailing = @DataReferencia
AND Enviado = 0


SELECT TOP 1
             @Assunto = Assunto
            ,@Corpo = REPLACE(REPLACE(Cast(Corpo as NVARCHAR(MAX)), N'@QtdRegistros', Cast(@QtdRegistros as Nvarchar(MAX))), N'@NomeArquivo', Cast(@NomeArquivo as NVARCHAR(100)))
			,@Destinatarios = Destinatarios
			,@DestinatariosCC = DestinatariosCC
FROM [Mailing].[ParametrosEmail]
WHERE Empresa = @Empresa
AND Campanha = @Campanha
AND Ativo = 1


--PRINT @Corpo
--DECLARE @A VARCHAR(MAX) = 'AAA'
--SELECT REPLACE(@A, N'A', N'B')



IF ISNULL(@QtdRegistros,0) > 0
	BEGIN
		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Corretora',
			--@recipients = 'lincolnsantiago@parcorretora.com.br',
			@recipients = @Destinatarios,
			@copy_recipients = @DestinatariosCC,
			@body_format='TEXT',
			@body = @Corpo,
			@subject = @Assunto;	
	END 


IF ISNULL(@QtdRegistros,0) > 0
	BEGIN
		UPDATE [ControleDados].[LogMailing] SET Enviado = 1
		WHERE Empresa = @Empresa
		AND Campanha = @Campanha
		AND DataRefMailing = @DataReferencia
	END

END





