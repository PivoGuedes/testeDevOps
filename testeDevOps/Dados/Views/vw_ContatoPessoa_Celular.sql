
CREATE VIEW [Dados].[vw_ContatoPessoa_Celular]
AS

WITH Telefone as (
	SELECT distinct IDContatoPessoa,
			IsMobile,
			Telefone,
			Ordem
	FROM Dados.TelefoneContatoPessoa
	WHERE IsMobile = 1
)
SELECT  DISTINCT CPFCNPJ,
		CP.ID,
		O.Telefone,
		o.IsMobile,
		CPFCNPJ_AS,
		ROW_NUMBER ()  OVER (PARTITION BY CPFCNPJ,CP.ID,o.IsMobile,CPFCNPJ_AS ORDER BY O.Ordem, O.Telefone) ROW
FROM Dados.ContatoPessoa AS CP
INNER JOIN Telefone O on CP.ID = O.IDContatoPessoa

