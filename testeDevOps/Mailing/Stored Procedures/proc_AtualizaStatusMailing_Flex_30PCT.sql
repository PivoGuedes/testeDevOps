---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
	Autor: Andre Anselmo
	Data Criação: 2014-12-02

	Descrição: 
	
	Última alteração :
	Data de alteração : 
	Descrição : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Mailing.proc_AtualizaStatusMailing_KPN
	Descrição: Procedimento que gerar o mailing que será enviado a MS.
		
	Parâmetros de entrada:
	
					
	Retorno:
	DROP TABLE #A
	
OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE Mailing.proc_AtualizaStatusMailing_Flex_30PCT(@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/)
AS

	UPDATE Mailing.MailingAutoKPN SET [DataEnvioMailing] = GETDATE()
	FROM Mailing.MailingAutoKPN A
	WHERE ISNULL(MailingBGek,0)=0 AND A.DataRefMailing = @DataMailing


