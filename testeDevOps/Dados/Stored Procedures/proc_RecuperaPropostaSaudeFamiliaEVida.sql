﻿


/*******************************************************************************
	Nome: Fenae.Corporativo.proc_RecuperaPropostaSaudeFamiliaEVida
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaPropostaSaudeFamiliaEVida] 
--	@PontoParada VARCHAR(400)
AS

 SELECT *  FROM  OPENQUERY ([SCASE],'

;WITH PRP040 AS (SELECT DISTINCT
	PSP_FILIAL,
	  PSP_CODINT,
	  PSP_CODEMP,
	  PSP_CONEMP,
	  PSP_VERCON,
	  PSP_SUBCON,
	  PSP_VERSUB,
	  PSP_NUMPRP
		
FROM PSP040 WITH (NOLOCK)
INNER JOIN PHN040 ON PSP_FILIAL = PHN_FILIAL
			 AND PSP_CODINT = PHN_CODINT 
			 AND PSP_CODEMP = PHN_CODEMP 
			 AND PSP_NUMPRP = PHN_NUMPRP
			 AND PHN040.D_E_L_E_T_=''''
			 AND PHN_SUBCON = PSP_SUBCON
			 AND PHN_CONEMP = PSP_CONEMP
			 AND PHN_VERCON = PSP_VERCON
			 AND PHN_VERSUB = PSP_VERSUB
			 AND PSP_CODINT <> ''0010''	) , VIDA040 AS (

SELECT 	DISTINCT	BA1_CODINT,
		BA1_CODEMP,
		BA1_MATRIC,
		BA1_CONEMP,
		BA1_NOMUSR,
		BA1_XP2CAR,
		BA1_XOUCAR,
		BA1_GRAUPA,
		BA1_CPFUSR,
		BA1_ESTCIV,
		BA1_MAE,
		BA1_TIPUSU,
		BA1_XGRPCA,
		BA1_XGCODO,
		BA1_SUBCON,
		BA1_VERSUB,
		BA1_VERCON,
		BA1_FILIAL,
		BQC_XNUMPR,
		BA1_XP2KCA,
		X5_DESCRI,
		BIH_DESCRI,
		BA3_CODPLA,
		BA3_VERSAO,
		BRP_DESCRI,
		CAST(BA1_XDTVIG AS Date) as BA1_XDTVIG,
		CAST(ISNULL(NULLIF(BA1_DATBLO,''''),''99991230'') AS Date) as BA1_DATBLO,
		BA1_MOTBLO,
		BG1_DESBLO,
		BG1_TIPBLO,
		BA1_TIPREG,
		BA1_DIGITO


		FROM BA1040 

 INNER  JOIN BQC040 ON BQC_FILIAL = BA1_FILIAL
			AND BQC_CODIGO = BA1_CODINT+BA1_CODEMP
			AND BA1_CONEMP = BQC_NUMCON
			AND BA1_VERCON = BQC_VERCON
			AND BA1_SUBCON = BQC_SUBCON
			AND BA1_VERSUB = BQC_VERSUB
	--		AND BQC_XNUMPR = PSP_NUMPRP
			AND BQC040.D_E_L_E_T_=''''
	
 INNER  JOIN BA3040 ON BA1_FILIAL = BA3_FILIAL
			AND BA3_CODINT = BA1_CODINT
			AND BA3_CODEMP = BA1_CODEMP
			AND BA3_MATRIC = BA1_MATRIC
			AND BA3040.D_E_L_E_T_ = ''''
			AND BA1_CONEMP = BA3_CONEMP
			AND BA1_SUBCON = BA3_SUBCON
			AND BA1_VERCON = BA3_VERCON
			AND BA1_VERSUB = BA3_VERSUB
			AND BA3040.D_E_L_E_T_=''''
			AND BA1040.D_E_L_E_T_=''''
 INNER JOIN BIH040 ON BIH_FILIAL = BA1_FILIAL AND BIH_CODTIP = BA1_TIPUSU AND BIH040.D_E_L_E_T_=''''
 INNER JOIN BRP040 ON BRP_FILIAL = BA1_FILIAL AND BRP_CODIGO = BA1_GRAUPA AND BRP040.D_E_L_E_T_=''''
 LEFT JOIN SX5040 ON X5_TABELA = ''Z7'' AND X5_CHAVE = BA1_XP2KCA AND SX5040.D_E_L_E_T_=''''
 LEFT JOIN BG1030 ON BG1_FILIAL = BA1_FILIAL AND BG1_CODBLO = BA1_MOTBLO AND BG1030.D_E_L_E_T_=''''
	--	ORDER BY BA1_MATRIC,BA1_NOMUSR
	WHERE BA1_CODINT <> ''0010''

), PRP030 AS (SELECT 
	PSP_FILIAL,
	  PSP_CODINT,
	  PSP_CODEMP,
	  PSP_CONEMP,
	  PSP_VERCON,
	  PSP_SUBCON,
	  PSP_VERSUB,
	  PSP_NUMPRP,
	  PSP_CODCLI
		
FROM PSP030 
WHERE D_E_L_E_T_=''''),
VIDA030 AS (
SELECT 
BA1_CODINT,
		BA1_CODEMP,
		BA1_MATRIC,
		BA1_CONEMP,
		BA1_NOMUSR,
		BA1_XP2CAR,
		BA1_XOUCAR,
		BA1_GRAUPA,
		BA1_CPFUSR,
		BA1_ESTCIV,
		BA1_MAE,
		BA1_TIPUSU,
		BA1_XGRPCA,
		BA1_XGCODO,
		BA1_SUBCON,
		BA1_VERSUB,
		BA1_VERCON,
		BA1_FILIAL,
		BA3_XNUMPR,
		BA1_XP2KCA,
		X5_DESCRI,
		BIH_DESCRI,
		BA3_CODPLA,
		BA3_VERSAO,
		BRP_DESCRI,
		CAST(BA1_XDTVIG AS Date) as BA1_XDTVIG,
		CAST(ISNULL(NULLIF(BA1_DATBLO,''''),''99991230'') AS Date) as BA1_DATBLO,
		BA1_MOTBLO,
		BG1_DESBLO,
		BG1_TIPBLO,
		BA1_TIPREG,
		BA1_DIGITO,
		BA3_CODCLI

 FROM  BA3030
 INNER JOIN BA1030 ON BA3_FILIAL = BA1_FILIAL
		AND BA3_CODINT = BA1_CODINT
		AND BA3_CODEMP = BA1_CODEMP
		AND BA3_MATRIC = BA1_MATRIC
		AND BA3_CONEMP = BA1_CONEMP
		AND BA3_VERCON = BA1_VERCON
		AND BA3_SUBCON = BA1_SUBCON
		AND BA3_VERSUB = BA1_VERSUB
		AND BA1030.D_E_L_E_T_=''''
 INNER JOIN BRP030 ON BRP_FILIAL = BA1_FILIAL AND BRP_CODIGO = BA1_GRAUPA AND BRP030.D_E_L_E_T_=''''
 LEFT JOIN BQC030 ON BA3_FILIAL = BQC_FILIAL
		AND BA3_CODINT+BA3_CODEMP= BQC_CODIGO
		AND BA3_CONEMP = BQC_NUMCON
		AND BA3_VERCON = BQC_VERCON
		AND BA3_SUBCON = BQC_SUBCON
		AND BA3_VERSUB = BQC_VERSUB
		AND BQC030.D_E_L_E_T_=''''
LEFT JOIN SX5030 ON X5_TABELA = ''Z7'' AND X5_CHAVE = BA1_XP2KCA AND SX5030.D_E_L_E_T_=''''
LEFT JOIN BIH030 ON BIH_FILIAL = BA1_FILIAL AND BIH_CODTIP = BA1_TIPUSU AND BIH030.D_E_L_E_T_=''''

LEFT JOIN BG1030 ON BG1_FILIAL = BA1_FILIAL AND BG1_CODBLO = BA1_MOTBLO AND BG1030.D_E_L_E_T_=''''

)

SELECT * FROM (

SELECT 	PSP_FILIAL,
		Case when Cast(PSP_CODINT as Int) = 1 then 18
		else Cast(PSP_CODINT as Int) End AS OperadoraProposta,
		PSP_CODEMP,
		PSP_CONEMP,
		PSP_VERCON,
		PSP_SUBCON,
		PSP_VERSUB,
		PSP_NUMPRP,
		BA1_CODINT,
		BA1_CODEMP,
		BA1_MATRIC,
		BA1_CONEMP,
		BA1_NOMUSR,
		''04'' as EMPRESA,
		COALESCE(NULLIF(BA1_XP2CAR,''''),NULLIF(BA1_XOUCAR,'''')) CARTEIRINHA,
		case when PSP_CODINT = ''0001'' THEN ''04''+RIGHT(PSP_CODEMP,1)+PSP_NUMPRP+RIGHT(BA1_SUBCON,3)
		when PSP_CODINT = ''0010'' THEN ''04''+RIGHT(PSP_CODEMP,2)+PSP_NUMPRP+RIGHT(BA1_SUBCON,3) 
		ELSE''04''+RIGHT(PSP_CODEMP,1)+PSP_NUMPRP+RIGHT(BA1_SUBCON,3) END as NumeroProposta,

		BA1_GRAUPA,
		BA1_CPFUSR,
		Case when BA1_ESTCIV = ''S'' THEN 1 
									when BA1_ESTCIV = ''C'' THEN 2 
									when BA1_ESTCIV = ''V'' THEN 3 
									when BA1_ESTCIV = ''D'' THEN 5
									ELSE 10 
		END as BA1_ESTCIV,
		BA1_MAE,
		BA1_TIPUSU,
		COALESCE(NULLIF(BA1_XGRPCA,''''),NULLIF(BA1_XGCODO,'''')) GRPCARENCIA,
		BA1_SUBCON,
		BA1_VERSUB,
		BA1_VERCON,
		BA1_FILIAL,
		BQC_XNUMPR,
		BA1_XP2KCA,
		X5_DESCRI,
		BIH_DESCRI,
		BA3_CODPLA,
		BA3_VERSAO,
		BRP_DESCRI,
		CAST(BA1_XDTVIG AS Date) as BA1_XDTVIG,
		CAST(ISNULL(NULLIF(BA1_DATBLO,''''),''99991230'') AS Date) as BA1_DATBLO,
		BA1_MOTBLO,
		BG1_DESBLO,
		BG1_TIPBLO,
		BA1_TIPREG,
		BA1_DIGITO
	   
FROM VIDA040
LEFT JOIN PRP040
ON PRP040.PSP_FILIAL = VIDA040.BA1_FILIAL
			AND VIDA040.BA1_CODINT = PRP040.PSP_CODINT
			AND	VIDA040.BA1_CODEMP = PRP040.PSP_CODEMP
			AND VIDA040.BQC_XNUMPR = PSP_NUMPRP
		WHERE PSP_NUMPRP IS NOT NULL --AND PSP_NUMPRP = ''000000000338''
UNION ALL 

	SELECT 	PSP_FILIAL,
			Case when Cast(PSP_CODINT as Int) = 1 then 18
			else Cast(PSP_CODINT as Int) End AS OperadoraProposta,
			PSP_CODEMP,
			PSP_CONEMP,
			PSP_VERCON,
			PSP_SUBCON,
			PSP_VERSUB,
			PSP_NUMPRP,
			BA1_CODINT,
		BA1_CODEMP,
		BA1_MATRIC,
		BA1_CONEMP,
		BA1_NOMUSR,
		''03'' as EMPRESA,
		COALESCE(NULLIF(BA1_XP2CAR,''''),NULLIF(BA1_XOUCAR,'''')) CARTEIRINHA,
		''03''+RIGHT(PSP_CODEMP,1)+PSP_NUMPRP+RIGHT(BA1_SUBCON,3) as NumeroProposta,
		BA1_GRAUPA,
		BA1_CPFUSR,
		Case when BA1_ESTCIV = ''S'' THEN 1 
									when BA1_ESTCIV = ''C'' THEN 2 
									when BA1_ESTCIV = ''V'' THEN 3 
									when BA1_ESTCIV = ''D'' THEN 5
									ELSE 10 
		END as BA1_ESTCIV,
		BA1_MAE,
		BA1_TIPUSU,
		COALESCE(NULLIF(BA1_XGRPCA,''''),NULLIF(BA1_XGCODO,'''')) GRPCARENCIA,
		BA1_SUBCON,
		BA1_VERSUB,
		BA1_VERCON,
		BA1_FILIAL,
		BA3_XNUMPR,
		BA1_XP2KCA,
		X5_DESCRI,
		BIH_DESCRI,	
		BA3_CODPLA,
		BA3_VERSAO,
		BRP_DESCRI,
		CAST(BA1_XDTVIG AS Date) as BA1_XDTVIG,
		CAST(ISNULL(NULLIF(BA1_DATBLO,''''),''99991230'') AS Date) as BA1_DATBLO,
		BA1_MOTBLO,
		BG1_DESBLO,
		BG1_TIPBLO,
		BA1_TIPREG,
		BA1_DIGITO

	FROM PRP030
	INNER JOIN VIDA030 ON BA1_CODINT = PSP_CODINT
			AND BA1_CODEMP = PSP_CODEMP
			AND BA1_CONEMP = PSP_CONEMP
			AND BA1_SUBCON = PSP_SUBCON
		--	AND BA3_XNUMPR = PSP_NUMPRP
			AND BA3_CODCLI = PSP_CODCLI
	) A ORDER BY BA1_CODINT,BA1_CODEMP,BA1_CONEMP,BA1_MATRIC,BA1_NOMUSR
		
				  
					')



