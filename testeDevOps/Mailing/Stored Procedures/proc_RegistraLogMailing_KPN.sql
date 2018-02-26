CREATE PROCEDURE [Mailing].[proc_RegistraLogMailing_KPN](@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/ , @Empresa varchar(100), @NomeArquivo varchar(100), @QtdREgistros int, @Campanha varchar(100))
AS
 IF (@QtdREgistros > 0)
 BEGIN
	INSERT INTO ControleDados.LogMailing (DataRefMailing, QtdRegistros, NomeArquivo, Empresa, Campanha, Enviado)
	VALUES (@DataMailing, @QtdREgistros, @NomeArquivo, @Empresa, @Campanha, 0);
 END
  
