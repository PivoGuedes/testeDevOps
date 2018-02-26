
/*
	Autor: Egler Vieira
	Data Criação: 2014-09-11 

	Descrição: 
	
	Última alteração :
	Data de alteração : 
	Descrição : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Mailing.proc_AtualizaStatusMailing_Flex
	Descrição: Procedimento que gerar o mailing que será enviado a MS.
		
	Parâmetros de entrada:
	
					
	Retorno:
	DROP TABLE #A
	
OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE Mailing.proc_AtualizaStatusMailing_Flex(@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/)
AS

	UPDATE Mailing.MailingAutoMS SET [DataEnvioMailing] = GETDATE()
	FROM Mailing.MailingAutoMS A
	INNER JOIN OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] B
	ON  B.[CPF_CNPJ_CLIENTE] COLLATE SQL_Latin1_General_CP1_CI_AI = A.[CPF]
	AND B.Data_inclusao_Calculo = A.DataRefMailing
	AND B.[SITUACAO] = '2'
	AND A.DataRefMailing = @DataMailing;
