
/*******************************************************************************
	Nome: Fenae.Corporativo.proc_RecuperaPropostaSaudeComissao
	
	Descrição: Essa procedure vai consultar os dados de tratativas comerciais de propostas Protheus.
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE Dados.proc_RecuperaPropostaSaudeComissao 
--	@PontoParada VARCHAR(400)
AS

 SELECT *  FROM  OPENQUERY ([SCASE],'
  ;WITH T AS (

SELECT DISTINCT PSP_CODINT,PSP_CODEMP,PSP_NUMPRP,PI3_TPCOMI,PI3_VLCALC,PI3_PARINI,PI3_PARFIM,PI3_BASECO,''04'' AS EMPRESA,
			BQC_SUBCON,PI3_CODVEN,A3_NOME

FROM BQC040
INNER JOIN PSP040 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
			AND PSP_NUMPRP = BQC_XNUMPR 
			AND BQC040.D_E_L_E_T_='''' 
			INNER JOIN PI3040 ON PI3_FILIAL = PSP_FILIAL
			AND PI3_CODINT+PI3_CODEMP = BQC_CODIGO
			AND(( PI3_NUMPRP = BQC_XNUMPR)
			OR( PI3_CONEMP = BQC_NUMCON
			AND PI3_VERCON = BQC_VERCON))
			AND PI3040.D_E_L_E_T_=''''
INNER JOIN SA3030 ON A3_COD = PI3_CODVEN AND SA3030.D_E_L_E_T_=''''
WHERE  PSP040.D_E_L_E_T_ = ''''
)
SELECT * FROM (

SELECT EMPRESA+RIGHT(PSP_CODEMP,1)+PSP_NUMPRP+RIGHT(BQC_SUBCON,3) as NumeroProposta,
		PI3_TPCOMI AS TipoComissao,
		PI3_PARINI AS ParcelaInicialComissao,
		PI3_VLCALC AS PercentualComissao,
		PI3_PARFIM AS ParcelaFinalComissao,
		PI3_BASECO AS BaseCommissao,
		PSP_CODINT AS Operadora,
		CAST(PI3_CODVEN AS INT) AS CodigoVendedor,
		SUBSTRING(A3_NOME,1,60) AS NomeVendedor

FROM T
) AS q')

-- '

--;WITH T AS (

--SELECT  PSP_CODINT,PSP_CODEMP,PSP_NUMPRP,PI3_TPCOMI,PI3_VLCALC,PI3_PARINI,PI3_PARFIM,PI3_BASECO,''04'' AS EMPRESA,
--			PHN_CODIGO,PI3_CODVEN,A3_NOME

--FROM PSP040
--LEFT JOIN BQC040 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
--			AND ((PSP_NUMPRP = BQC_XNUMPR )
--			OR
--			( BQC_SUBCON = PSP_SUBCON
--			AND BQC_VERSUB = PSP_VERCON 
--			AND BQC_NUMCON = PSP_CONEMP
--			AND BQC_VERCON = PSP_VERCON))
--			AND BQC040.D_E_L_E_T_='''' 
--INNER JOIN PI3040 ON PI3_FILIAL = PSP_FILIAL
--			AND PI3_CODINT+PI3_CODEMP = BQC_CODIGO
--			--AND PI3_NUMPRP = BQC_NUMPRP
--			AND(( PI3_CONEMP = BQC_NUMCON
--			AND PI3_VERCON = BQC_VERCON) OR (PI3_NUMPRP = BQC_XNUMPR))
--			--AND PI3_SUBCON = BQC_SUBCON
--			--AND PI3_VERSUB = BQC_VERSUB
--			AND PI3040.D_E_L_E_T_=''''
--		--	AND PI3_CODVEN = ''000034''
--INNER JOIN PHN040 ON PSP_CODINT = PHN_CODINT 
--			AND PSP_CODEMP = PHN_CODEMP 
--			AND PSP_NUMPRP = PHN_NUMPRP 
--			AND PHN040.D_E_L_E_T_='''' 
--			AND PSP040.D_E_L_E_T_ = ''''

--INNER JOIN SA3030 ON A3_COD = PI3_CODVEN AND SA3030.D_E_L_E_T_=''''

--)
--SELECT * FROM (

--SELECT EMPRESA+RIGHT(PSP_CODEMP,1)+PSP_NUMPRP+RIGHT(PHN_CODIGO,3) as NumeroProposta,
--		PI3_TPCOMI AS TipoComissao,
--		PI3_PARINI AS ParcelaInicialComissao,
--		PI3_VLCALC AS PercentualComissao,
--		PI3_PARFIM AS ParcelaFinalComissao,
--		PI3_BASECO AS BaseCommissao,
--		PSP_CODINT AS Operadora,
--		CAST(PI3_CODVEN AS INT) AS CodigoVendedor,
--		SUBSTRING(A3_NOME,1,60) AS NomeVendedor

--FROM T
--) AS q

--')

