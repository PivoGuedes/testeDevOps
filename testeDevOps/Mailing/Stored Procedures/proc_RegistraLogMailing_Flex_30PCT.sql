---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
	Autor: André Anselmo
	Data Criação: 2014-12-02

	Descrição: 
	
	Última alteração :
	Data de alteração : 
	Descrição : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Mailing.proc_RegistraLogMailing_KPN
	Descrição: Procedimento que gerar o mailing que será enviado a MS.
		
	Parâmetros de entrada:
	
					
	Retorno:
	DROP TABLE #A
	
OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE Mailing.proc_RegistraLogMailing_Flex_30PCT(@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/ , @Empresa varchar(100), @NomeArquivo varchar(100), @QtdREgistros int, @Campanha varchar(100))
AS
 IF (@QtdREgistros > 0)
 BEGIN
	INSERT INTO ControleDados.LogMailing (DataRefMailing, QtdRegistros, NomeArquivo, Empresa, Campanha, Enviado)
	VALUES (@DataMailing, @QtdREgistros, @NomeArquivo, @Empresa, @Campanha, 0);
 END

