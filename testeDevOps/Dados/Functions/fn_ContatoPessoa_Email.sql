CREATE FUNCTION Dados.fn_ContatoPessoa_Email (@CPFCNPJ varchar(20))  
RETURNS TABLE  
AS  
RETURN  
  SELECT   CP.CPFCNPJ,  
    EP.Email,  
    ROW_NUMBER () OVER (PARTITION BY EP.IDContatoPessoa, EP.Email order by EP.DataAtualizacao) ROW  
FROM Dados.EmailContatoPessoa    EP  WITH(nolock)
INNER JOIN dados.ContatoPessoa   CP  WITH(nolock)
ON EP.IDContatoPessoa = CP.ID   
where CP.CPFCNPJ = @CPFCNPJ  