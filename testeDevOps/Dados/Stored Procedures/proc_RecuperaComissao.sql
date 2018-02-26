

/*******************************************************************************
	Nome: Fenae.Corporativo.proc_RecuperaComissao
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaComissao] 
--	@PontoParada VARCHAR(400)
AS
/*
 SELECT *  FROM  OPENQUERY ([SCASE],'
 ;WITH CTE AS (
SELECT Z06_NMFILF,Z06_VLPREM,Z06_VLCOMI,Z06_ANOMES,Z06_CDFILF,Z06_PARCEL,BQC_NUMPRP,Z06_CDRAM3 as Operadora,BQC_CODEMP,
		Z06_DTRECI,PH7_BAXFAT,''04'' AS EMPRESA,PH7_SUBCON,Z06_TPCOMI,PH7_PRVLCA,Z06_SEGMEN,Z06_NOMCON,7 as IDEmpresa,
		CAST(''7''+CAST(Z06020.R_E_C_N_O_ AS VARCHAR)  AS INT) AS NumeroEndosso,Z06_IDFILP AS CanalVenda,Z06_NMFILP AS DescricaoCanalVenda,
		Z06_CDRAM3,Z06_QTAPOL AS QtApolices
FROM Z06020	
LEFT JOIN SC5020 ON Z06_NUMPV = C5_NUM AND C5_CLIENT = Z06_CLIENT AND SC5020.D_E_L_E_T_=''''
LEFT JOIN PH7040 ON PH7_EMPFAT = ''02'' AND PH7_CODFAT = Z06_CODIGO AND PH7040.D_E_L_E_T_=''''
LEFT JOIN BQC040 ON BQC_CODINT = PH7_CODINT AND BQC_CODEMP = PH7_CODEMP AND 
		BQC_NUMPRP = PH7_NUMPRP AND BQC_CONEMP = PH7_CONEMP AND
		BQC_VERCON = PH7_VERCON AND BQC_SUBCON = PH7_SUBCON AND
		BQC_VERSUB = PH7_VERSUB AND BQC040.D_E_L_E_T_=''''
		
UNION ALL

SELECT Z06_NMFILF,Z06_VLPREM,Z06_VLCOMI,Z06_ANOMES,Z06_CDFILF,Z06_PARCEL,BQC_NUMPRP,Z06_CDRAM3 as Operadora,BQC_CODEMP,
		Z06_DTRECI,PH7_BAXFAT,''04'' AS EMPRESA,PH7_SUBCON,Z06_TPCOMI,PH7_PRVLCA,Z06_SEGMEN,Z06_NOMCON,16 as IDEmpresa,
		CAST(''16''+CAST(Z06050.R_E_C_N_O_ AS VARCHAR)  AS INT) AS NumeroEndosso,Z06_IDFILP AS CanalVenda,Z06_NMFILP AS DescricaoCanalVenda,
		Z06_CDRAM3,Z06_QTAPOL AS QtApolices
FROM Z06050
LEFT JOIN SC5050 ON Z06_NUMPV = C5_NUM AND C5_CLIENT = Z06_CLIENT AND SC5050.D_E_L_E_T_=''''
LEFT JOIN PH7040 ON PH7_EMPFAT = ''05'' AND PH7_CODFAT = Z06_CODIGO AND PH7040.D_E_L_E_T_=''''
LEFT JOIN BQC040 ON BQC_CODINT = PH7_CODINT AND BQC_CODEMP = PH7_CODEMP AND 
		BQC_NUMPRP = PH7_NUMPRP AND BQC_CONEMP = PH7_CONEMP AND
		BQC_VERCON = PH7_VERCON AND BQC_SUBCON = PH7_SUBCON AND
		BQC_VERSUB = PH7_VERSUB AND BQC040.D_E_L_E_T_=''''
)


SELECT   *
			FROM (

			SELECT NULL AS IDRamo,
					Z06_VLCOMI as ValorCorretagem,
					PH7_PRVLCA AS PercentualCorretagem,
					Z06_VLPREM as ValorBase,
					Z06_VLCOMI as ValorComissaoPAR,
					0 as ValorRepasse,
					Z06_ANOMES+''01'' AS DataCompetencia,
					CAST(Z06_DTRECI AS DATE) as DataRecibo,
					null as NumeroRecibo,
					NumeroEndosso,
					Z06_PARCEL as NumeroParcela,
					CAST(Z06_DTRECI AS DATE) AS DataCalculo,
					NULLIF(Cast(PH7_BAXFAT as Date),''1900-01-01'') AS DataQuitacaoParcela,
					Case When Z06_TPCOMI = ''A'' THEN 1
						When Z06_TPCOMI =''P'' THEN 2
						ELSE 3 END AS TipoCorretagem,
					--NULL AS IDOperacao,
					--NULL AS IDProdutor,
					--NULL AS IDFilialFaturamento,
					--NULL AS CodigoSubGrupoRamoVida,
					--NULL AS IDProduto,
					--NULL AS IDUnidadeVenda,
					--NULL AS IDProposta,
					--NULL AS IDCanalVendaPAR,
					EMPRESA+RIGHT(BQC_CODEMP,1)+BQC_NUMPRP+RIGHT(PH7_SUBCON,3) as NumeroProposta,
					--NULL AS CodigoProduto,
					--NULL AS LancamentoManual,
					--NULL AS Repasse,
					''PROTHEUS'' AS Arquivo,
					--NULL AS DataArquivo,
					Operadora,
					EMPRESA,
					Z06_SEGMEN as Segmento,
					Z06_NOMCON as NomeContrato,
					IDEmpresa,
					CanalVenda,
					DescricaoCanalVenda,
					case when Cast(Z06_CDRAM3 AS iNT) = 1 then 18
					when Cast(Z06_CDRAM3 AS iNT) = 2 then 42
					when Cast(Z06_CDRAM3 AS iNT) = 3 then 43
					when Cast(Z06_CDRAM3 AS iNT) = 4 then 44 
					when Cast(Z06_CDRAM3 AS iNT) = 5 then 45
					when Cast(Z06_CDRAM3 AS iNT) = 6 then 46
					when Cast(Z06_CDRAM3 AS iNT) = 7 then 47 
					End 
					IDSeguradora,
					QtApolices
	
					from CTE


	
	
						)  AS X 


					')

GO
	

*/



