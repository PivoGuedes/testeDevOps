CREATE FUNCTION Indicadores.[fn_RecuperaRateioImpostos_Idicador_Gerente](@IDIndicador INT, @DataReferencia date)
RETURNS TABLE
AS
RETURN(
WITH CTERE
	AS
	(
		SELECT RI.IDFuncionario,  SUM(ValorBruto) ValorBruto, sum(ValorINSS) ValorINSSFuncionario, sum(COALESCE(RI.ValorISS, RI.CalculadoValorISS)) ValorISS, sum(COALESCE(RI.CalculadoValorIRRF, RI.ValorIRF)) ValorIRF--, SUM(ValorBruto)+sum(ValorINSS)+ sum(valoriss)- sum(ValorIRF)
		FROM Dados.RepremiacaoIndicadores RI
		WHERE YEAR(RI.DataArquivo) = YEAR(@DataReferencia)
		  AND MONTH(RI.DataArquivo) = MONTH(@DataReferencia)
		  AND RI.IDFuncionario = @IDIndicador--5421
		GROUP BY RI.IDFuncionario
	)
	, CTEANA
	as
	(
		SELECT P.IDFuncionario,  SUM(VALORBRUTO) ValorBruto
		--DELETE
		FROM [Dados].[PremiacaoIndicadores] P
		WHERE YEAR(P.DataArquivo) = YEAR(@DataReferencia)
		  AND MONTH(P.DataArquivo) = MONTH(@DataReferencia)
		AND P.IDFuncionario = @IDIndicador--5421
		GROUP BY P.IDFuncionario, P.DataArquivo
	)
	, CTECEF
	AS
	(
		SELECT RI.IDFuncionario, ValorINSSRecolhidoCEF ValorINSSRecolhidoCEF,  ISNULL(CalculadoValorINSS,0) CalculadoValorINSSProtheus
		FROM Dados.RepremiacaoIndicadores RI
		WHERE YEAR(RI.DataArquivo) =  YEAR(@DataReferencia) 
		  AND MONTH(RI.DataArquivo) =  MONTH(@DataReferencia)
		  AND RI.IDFuncionario = @IDIndicador--5421
		--GROUP BY RI.IDFuncionario
	)
	, CTEGI
	AS
	(
		SELECT R.IDFuncionario, F.Matricula, F.CPF, F.Nome, ValorIRF, A.ValorBruto [ValorBrutoIndicador], ISNULL(R.ValorBruto,0) - ISNULL(A.ValorBruto,0)  [ValorBrutoGerente],   ValorINSSFuncionario, ValorISS, ValorINSSRecolhidoCEF, CalculadoValorINSSpROTHEUS
		FROM CTERE R
		LEFT JOIN CTEANA A
		ON A.IDFuncionario = R.IDFuncionario
		LEFT JOIN CTECEF C
		ON C.IDFuncionario = A.IDFuncionario
		LEFT JOIN Dados.Funcionario F
		ON F.ID = R.IDFuncionario
		WHERE R.IDFuncionario = @IDIndicador--5421
	)
	SELECT *
		, ABS(ValorBrutoIndicador / (ValorBrutoIndicador + ValorBrutoGerente)) * ValorIRF ValorIRFGerente
		, ABS(ValorBrutoGerente   / (ValorBrutoIndicador + ValorBrutoGerente)) * ValorIRF ValorIRFIndicador
		, ABS(ValorBrutoIndicador / (ValorBrutoIndicador + ValorBrutoGerente)) * ValorISS ValorISSGerente
		, ABS(ValorBrutoGerente   / (ValorBrutoIndicador + ValorBrutoGerente)) * ValorISS ValorISSIndicador	
	FROM CTEGI
	--OPTION (MAXDOP 7)
)
