
--DROP VIEW [Dados].[vw_ContatoPessoa] 


	CREATE VIEW [Dados].[vw_ContatoPessoa] 

	WITH SCHEMABINDING

	AS



	SELECT CPFCNPJ, Celular, Fixo, Email, CPFCNPJ_AS

	FROM Dados.ContatoPessoa AS CP

	OUTER APPLY (SELECT TOP 1 Telefone AS Celular FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=1 ORDER BY Ordem) AS Cel

	OUTER APPLY (SELECT TOP 1 Telefone AS Fixo FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=0 ORDER BY Ordem) AS Fixo

	OUTER APPLY (SELECT TOP 1 Email FROM Dados.EmailContatoPessoa AS E WHERE CP.ID=E.IDContatoPessoa ORDER BY Ordem Desc) AS Em

	--WHERE CPFCNPJ IN ('832.737.941-00','971.417.633-68','215.958.658-70')



