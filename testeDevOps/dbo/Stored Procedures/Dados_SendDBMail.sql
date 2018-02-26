
/*
	Autor: Diego Lima
	Data Criação: 13/12/2013

	Descrição: Criação do cabeçalho. 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_SendDBMail
	Descrição: Procedimento que realiza a criação do profile do dbemail (conexão).

	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [dbo].[Dados_SendDBMail]
	@recipients VARCHAR(500),
	@body VARCHAR(500),
	@subject VARCHAR(500) = 'Inserção de Registros na Tabela de Domínio'
AS
BEGIN
	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Corretora',
		@recipients = @recipients,
		@body = @body,
		@subject = @subject;
END

--EXEC dbo.Dados_SendDBMail 
--	@recipients = 'luanmorenomaciel@hotmail.com ; eglermail@gmail.com',
--	@body = ''

--SELECT *
--FROM msdb.[dbo].[sysmail_mailitems]
--SELECT *
--FROM msdb.[dbo].[sysmail_log]

--@query
--notificacaobox@parcorretora.com.br
