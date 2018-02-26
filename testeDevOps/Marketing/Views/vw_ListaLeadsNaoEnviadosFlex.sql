CREATE VIEW Marketing.vw_ListaLeadsNaoEnviadosFlex
AS

SELECT *
FROM Mailing.MailingAutoMS AS M
WHERE DataRefMailing='2015-03-30'
AND DataEnvioMailing IS NULL
--AND DataGEracao='2015-03-30 17:54:39.8300000'
AND EXISTS
(
	SELECT * FROM OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] 
	WHERE Data_Inclusao_Calculo='2015-03-30' AND Situacao=2
	AND CPF_CNPJ_CLIENTE=M.CPF COLLATE Latin1_general_CI_AI
) 
