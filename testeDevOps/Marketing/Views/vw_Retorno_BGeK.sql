
CREATE VIEW [Marketing].[vw_Retorno_BGeK]
AS	

SELECT 
	SL.NOME AS StatusLigacao
	, sf.nome AS StatusFinal
	, A.* 
FROM Dados.Atendimento as a
LEFT OUTER JOIN Dados.Status_ligacao AS SL
ON A.IDStatus_ligacao=SL.ID
LEFT OUTER JOIN Dados.Status_final as sf
on sf.id=a.idstatus_final
WHERE 
	DataArquivo > '20150101'

