
/*******************************************************************************
	Nome: Fenae.Corporativo.proc_RecuperaPlanoFaixaEtariaProposta
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE Dados.proc_RecuperaPlanoFaixaEtariaProposta 
--	@PontoParada VARCHAR(400)
AS

 SELECT *  FROM  OPENQUERY ([SCASE],'
;with cte as (SELECT distinct PSP_CODINT,
								PSP_CODEMP,
								PSP_NUMPRP,
								PSP_CODCAN, --TABELA VIDAS
							---DESCRIÇÃO TABELAVIDAS NA PSC,
								''04'' as EMPRESA,
								Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub, 
								PSP_ADESAO,
								--DESCRI ADESAO
								PSP_ESTTAB,
								PSP_COPART,
								PHM_IDAINI AS IDAINI,
								PHM_IDAFIN AS IDAFIN,
								PHM_VALFAI AS VALFAI,
								--VALIDADE
								PHL_CODPLA AS CODPLA,
								PHL_VERPLA AS VERPLA ,
								PSC_DESCRI
								
								--IDPLANO
								--IDPROPOSTA		

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
						LEFT JOIN PHM040 ON PHM_CODINT = PSP_CODINT
										AND PHM_CODEMP = PSP_CODEMP
										AND PHM_NUMPRP = PSP_NUMPRP
										AND PHM_CODPLA = PHL_CODPLA  
										AND PHM_VERPLA = PHL_VERPLA
										AND PHM_FORPAG = PHL_FORPAG
										AND PHM040.D_E_L_E_T_=''''
						INNER JOIN PSC040 ON PSC_CODIGO = PSP_CODCAN
										AND PSC040.D_E_L_E_T_=''''
							WHERE PHL_CODPLA IS NOT NULL AND PHM_VALFAI IS NOT NULL
					
					UNION ALL
					SELECT 	distinct	PSP_CODINT,
								PSP_CODEMP,
								PSP_NUMPRP,
								PSP_CODCAN, --TABELA VIDAS
								--DESCRIÇÃO TABELAVIDAS NA PSC,
								''04'' as EMPRESA,
								RIGHT(BQC_SUBCON,3) as Sub,
								PSP_ADESAO,
								--DESCRI ADESAO
								PSP_ESTTAB,
								PSP_COPART,								
								BTN_IDAINI AS IDAINI,
								BTN_IDAFIN AS IDAFIN,
								BTN_VALFAI AS VALFAI,
								BTN_CODPRO AS CODPLA,
								BTN_VERPRO AS VERPLA,
								PSC_DESCRI					
						FROM PSP040
						INNER JOIN BQC040 ON PSP_FILIAL = BQC_FILIAL
									AND	PSP_CODINT = BQC_CODINT
									AND PSP_CODEMP = BQC_CODEMP
									AND PSP_NUMPRP = BQC_XNUMPR
									AND PSP040.D_E_L_E_T_=''''	
						LEFT JOIN BT6040 ON BT6_FILIAL = BQC_FILIAL
										AND BT6_CODINT = BQC_CODINT
										AND BT6_CODIGO = BQC_CODEMP
										AND BT6_NUMCON = BQC_NUMCON
										AND BT6_VERCON = BQC_VERCON
										AND BT6_SUBCON = BQC_SUBCON
										AND BT6_VERSUB = BQC_VERSUB
										AND BT6040.D_E_L_E_T_=''''					
						LEFT JOIN BTN040 ON BTN_FILIAL = BT6_FILIAL
										AND BTN_CODIGO = BT6_CODINT+BT6_CODIGO
										AND BTN_NUMCON = BT6_NUMCON
										AND BTN_VERCON = BT6_VERCON
										AND BTN_SUBCON = BT6_SUBCON
										AND BTN_VERSUB = BT6_VERSUB
										AND BTN_CODPRO = BT6_CODPRO
										AND BTN_VERPRO = BT6_VERSAO
										AND BTN040.D_E_L_E_T_=''''
						INNER JOIN PSC040 ON PSC_CODIGO = PSP_CODCAN
										AND PSC040.D_E_L_E_T_=''''
							WHERE BTN_CODPRO IS NOT NULL AND BTN_VALFAI IS NOT NULL

						UNION ALL

						SELECT DISTINCT PSP_CODINT,
								PSP_CODEMP,
								PSP_NUMPRP,
								PSP_CODCAN, --TABELA VIDAS
								--DESCRIÇÃO TABELAVIDAS NA PSC,
								''03'' as EMPRESA,
								RIGHT(BA3_SUBCON,3) as Sub,
								PSP_ADESAO,
								--DESCRI ADESAO
								PSP_ESTTAB,
								PSP_COPART,								
								BTN_IDAINI AS IDAINI,
								BTN_IDAFIN AS IDAFIN,
								BTN_VALFAI AS VALFAI,
								BA3_CODPLA AS CODPLA,
								BA3_VERSAO AS VERPLA,
								PSC_DESCRI
						FROM PSP030					
						INNER JOIN PSU030 ON 
								PSP_CODINT = PSU_CODINT AND 
								PSP_CODEMP = PSU_CODEMP AND 
								PSP_NUMPRP = PSU_NUMPRP AND 
								PSU030.D_E_L_E_T_ = ''''	AND 
								PSP030.D_E_L_E_T_ = ''''					
						LEFT JOIN BA3030 ON BA3_FILIAL = PSP_FILIAL
										AND BA3_CODINT = PSP_CODINT
										AND BA3_CODEMP = PSP_CODEMP
										AND BA3_NUMCON = PSP_CONEMP
										AND BA3_VERCON = PSP_VERCON
										AND BA3_SUBCON = PSP_SUBCON
										AND BA3_VERSUB = PSP_VERSUB
										AND BA3_XNUMPR = PSP_NUMPRP
										AND BA3030.D_E_L_E_T_=''''
						LEFT JOIN BT6030 ON BT6_FILIAL = BA3_FILIAL
										AND BT6_CODINT = BA3_CODINT
										AND BT6_CODIGO = BA3_CODEMP
										AND BT6_NUMCON = BA3_NUMCON
										AND BT6_VERCON = BA3_VERCON
										AND BT6_SUBCON = BA3_SUBCON
										AND BT6_VERSUB = BA3_VERSUB
										AND BT6030.D_E_L_E_T_=''''						
						LEFT JOIN BTN030 ON BTN_FILIAL = BT6_FILIAL
										AND BTN_CODIGO = BT6_CODINT+BT6_CODIGO
										AND BTN_NUMCON = BT6_NUMCON
										AND BTN_VERCON = BT6_VERCON
										AND BTN_SUBCON = BT6_SUBCON
										AND BTN_VERSUB = BT6_VERSUB
										AND BTN_CODPRO = BT6_CODPRO
										AND BTN_CODPRO = BA3_CODPLA
										AND BTN_VERPRO = BT6_VERSAO
										AND BTN030.D_E_L_E_T_=''''
						INNER JOIN PSC030 ON PSC_CODIGO = PSP_CODCAN
										AND PSC030.D_E_L_E_T_=''''
						WHERE BTN_CODPRO IS NOT NULL AND/* (PSP_CODINT+PSP_CODEMP  <> ''00040001'') AND */BA3_CODPLA is NOT NULL AND BTN_VALFAI IS NOT NULL	
						)

				SELECT * FROM 
				(

				SELECT distinct 	Case when Cast(PSP_CODINT as Int) = 1 then 18
							else Cast(PSP_CODINT as Int) End as IDSeguradora,
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroProposta, --INSERIR TAMBÉM A SUB
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroPropostaEMISSAO, --INSERIR TAMBÉM A SUB
						Sub as SubGrupo,
						CASE WHEN EMPRESA = ''04'' 
							AND PSP_CODEMP in (''0001'',''0002'',''0003'') THEN  53
							WHEN EMPRESA = ''04'' 
							AND PSP_CODEMP in (''0004'',''0005'',''0006'') THEN  50
							WHEN EMPRESA = ''04'' 
							AND PSP_CODEMP in (''0007'') THEN  51
							WHEN EMPRESA = ''03'' THEN 52
							ELSE 48
						End as [CodigoRamoPAR],
						CODPLA AS [CodigoPlano],
						VERPLA AS [VersaoPlano],
						VALFAI,
						IDAINI,
						IDAFIN,
						PSP_CODCAN as TipoTabVidas, 
						PSP_ADESAO as TipoAdesao,
						PSP_ESTTAB as Estado,
						PSP_COPART as Coparticipacao,
						PSC_DESCRI as DescTabVid,
						EMPRESA

											
				FROM	cte
				
				)	A							  
					ORDER BY NumeroProposta,SubGrupo,CodigoPlano,IDAINI,IDAFIN						  
					')

--WHERE CTE.NumeroProposta = '001201400671965'


