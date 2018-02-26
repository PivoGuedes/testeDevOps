
/*******************************************************************************
	Nome: Fenae.Corporativoproc_RecuperaPlanos_Protheus
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE Dados.proc_RecuperaPropostaPlano 
--	@PontoParada VARCHAR(400)
AS

 SELECT *  FROM  OPENQUERY ([SCASE],'

;with cte as (SELECT DISTINCT PSP_NUMPRP,
								Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub, 
								PSP_CODINT,
								PSP_CODEMP,
								PSP_CONEMP,
								PSP_SUBCON,
								''04'' as EMPRESA,
								--PHL_CODPLA,
								--PHL_VERPLA,
								COALESCE(BT6_CODPRO,PHL_CODPLA) AS PHL_CODPLA,
								COALESCE(BT6_VERSAO,PHL_VERPLA) AS PHL_VERPLA --INSERIR TAMBÉM A SUB

						FROM PSP040
						INNER JOIN PHN040 ON 
								PSP_CODINT = PHN_CODINT AND 
								PSP_CODEMP = PHN_CODEMP AND 
								PSP_NUMPRP = PHN_NUMPRP AND 
								PHN040.D_E_L_E_T_='''' AND 
								PSP040.D_E_L_E_T_ = ''''

						INNER JOIN PHL040 ON PHL_FILIAL = PSP_FILIAL 
									AND PHL_CODINT = PSP_CODINT
									AND PHL_CODEMP = PSP_CODEMP 
									AND PHL_NUMPRP = PSP_NUMPRP 
									AND PHL040.D_E_L_E_T_=''''
						LEFT JOIN BQC040 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
										AND PSP_NUMPRP = BQC_XNUMPR 
										AND BQC040.D_E_L_E_T_='''' 
										AND BQC_SUBCON = PHN_SUBCON
										AND BQC_VERSUB = PHN_VERCON
										AND BQC_NUMCON = PHN_CONEMP
										AND BQC_VERCON = PHN_VERCON
						LEFT JOIN BT6040 ON BT6_FILIAL = BQC_FILIAL
										AND BT6_CODINT = BQC_CODINT
										AND BT6_CODIGO = BQC_CODEMP
										AND BT6_NUMCON = BQC_NUMCON
										AND BT6_VERCON = BQC_VERCON
										AND BT6_SUBCON = BQC_SUBCON
										AND BT6_VERSUB = BQC_VERSUB
										AND BT6040.D_E_L_E_T_=''''
					
					UNION ALL

						SELECT DISTINCT PSP_NUMPRP,
								Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub, 
								PSP_CODINT,
								PSP_CODEMP,
								PSP_CONEMP,
								PSP_SUBCON,
								''03'' as EMPRESA,
								--PHL_CODPLA,
								--PHL_VERPLA,
								COALESCE(BA3_CODPLA,PSU_CODPLA) AS PHL_CODPLA,
								COALESCE(BA3_VERSAO,PSU_VERSAO) AS PHL_VERPLA --INSERIR TAMBÉM A SUB

						FROM PSP030
						INNER JOIN PHN030 ON 
								PSP_CODINT = PHN_CODINT AND 
								PSP_CODEMP = PHN_CODEMP AND 
								PSP_NUMPRP = PHN_NUMPRP AND 
								PHN030.D_E_L_E_T_='''' AND 
								PSP030.D_E_L_E_T_ = ''''
						INNER JOIN PSU030 ON 
								PSP_CODINT = PSU_CODINT AND 
								PSP_CODEMP = PSU_CODEMP AND 
								PSP_NUMPRP = PSU_NUMPRP AND 
								PSU030.D_E_L_E_T_='''' AND 
								PSP030.D_E_L_E_T_ = ''''					
						LEFT JOIN BQC030 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
										AND PSP_NUMPRP = BQC_XNUMPR 
										AND BQC030.D_E_L_E_T_='''' 										
						LEFT JOIN BA3030 ON BA3_FILIAL = BQC_FILIAL
										AND BA3_CODINT = BQC_CODINT
										AND BA3_CODEMP = BQC_CODEMP
										AND BA3_NUMCON = BQC_NUMCON
										AND BA3_VERCON = BQC_VERCON
										AND BA3_SUBCON = BQC_SUBCON
										AND BA3_VERSUB = BQC_VERSUB
										AND BA3030.D_E_L_E_T_=''''
						WHERE (PSP_CODINT+PSP_CODEMP  <> ''00040001'')

						UNION ALL

						SELECT DISTINCT PSP_NUMPRP,
								Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub, 
								PSP_CODINT,
								PSP_CODEMP,
								PSP_CONEMP,
								PSP_SUBCON,
								''03'' as EMPRESA,
								--PHL_CODPLA,
								--PHL_VERPLA,
								COALESCE(BT6_CODPRO,PHL_CODPLA) AS PHL_CODPLA,
								COALESCE(BT6_VERSAO,PHL_VERPLA) AS PHL_VERPLA --INSERIR TAMBÉM A SUB

						FROM PSP030
						INNER JOIN PHN030 ON 
								PSP_CODINT = PHN_CODINT AND 
								PSP_CODEMP = PHN_CODEMP AND 
								PSP_NUMPRP = PHN_NUMPRP AND 
								PHN030.D_E_L_E_T_='''' AND 
								PSP030.D_E_L_E_T_ = ''''

						INNER JOIN PHL030 ON PHL_FILIAL = PSP_FILIAL 
									AND PHL_CODINT = PSP_CODINT
									AND PHL_CODEMP = PSP_CODEMP 
									AND PHL_NUMPRP = PSP_NUMPRP 
									AND PHL030.D_E_L_E_T_=''''
						LEFT JOIN BQC030 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
										AND PSP_NUMPRP = BQC_XNUMPR 
										AND BQC030.D_E_L_E_T_='''' 
										AND BQC_SUBCON = PHN_SUBCON
										AND BQC_VERSUB = PHN_VERCON
										AND BQC_NUMCON = PHN_CONEMP
										AND BQC_VERCON = PHN_VERCON
						LEFT JOIN BT6030 ON BT6_FILIAL = BQC_FILIAL
										AND BT6_CODINT = BQC_CODINT
										AND BT6_CODIGO = BQC_CODEMP
										AND BT6_NUMCON = BQC_NUMCON
										AND BT6_VERCON = BQC_VERCON
										AND BT6_SUBCON = BQC_SUBCON
										AND BT6_VERSUB = BQC_VERSUB
										AND BT6030.D_E_L_E_T_=''''

									WHERE (PSP_CODINT+PSP_CODEMP  = ''00040001'')
						)

				SELECT * FROM 
				(

				SELECT 	Case when Cast(PSP_CODINT as Int) = 1 then 18
							else Cast(PSP_CODINT as Int) End as IDSeguradora,
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroProposta, --INSERIR TAMBÉM A SUB
						--EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroPropostaEMISSAO, --INSERIR TAMBÉM A SUB
						Cast(Sub as int) as SubGrupo,
						--CASE WHEN EMPRESA = ''04''
						--	AND PSP_CODEMP in (''0001'',''0002'',''0003'') THEN  53
						--	WHEN EMPRESA = ''04'' 
						--	AND PSP_CODEMP in (''0004'',''0005'',''0006'') THEN  50
						--	WHEN EMPRESA = ''04'' 
						--	AND PSP_CODEMP in (''0007'') THEN  51
						--	WHEN EMPRESA = ''03'' THEN 52
						--	ELSE 48
						--End as [CodigoRamoPAR],
						PHL_CODPLA AS [CodigoPlano],
						PHL_VERPLA AS [VersaoPlano],
						EMPRESA
											
				FROM	cte
				)	A							  
					')

--WHERE CTE.NumeroProposta = '001201400671965'


