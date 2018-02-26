
CREATE VIEW dados.vw_ContatoPessoa_Email
AS
SELECT			CP.CPFCNPJ,
				EP.Email,
				ROW_NUMBER () OVER (PARTITION BY EP.IDContatoPessoa, EP.Email order by EP.DataAtualizacao) ROW
FROM Dados.EmailContatoPessoa EP
INNER JOIN dados.ContatoPessoa CP ON EP.IDContatoPessoa = CP.ID 
