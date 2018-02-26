  
  
CREATE FUNCTION [Dados].[fn_ContatoPessoa_Telefone] (@CPFCNPJ varchar(20))  
returns table  
AS  
RETURN  
  
WITH Telefone as (  
  
  
  
 SELECT distinct IDContatoPessoa,  
  
  
  
   IsMobile,  
  
  
  
   Telefone,  
  
  
  
   Ordem  
  
  
  
 FROM Dados.TelefoneContatoPessoa  WITH(nolock)
  
  
  
 WHERE IsMobile = 0  
  
  
  
)  
  
  
  
  
  
  
  
SELECT  DISTINCT CPFCNPJ,  
  
  
  
  CP.ID,  
  
  
  
  O.Telefone,  
  
  
  
  o.IsMobile,  
  
  
  
  CPFCNPJ_AS,  
  
  
  
  ROW_NUMBER ()  OVER (PARTITION BY CPFCNPJ,CP.ID,o.IsMobile,CPFCNPJ_AS ORDER BY O.Ordem, O.Telefone) ROW  
  
  
  
FROM Dados.ContatoPessoa AS CP     WITH(nolock)
  
  
  
INNER JOIN Telefone O    WITH(nolock) 
on CP.ID = O.IDContatoPessoa  
WHERE CP.CPFCNPJ = @CPFCNPJ  
  
  
  
  