SELECT *  FROM  OPENQUERY ([SCASE],'
 ;WITH CTE AS (
SELECT Z06_NMFILF,Z06_VLPREM,Z06_VLCOMI,Z06_ANOMES,Z06_CDFILF,Z06_PARCEL,BQC_XNUMPR,Z06_CDRAM3 as Operadora,BQC_CODEMP,
		Z06_DTRECI,PH7_BAXFAT,''04'' AS EMPRESA,PH7_SUBCON,Z06_TPCOMI,PH7_PRVLCA,Z06_SEGMEN,Z06_NOMCON,7 as IDEmpresa,
		CAST(''7''+CAST(Z06020.R_E_C_N_O_ AS VARCHAR)  AS INT) AS NumeroEndosso,Z06_IDFILP AS CanalVenda,Z06_NMFILP AS DescricaoCanalVenda,
		Z06_CDRAM3,Z06_QTAPOL AS QtApolices
FROM Z06020	
LEFT JOIN SC5020 ON Z06_NUMPV = C5_NUM AND C5_CLIENT = Z06_CLIENT AND SC5020.D_E_L_E_T_=''''
LEFT JOIN PH7040 ON PH7_EMPFAT = ''02'' AND PH7_CODFAT = Z06_CODIGO AND PH7040.D_E_L_E_T_=''''
LEFT JOIN BQC040 ON BQC_CODINT = PH7_CODINT AND BQC_CODEMP = PH7_CODEMP AND 
		BQC_XNUMPR = PH7_NUMPRP AND BQC_NUMCON = PH7_CONEMP AND
		BQC_VERCON = PH7_VERCON AND BQC_SUBCON = PH7_SUBCON AND
		BQC_VERSUB = PH7_VERSUB AND BQC040.D_E_L_E_T_=''''
		
UNION ALL

SELECT Z06_NMFILF,Z06_VLPREM,Z06_VLCOMI,Z06_ANOMES,Z06_CDFILF,Z06_PARCEL,BQC_XNUMPR,Z06_CDRAM3 as Operadora,BQC_CODEMP,
		Z06_DTRECI,PH7_BAXFAT,''04'' AS EMPRESA,PH7_SUBCON,Z06_TPCOMI,PH7_PRVLCA,Z06_SEGMEN,Z06_NOMCON,16 as IDEmpresa,
		CAST(''16''+CAST(Z06050.R_E_C_N_O_ AS VARCHAR)  AS INT) AS NumeroEndosso,Z06_IDFILP AS CanalVenda,Z06_NMFILP AS DescricaoCanalVenda,
		Z06_CDRAM3,Z06_QTAPOL AS QtApolices
FROM Z06050
LEFT JOIN SC5050 ON Z06_NUMPV = C5_NUM AND C5_CLIENT = Z06_CLIENT AND SC5050.D_E_L_E_T_=''''
LEFT JOIN PH7040 ON PH7_EMPFAT = ''05'' AND PH7_CODFAT = Z06_CODIGO AND PH7040.D_E_L_E_T_=''''
LEFT JOIN BQC040 ON BQC_CODINT = PH7_CODINT AND BQC_CODEMP = PH7_CODEMP AND 
		BQC_XNUMPR = PH7_NUMPRP AND BQC_NUMCON = PH7_CONEMP AND
		BQC_VERCON = PH7_VERCON AND BQC_SUBCON = PH7_SUBCON AND
		BQC_VERSUB = PH7_VERSUB AND BQC040.D_E_L_E_T_=''''
)


SELECT   *
			FROM (

			SELECT NULL AS IDRamo,
					Z06_VLCOMI as ValorCorretagem,
					PH7_PRVLCA AS PercentualCorretagem,
					Z06_VLPREM as ValorBase,
					Z06_VLCOMI as ValorComissaoPAR,
					0 as ValorRepasse,
					Z06_ANOMES+''01'' AS DataCompetencia,
					CAST(Z06_DTRECI AS DATE) as DataRecibo,
					null as NumeroRecibo,
					NumeroEndosso,
					Z06_PARCEL as NumeroParcela,
					CAST(Z06_DTRECI AS DATE) AS DataCalculo,
					NULLIF(Cast(PH7_BAXFAT as Date),''1900-01-01'') AS DataQuitacaoParcela,
					Case When Z06_TPCOMI = ''A'' THEN 1
						When Z06_TPCOMI =''P'' THEN 2
						ELSE 3 END AS TipoCorretagem,
					--NULL AS IDOperacao,
					--NULL AS IDProdutor,
					--NULL AS IDFilialFaturamento,
					--NULL AS CodigoSubGrupoRamoVida,
					--NULL AS IDProduto,
					--NULL AS IDUnidadeVenda,
					--NULL AS IDProposta,
					--NULL AS IDCanalVendaPAR,
					EMPRESA+RIGHT(BQC_CODEMP,1)+BQC_XNUMPR+RIGHT(PH7_SUBCON,3) as NumeroProposta,
					--NULL AS CodigoProduto,
					--NULL AS LancamentoManual,
					--NULL AS Repasse,
					''PROTHEUS'' AS Arquivo,
					--NULL AS DataArquivo,
					Operadora,
					EMPRESA,
					Z06_SEGMEN as Segmento,
					Z06_NOMCON as NomeContrato,
					IDEmpresa,
					CanalVenda,
					DescricaoCanalVenda,
					case when Cast(Z06_CDRAM3 AS iNT) = 1 then 18
					when Cast(Z06_CDRAM3 AS iNT) = 2 then 42
					when Cast(Z06_CDRAM3 AS iNT) = 3 then 43
					when Cast(Z06_CDRAM3 AS iNT) = 4 then 44 
					when Cast(Z06_CDRAM3 AS iNT) = 5 then 45
					when Cast(Z06_CDRAM3 AS iNT) = 6 then 46
					when Cast(Z06_CDRAM3 AS iNT) = 7 then 47 
					when Cast(Z06_CDRAM3 AS iNT) = 8 then 50
					End 
					IDSeguradora,
					QtApolices
	
					from CTE


	
	
						)  AS X 


					')


