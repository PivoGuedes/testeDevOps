


CREATE VIEW [DataBroker].[vw_Profissao]
   
AS 

SELECT ID,
	   Descricao,
	   CodigoCBO
FROM Dados.Profissao
WHERE Descricao <> 'OUTROS'


