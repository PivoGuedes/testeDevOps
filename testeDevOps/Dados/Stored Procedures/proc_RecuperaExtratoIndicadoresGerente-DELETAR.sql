
/*
	Autor: Windson Santos
	Data Criação: 30/01/2015

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: Corportativo.Dados.proc_RecuperaExtratoIndicadoresGerente
	Descrição: Procedimento que realiza a recuperação do extrato de pontos de um indicador Gerente.
	           
			   
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/	

CREATE PROCEDURE [Dados].[proc_RecuperaExtratoIndicadoresGerente-DELETAR](@IDIndicador INT, @AnoCompetencia INT, @MesCompetencia int)
AS
WITH CTERE
AS
(
SELECT RI.IDFuncionario, DataArquivo, SUM(ValorBruto) ValorBruto, sum(ValorINSS) ValorINSSFuncionario, sum(valoriss) ValorISSFuncionario--, sum(ValorIRF), SUM(ValorBruto)+sum(ValorINSS)+ sum(valoriss)- sum(ValorIRF)
FROM Dados.RepremiacaoIndicadores RI
WHERE RI.DataArquivo = '2015-01-29'
GROUP BY RI.IDFuncionario, RI.DataArquivo
)
, CTEANA
as
(
SELECT P.IDFuncionario, DataArquivo, SUM(VALORBRUTO) ValorBruto
--DELETE
FROM [Dados].[PremiacaoIndicadores]  P
WHERE DataArquivo between '2015-01-29' and  '2015-01-29'
GROUP BY P.IDFuncionario, P.DataArquivo
)
, CTECEF
AS
(
SELECT RI.IDFuncionario, sum(ValorINSSRecolhidoCEF) ValorINSSRecolhidoCEF,  SUM(ISNULL(CalculadoValorINSS,0)) CalculadoValorINSSpROTHEUS
FROM Dados.RepremiacaoIndicadores RI
WHERE RI.DataArquivo between '2015-01-01' and  '2015-01-31'
GROUP BY RI.IDFuncionario
)
SELECT R.IDFuncionario, F.Matricula, F.CPF, F.Nome,  A.ValorBruto [ValorBrutoIndicador], ISNULL(R.ValorBruto,0) - ISNULL(A.ValorBruto,0)  [ValorBrutoGerente], ValorINSSFuncionario, ValorISSFuncionario, ValorINSSRecolhidoCEF, CalculadoValorINSSpROTHEUS
FROM CTERE R
LEFT JOIN CTEANA A
ON A.IDFuncionario = R.IDFuncionario
LEFT JOIN CTECEF C
ON C.IDFuncionario = A.IDFuncionario
LEFT JOIN Dados.Funcionario F
ON F.ID = R.IDFuncionario
WHERE R.IDFuncionario= @IDIndicador