

/*******************************************************************************
	Nome: Fenae.Corporativo[proc_RecuperaProposta_e_Contrato_Saude]
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaProposta_e_Contrato_Saude] 
--	@PontoParada VARCHAR(400)
AS

SELECT null as IDContrato,
						case when Cast(PSP_CODINT AS iNT) = 1 then 18
								when Cast(PSP_CODINT AS iNT) = 2 then 42
								when Cast(PSP_CODINT AS iNT) = 3 then 43
								when Cast(PSP_CODINT AS iNT) = 4 then 44 
								when Cast(PSP_CODINT AS iNT) = 5 then 2 
								when Cast(PSP_CODINT AS iNT) = 10 then 286 
								End as IDSeguradora,
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroProposta, --INSERIR TAMBÉM A SUB
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroPropostaEMISSAO, --INSERIR TAMBÉM A SUB
						null as	IDProduto,
						null as	IDProdutoAnterior,
						null as IDProdutoSIGPF,
						2 as IDPeriodicidadePagamento, --MENSAL
						EMPRESA+PSP_CODUNI  as CanalVendaPAR,
						cast(PSP_DATA  as Date) as DataProposta,
						NULLIF(Cast(PSP_DTVIGE as Date),'1900-01-01') as DataInicioVigencia,
						NULLIF(cast(DataFimVigencia as Date),'1900-01-01') as DataFimVigencia,
						null as IDFucionario,
						PSP_VALOR as Valor,
						null as RendaIndividual,
						null as RendaFamiliar,
						null as AgenciaVenda,
						Cast(PSP_DTVIGE as Date) as DataSituacao,
						Case When StatusProposta = '6' then 1
							When StatusProposta IN('1','2','3','4','5') then 20
							Else 25
						End as IDSituacaoProposta,
						5 as IDSituacaoCobranca,
						-1 as IDTipoMotivo,
						N'PROTHEUS - SAÚDE' as TipoDado,
						GetDate() as DataArquivo,
						PSP_VALOR as ValorPremioBrutoEmissao,
						PSP_VALOR as ValorPremioLiquidoEmissao,
						null as ValorPremioBrutoCalculado,
						null as ValorPremioLiquidoCalculado,
						null as ValorPagoAcumulado,
						null as ValorPremioTotal,
						null as RenovacaoAutomatica, --verificar.....
						null as PercentualDesconto,
						null as EmpresaConvenente,
						null as MatriculaConvenente,
						null as OpcaoCobertura,
						null as CodigoPlano,
						null as DataAutenticacaoSICOB,
						null as AgenciaPagamentoSICOB,
						null as TarifaCobrancaSICOB,
						null as DataCreditoSASSESICOB,
						null as ValorComissaoSICOB,
						null as PeriodicidadePagamento,
						null as OpcaoConjuge,
						null as OrigemProposta,
						null as DeclaracaoSaudeTitular,
						null as DeclaracaoSaudeConjuge,
						null as AposentadoriaInvalidez,
						PSP_CODCAN as CodigoSegmento,
						RIGHT(BQC_SUBCON,3)  as SubGrupo,
						US_NOME AS Nome,
						US_CEP as CepResidencial,
						US_END as EnderecoResidencial,
						US_CGC as CNPJCPF,
						US_XTIPLOG as TipoLogradouroResidencial,
						US_XNR_END as NumeroEnderecoResidencial,
						US_XCOMEND as ComplementoEnderecoResidencial,
						US_BAIRRO as BairroResidencial,
						US_MUN AS CidadeResidencial,
						US_EST AS EstadoResidencial,
						US_DDD AS DDDResidencial,
						US_TEL AS TelefoneResidencial,
						EMPRESA,
						PSP_CODINT AS SeguradoraProtheus,
						BA0_NOMINT AS NomeSeguradora,
						RTRIM(US_XCEPCOB)  AS CEPCobranca,
						RTRIM(US_XENDCOB)  as EnderecoCobranca,
						RTRIM(US_XTIPLOC)  as TipoLogradouroCobranca,
						RTRIM(US_XNUMENC)  as NumeroEnderecoCobranca,
						RTRIM(US_XCOMENC)  as ComplementoEnderecoCobranca,
						RTRIM(US_XBAIRRC)  as BairroCobranca,
						RTRIM(US_XMUNCOB)  AS CidadeCobranca,
						RTRIM(US_XESTCOB)  AS EstadoCobranca,
						RTRIM(US_XDDDC) AS DDDCobranca,
						RTRIM(US_XTELC) AS TelefoneCobranca,
						RTRIM(US_XCEPE) AS CEPCorrespondencia,
						RTRIM(US_XENDENT) as EnderecoCorrespondencia,
						RTRIM(US_XTIPLOE) as TipoLogradouroCorrespondencia,
						RTRIM(US_XNRENDE) as NumeroEnderecoCorrespondencia,
						RTRIM(US_XCOMENE) as ComplementoEnderecoCorrespondencia,
						RTRIM(US_XBAIRRE) as BairroCorrespondencia,
						RTRIM(US_XESTE) AS EstadoCorrespondencia,
						RTRIM(US_XMUNE) AS CidadeCorrespondencia,
						RTRIM(US_XDDDE) AS DDDCorrespondencia,
						RTRIM(US_XTELE) AS TelefoneCorrespondencia,
						US_EMAIL AS Email,
						null as EmailComercial,
						PSP_CODEMP as SegmentoProtheus,
						Case When PSP_TIPPAG = '01' then 2
							When PSP_TIPPAG = '02' then 1
							else 5 End as CodigoFormaPagamento,
						Cast(PSP_BANCO as Int) as Banco, 
						PSP_AGENCI+PSP_DIGAGE as Agencia,
						PSP_CONTA+PSP_DIGCTA as ContaCorrente,
						PSP_OPERAC as Operacao,
						Case WHEN EMPRESA = '04' AND PSP_CODEMP IN ('0001','0002','00003') then PSP_VENCTO
							WHEN (EMPRESA = '04' AND PSP_CODEMP IN ('0004','0005','00006','0007') AND PSP_CODINT = '0001') OR (EMPRESA = '04' AND PSP_CODINT = '0010') THEN PSP_XVENOU
							ELSE PSP_VENCTO
						End as DiaVencimento,
						--select * from dados.ramopar
						CASE WHEN EMPRESA = '04' 
							AND PSP_CODEMP in ('0001','0002','0003') AND PSP_CODINT = '0001' THEN  53
							WHEN EMPRESA = '04' 
							AND PSP_CODEMP in ('0004','0005','0006') AND PSP_CODINT = '0001' THEN  50
							WHEN EMPRESA = '04' 
							AND PSP_CODEMP in ('0007') AND PSP_CODINT = '0001' THEN  51
							WHEN EMPRESA = '03' THEN 52
							WHEN EMPRESA = '04' AND PSP_CODINT = '0010' THEN 50
							ELSE 48
						End as [CodigoRamoPAR],						
						--EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP AS NumeroContrato,
						EMPRESA+Right(PSP_CODEMP,1)+PSP_NUMPRP+Sub as NumeroContrato, --INSERIR TAMBÉM A SUB
						PSP_COPART AS Coparticipacao,
						Case When PSP_ADESAO = 'C' Then 1
						When PSP_ADESAO = 'V' Then 2
						Else 3
						End AS IDTipoAdesao,
						[DataNascimento],
						[IDSexo],
						[IDEstadoCivil],
						[Identidade],
						[OrgaoExpedidor],
						[DataExpedicaoRG],
						[DescricaoSegmento],
						[DescricaoCanal],
						[StatusProposta],
						Case When PSP_CODVEN = '000034' THEN 'Corretor Próprio'
						Else 'Corretor Externo' end
						AS NomeCanal
						
																											
				FROM												  
	OPENQUERY ([SCASE], 'SELECT PSP_NUMPRP,
			Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub, 
			PSP_CODUNI,
			PSP_DATA,
			PSP_DTVIGE,
			PSP_VALOR,
			PSP_CODCAN,
			PSP_CODFAS,
			COALESCE(A1_NOME,US_NOME) AS US_NOME,
			US_CEP,
			US_CGC,
			US_BAIRRO,
			US_MUN,
			US_XNR_END,
			US_XCOMEND,
			US_END,
			US_EST,
			US_DDD,
			US_TEL,
			US_XDDDCOM,
			US_XTELCOM,
			US_XRAMCOM,
			US_XVENCTO,
			US_XTIPPAG,
			US_XBANCO,
			US_XAGENCI,
			US_XDIGAGE,
			US_XCONTA,
			US_XDIGCTA,
			US_XOPERAC,
			US_XTPCTA,
			US_XCEPCOB,
			US_XENDCOB,
			US_XTIPLOC,
			US_XNUMENC,
			US_XCOMENC,
			US_XBAIRRC,
			US_XCODMUC,
			US_XMUNCOB,
			US_XPISPAS,
			US_XESTCOB,
			US_XDDDC,
			US_XCONTC,
			US_XTELC,
			US_XEMAILC,
			US_XCEPE,
			US_XTIPLOE,
			US_XENDENT,
			US_XNRENDE,
			US_XCOMENE,
			US_XBAIRRE,
			US_XMUNE,
			US_XESTE,
			US_XDDDE,
			US_XTELE,
			US_XTIPLOG,
			BQC_SUBCON,
			PSP_CODINT,
			PSP_CODEMP,
			PSP_CONEMP,
			PSP_SUBCON,
			''04'' as EMPRESA,
			BA0_NOMINT,
			US_EMAIL,
			PSP_TIPPAG,
			PSP_BANCO,
			PSP_AGENCI,
			PSP_DIGAGE,
			PSP_CONTA,
			PSP_DIGCTA,
			PSP_OPERAC,
			PSP_TPCTA,
			PSP_VENCTO,
			PSP_CORFAT,
			PSP_XVENOU,
			BT5_NUMCON,
			PSP_COPART,
			PSP_ADESAO,
			NULL AS DataNascimento,
			NULL AS IDSexo,
			NULL AS IDEstadoCivil,
			NULL as Identidade,
			NULL as OrgaoExpedidor,
			NULL as DataExpedicaoRG,
			PSC_DESCRI AS DescricaoSegmento,
			PSD_DESCRI AS DescricaoCanal,
			BQC_DATBLO AS DataFimVigencia,
			PSP_STATUS as StatusProposta,ROW_NUMBER() OVER (PARTITION BY PSP_NUMPRP,BQC_NUMCON,BQC_SUBCON ORDER BY PSP_NUMPRP,BQC_NUMCON,BQC_SUBCON) AS LINHA,
			PSP_CODVEN			 
	FROM PSP040 
	INNER JOIN PHN040 ON 
	PSP_CODINT = PHN_CODINT AND 
	PSP_CODEMP = PHN_CODEMP AND 
	PSP_NUMPRP = PHN_NUMPRP AND 
	PHN040.D_E_L_E_T_='''' AND 
	PSP040.D_E_L_E_T_ = ''''
	INNER JOIN SUS040 ON PHN_FILIAL = US_FILIAL AND PHN_PROSPE = US_COD AND PHN_LOJPRO = US_LOJA AND SUS040.D_E_L_E_T_=''''
	RIGHT JOIN BQC040 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
				--	AND PSP_NUMPRP = BQC_XNUMPR 
					AND BQC040.D_E_L_E_T_='''' 
					--AND BQC_SUBCON = PHN_SUBCON
					--AND BQC_VERSUB = PHN_VERCON
					AND BQC_NUMCON = PHN_CONEMP
					AND BQC_VERCON = PHN_VERCON
	INNER JOIN SA1040 ON BQC_CODCLI = A1_COD AND BQC_LOJA = A1_LOJA AND SA1040.D_E_L_E_T_=''''
	INNER JOIN BA0040 ON BA0_CODIDE+BA0_CODINT = PSP_CODINT AND BA0040.D_E_L_E_T_=''''
	INNER JOIN BT5040 ON PSP_CODINT = BT5_CODINT AND PSP_CODEMP = BT5_CODIGO
					AND PSP_CONEMP = BT5_NUMCON  AND PSP_VERCON = BT5_VERSAO 
					AND BT5040.D_E_L_E_T_=''''
	LEFT JOIN PSC040 ON PSC_CODIGO = PSP_CODCAN AND PSC040.D_E_L_E_T_=''''
	LEFT JOIN PSD040 ON PSD_CODIGO = PSP_CODUNI AND PSC040.D_E_L_E_T_=''''
	UNION ALL
	SELECT DISTINCT	 PSP_NUMPRP,
			Coalesce(RIGHT(BQC_SUBCON,3),PHN_CODIGO) as Sub,
			''08'' AS PSP_CODUNI,
			PSP_DATA,
			PSP_DTVIGE,
			PSP_VALOR,
			''99'' AS PSP_CODCAN,
			PSP_CODFAS,
			A1_NOME AS US_NOME,
			A1_CEP AS US_CEP,
			A1_CGC AS US_CGC,
			A1_BAIRRO AS US_BAIRRO,
			LEFT(A1_MUN,15) AS US_MUN,
			A1_NR_END AS US_XNR_END,
			A1_COMPLEM AS US_XCOMEND,
			A1_END AS US_END,
			A1_EST AS US_EST,
			A1_DDD AS US_DDD,
			A1_TEL AS US_TEL,
			A1_XDDDCOM AS US_XDDDCOM,
			A1_XTELCOM AS US_XTELCOM,
			A1_XRAMCOM AS US_XRAMCOM,
			A1_XVENCTO AS US_XVENCTO,
			A1_XTIPPAG AS US_XTIPPAG,
			A1_XBANCO AS US_XBANCO,
			LEFT(A1_XAGENCI,5) AS US_XAGENCI,
			A1_XDIGAGE AS US_XDIGAGE,
			A1_XCONTA AS US_XCONTA,
			A1_XDIGCTA AS US_XDIGCTA,
			A1_XOPERAC AS US_XOPERAC,
			A1_XTPCTA AS US_XTPCTA,
			A1_CEPC AS US_XCEPCOB,
			A1_ENDREC AS US_XENDCOB,
			A1_XTIPLOC AS US_XTIPLOC,
			A1_XNRENDC AS US_XNUMENC,
			A1_XCOMENC AS US_XCOMENC,
			A1_BAIRROC AS US_XBAIRRC,
			A1_XCODMUC AS US_XCODMUC,
			LEFT(A1_MUNC,15) AS US_XMUNCOB,
			NULL AS US_XPISPAS,
			A1_ESTC AS US_XESTCOB,
			A1_XDDDC AS US_XDDDC,
			A1_XCONTC AS US_XCONTC,
			A1_XTELC AS US_XTELC,
			A1_XEMAILC AS US_XEMAILC,
			A1_CEPE AS US_XCEPE,
			A1_XTIPLOE AS US_XTIPLOE,
			A1_ENDENT AS US_XENDENT,
			A1_XNRENDE AS US_XNRENDE,
			A1_XCOMENE AS US_XCOMENE,
			A1_BAIRROE AS US_XBAIRRE,
			LEFT(A1_MUNE,15) AS US_XMUNE,
			A1_ESTE AS US_XESTE,
			A1_XDDDE AS US_XDDDE,
			A1_XTELE AS US_XTELE,
			A1_XTIPLOG AS US_XTIPLOG,
			BQC_SUBCON,
			PSP_CODINT,
			PSP_CODEMP,
			PSP_CONEMP,
			PSP_SUBCON,
			''03'' as EMPRESA,
			BA0_NOMINT,
			A1_EMAIL AS US_EMAIL,
			PSP_TIPPAG,
			Case WHEN LEN(RTRIM(PSP_BANCO)) <= 1 then -1
			ELSE PSP_BANCO END AS PSP_BANCO,
			PSP_AGENCI,
			PSP_DIGAGE,
			PSP_CONTA,
			PSP_DIGCTA,
			PSP_OPERAC,
			PSP_TPCTA,
			PSP_VENCTO,
			PSP_CORFAT,
			PSP_XVENOU,
			BT5_NUMCON,
		NULL AS	PSP_COPART,
			PSP_ADESAO,
			BA1_DATNAS as DataNascimento,
			BA1_SEXO AS IDSexo,
			Case when BA1_ESTCIV = ''S'' THEN 1 
				when BA1_ESTCIV = ''C'' THEN 2 
				when BA1_ESTCIV = ''V'' THEN 3 
				when BA1_ESTCIV = ''D'' THEN 5
				ELSE 10 
			END as IDEstadoCivil,
			CASE WHEN LEN(RTRIM(BA1_DRGUSR)) = 0 THEN NULL ELSE BA1_DRGUSR END AS Identidade,
			CASE WHEN LEN(RTRIM(BA1_ORGEM)) = 0 THEN NULL ELSE LEFT(BA1_ORGEM,5) END AS OrgaoExpedidor,
			CASE WHEN LEN(RTRIM(BA1_XDTEMI)) = 0 THEN NULL ELSE CAST(BA1_XDTEMI  AS DATE) END  AS DataExpedicaoRG,
			''ADESAO'' AS DescricaoSegmento,
			''FORCA DE VENDAS PROPRIA-ADESAO'' AS DescricaoCanal,
			BQC_DATBLO AS DataFimVigencia,
			PSP_STATUS as StatusProposta,1 AS LINHA,
			PSP_CODVEN
	FROM PSP030 
	INNER JOIN PHN030 ON 
	PSP_CODINT = PHN_CODINT AND 
	PSP_CODEMP = PHN_CODEMP AND 
	PSP_NUMPRP = PHN_NUMPRP AND 
	PHN030.D_E_L_E_T_='''' AND 
	PSP030.D_E_L_E_T_ = ''''
	LEFT JOIN SA1030 ON PSP_CODCLI = A1_COD AND PSP_LOJA = A1_LOJA  AND SA1030.D_E_L_E_T_=''''
	LEFT JOIN BQC030 ON BQC_FILIAL = PSP_FILIAL AND BQC_CODIGO = PSP_CODINT + PSP_CODEMP 
					AND PSP_CONEMP = BQC_NUMCON AND PSP_VERCON = BQC_VERCON 
					AND PSP_SUBCON = BQC_SUBCON AND PSP_VERSUB = BQC_VERSUB
					AND BQC030.D_E_L_E_T_=''''
	LEFT JOIN BA0030 ON BA0_CODIDE+BA0_CODINT = PSP_CODINT AND BA0030.D_E_L_E_T_='''' 
	LEFT JOIN BT5030 ON PSP_CODINT = BT5_CODINT AND PSP_CODEMP = BT5_CODIGO
					AND PSP_CONEMP = BT5_NUMCON  AND PSP_VERCON = BT5_VERSAO AND BT5030.D_E_L_E_T_='''' 	
	LEFT JOIN BA3030 ON BA3_FILIAL = PSP_FILIAL AND BA3_CODINT = PSP_CODINT 
					AND BA3_CODEMP = PSP_CODEMP AND BA3_CONEMP = PSP_CONEMP
					AND BA3_VERCON = PSP_VERCON AND BA3_SUBCON = PSP_SUBCON
					AND BA3_VERSUB = PSP_VERSUB AND PSP_CODCLI = BA3_CODCLI
					AND BA3_LOJA = PSP_LOJA AND PSP_NUMPRP = BA3_XNUMPR AND BA3030.D_E_L_E_T_ = ''''
	LEFT JOIN BA1030 ON BA3_FILIAL = BA1_FILIAL AND BA3_CODINT = BA1_CODINT 
					AND BA3_CODEMP = BA1_CODEMP AND BA1_CONEMP = BA1_CONEMP
					AND BA3_VERCON = BA1_VERCON AND BA3_SUBCON = BA1_SUBCON
					AND BA3_VERSUB = BA1_VERSUB AND BA3_MATRIC = BA1_MATRIC
					AND BA1030.D_E_L_E_T_ = '''' AND BA1_TIPUSU = ''T'' AND BA1_TIPREG = ''00'' 
					AND (BA1_CODINT <> ''0004'' AND BA1_CODEMP <> ''0001'')
	
	'
														
											)   oq WHERE LINHA = 1  -- AND US_NOME like 'CTIS COM%'


