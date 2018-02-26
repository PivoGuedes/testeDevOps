
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
	Autor: André Anselmo
	Data Criação: 19/01/2015

	Descrição: 
	
	Última alteração :
	Data de alteração : 
	Descrição : 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Mailing.proc_GeraMailing_MS
	Descrição: Procedimento que gerar o mailing que será enviado a MS.
	
*******************************************************************************/
CREATE PROCEDURE [Mailing].[proc_GeraMailing_MS_Renovacao](@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/ )
AS

BEGIN 



	--DECLARE @DataMailing DATE ='2015-06-01'
    DECLARE @SomaDia TINYINT = CASE datename(dw,@DataMailing) WHEN 'Monday' THEN 2 ELSE 0 END 

	--PRINT DATEADD(DD, -1 -@SomaDia , @DataMailing)  
	--PRINT @DataMailing 
	--PRINT @DataMailing





SELECT * 
INTO #Temp_S1
FROM 

	(
		SELECT DISTINCT 
		--M.TER_VIG_DATE, M.APOLICE, M.CPFCNPJ_FORMAT, M.SEGURADO, A.Data_Acao,A.Nom_Devedor ,A.Cod_Acao,A.Dcr_Sub_Acao , A.End_com_Cargo, 'Recusado no dia anterior - Regra 1' AS RegraAplicada

		NOM_DEVEDOR, CPFCNPJ_FORMAT, DDD_RES_1, TEL_RES_1, DDD_RES_2, TEL_RES_2, DDD_COM_1, TEL_COM_1, DDD_COM_2, 
		TEL_COM_2, End_com_Cargo, Data_Acao, Veiculo, Placa, Objetivo, Agencia, CEP, Email, ANO_MOD, CHASSI, TP_FRANQUIA, 'Recusado no dia anterior - Regra 1' AS RegraAplicada

		FROM dbo.Temp_MailingBackSeg AS M
		LEFT OUTER JOIN Mailing.atendimento_backseg AS A 
		ON A.Num_cpf=M.CPFCNPJ_FORMAT
		AND A.End_Com_Cargo NOT IN ('ECONOMIARIO','CONJUGE ECONOMIARIO','PARENTE ECONOMIARIO','CONSORCIO/FINANCIAME')
		where 
			(--REGRA 1
				A.Data_Acao='2015-06-01'
				AND Dcr_Sub_Acao IN
				(
				'01 - FONE INCORRETO/NAO EXISTE'
				,'01 - FONE NAO EXISTE'
				,'01 - INSATISFEITO COM O PRODUTO'
				,'01 - POR SOLICITACAO DO CLIENTE'
				,'02 - FONE NAO PERTENCE AO CLIENTE'
				,'02 - INSATISFEITO COM O ATENDIMENTO'
				,'03 - INSATISFEITO COM PROCESSO DE SINISTRO'
				,'04 - INSATISFEITO COM PRECO'
				,'05 - NAO POSSUI MAIS O VEICULO'
				,'06 - RISCO RESTRITO'
				)
			)

		UNION ALL 

		SELECT DISTINCT 
		--M.TER_VIG_DATE, M.APOLICE, M.CPFCNPJ_FORMAT, M.SEGURADO, A.Data_Acao,A.Nom_Devedor ,A.Cod_Acao,A.Dcr_Sub_Acao , A.End_com_Cargo, 'Não finalizados em 11 dias - Regra 2' AS RegraAplicada
		NOM_DEVEDOR, CPFCNPJ_FORMAT, DDD_RES_1, TEL_RES_1, DDD_RES_2, TEL_RES_2, DDD_COM_1, TEL_COM_1, DDD_COM_2, 
		TEL_COM_2, End_com_Cargo, Data_Acao, Veiculo, Placa, Objetivo, Agencia, CEP, Email, ANO_MOD, CHASSI, TP_FRANQUIA, 'Não finalizados em 11 dias - Regra 2' AS RegraAplicada

		FROM dbo.Temp_MailingBackSeg AS M
		LEFT OUTER JOIN Mailing.atendimento_backseg AS A 
		ON A.Num_cpf=M.CPFCNPJ_FORMAT
		AND A.End_Com_Cargo NOT IN ('ECONOMIARIO','CONJUGE ECONOMIARIO','PARENTE ECONOMIARIO','CONSORCIO/FINANCIAME')
		where 
			(-- REGRA 2
				A.Data_Acao='2015-05-21'
				AND Dcr_Sub_Acao IN
				(
				'01 - APENAS COTACAO'
				,'01 - CLI ENCAMINHADO SEGURADORA'
				,'01 - CLIENTE ANALISANDO'
				,'01 - CONTATO COM TERCEIRO'
				,'01 - LIGACAO CAIU'
				,'01 - LIGACAO DESCONECTADA - NOBLE'
				,'01 - LIGACAO MUDA NO DISCADOR NOBLE'
				,'01 - OCUPADO'
				,'01 - QUEDA NO LINK'
				,'01 - RECADO NO LOCAL DE TRABALHO'
				,'01 - TEL NAO ATENDE - DISCADOR NOBLE'
				,'01 - TEL OCUPADO - DISCADOR NOBLE'
				,'02 - COTANDO EM OUTRAS SEGURADORAS'
				,'02 - EQUIPARACAO - CORRENTISTA'
				,'02 - ESPONTANEO'
				,'02 - INF ADMINISTRATIVAS'
				,'02 - INFORMACOES COMPLEMENTARES'
				,'02 - PREFERE TRATAR NO PV'
				,'02 - RECADO NA RESIDENCIA'
				,'02 - SIMULADOR COM FALHA'
				,'02 - SO CHAMA'
				,'02 - TERCEIRO DESLIGOU'
				,'03 - AGENDAR PARA OUTRO HORARIO'
				,'03 - CONTATO SEM SUCESSO'
				,'03 - ENCAMINHADO A CENTRAL'
				,'03 - RECADO NA SEC. ELETRONICA/CX POSTAL'
				,'03 - TRANSF DE LIGACAO DISCADOR'
				,'04 - TRANSF P/ DISTRIBUICAO MANUAL - ANALISE'
				,'18 - ATUALIZACAO CADASTRAL'
				,'27 - INCLUSAO DE TELEFONE'
				)
			)

		UNION ALL 

		SELECT DISTINCT 
		--M.TER_VIG_DATE, M.APOLICE, M.CPFCNPJ_FORMAT, M.SEGURADO, A.Data_Acao,A.Nom_Devedor ,A.Cod_Acao,A.Dcr_Sub_Acao , A.End_com_Cargo, 'Não abordado - Regra 4' AS RegraAplicada
		NOM_DEVEDOR, CPFCNPJ_FORMAT, DDD_RES_1, TEL_RES_1, DDD_RES_2, TEL_RES_2, DDD_COM_1, TEL_COM_1, DDD_COM_2, 
		TEL_COM_2, End_com_Cargo, Data_Acao, Veiculo, Placa, Objetivo, Agencia, CEP, Email, ANO_MOD, CHASSI, TP_FRANQUIA, 'Não abordado - Regra 4' AS RegraAplicada

		FROM dbo.Temp_MailingBackSeg AS M
		LEFT OUTER JOIN Mailing.atendimento_backseg AS A 
		ON A.Num_cpf=M.CPFCNPJ_FORMAT
		AND A.End_Com_Cargo NOT IN ('ECONOMIARIO','CONJUGE ECONOMIARIO','PARENTE ECONOMIARIO','CONSORCIO/FINANCIAME')
		where 
			(-- REGRA 3
				Data_Acao IS NULL
				AND CAST(M.TER_VIG_DATE AS DATE)='2015-05-21'
			)	
	) AS T
--ORDER BY Nom_Devedor , DATA_aCAO


SELECT * 
INTO #Temp_2
FROM #Temp_S1 AS T1
WHERE NOT EXISTS 
(SELECT * FROM #Temp_S1 AS T2 WHERE T1.CPFCNPJ_FORMAT=T2.CPFCNPJ_FORMAT AND T1.RegraAplicada='Recusado no dia anterior - Regra 1' AND T2.RegraAplicada<>'Recusado no dia anterior - Regra 1')
--AND T1.CPFCNPJ_FORMAT='00060970570082'


--DROP TABLE #Temp_2

--SELECT * FROM #Temp_2

SELECT 
	'' AS NOME_CAMPANHA,
	'' AS CODIGO_CAMPANHA,
	'' AS CODIGO_MAILING,
	NOM_DEVEDOR AS NOME_CLIENTE,
	CleansingKit.[dbo].[fn_FormataCPF](RIGHT(CPFCNPJ_FORMAT,11)) AS CPF,	   
	DDD_RES_1 AS DDDTelefone1,
	TEL_RES_1 AS Telefone1,
	DDD_RES_2 AS DDDTelefone2,
	TEL_RES_2 AS Telefone2,
	DDD_COM_1 AS DDDTelefone3,
	TEL_COM_1 AS Telefone3,
	DDD_COM_2 AS DDDTelefone4,
	TEL_COM_2 AS Telefone4,
	'' AS COD_TIPO_CLIENTE,
	End_com_Cargo AS TIPO_CLIENTE,
	'' AS ORIGEM_CLIENTE,
	Data_Acao AS DATA_CONTATO_CS,
	Data_Acao AS DATA_COTACAO_CS,
	Veiculo AS MODELO_VEICULO,
	Placa AS PLACA_VEICULO,
	'' AS VALOR_PREMIO_BRUTO,
	'' AS MOTIVO_RECUSA,           
	Objetivo AS TIPO_SEGURO,
	'' AS  DATA_INICIO_VIGENCIA,
	Agencia AS AGENCIA_COTACAO_CS,
	'' AS NUMERO_COTACAO_CS,
	'' AS ValorFIPE,
	'F' AS TipoPessoa,
	'' AS Sexo,
	'' AS BONUS_ANTERIOR, 
	CEP AS CEP,
	'' AS ESTADO_CIVIL,
	Email AS Email,
	'' AS TIPO_COND_SEGURADO,
	'' AS DATA_NASC,
	ANO_MOD AS ANO_MODELO,
	'' AS COD_FIPE,
	'' AS USO_VEICULO,
	'' AS BLINDADO,
	CHASSI AS CHASSI,
	'' AS FORMA_CONTRATACAO,
	TP_FRANQUIA AS TIPO_FRANQUIA,
	'' AS DANOS_MATERIAIS,
	'' AS DANOS_MORAIS,
	'' AS DANOS_CORPORAIS,
	'' AS ASSIS_24_HRS,
	'' AS CARRO_RESERVA,
	'' AS GARANTIA_CARRO_RESERVA,
	'' AS APP_PASSAGEIRO,
	'' AS DESP_MEDICO_HOSP,
	'' AS LANT_FAROIS_RETROVIS,
	'' AS VIDROS,
	'' AS DESP_EXTRAORDINARIAS, 
	'' AS ESTENDER_COB_PARA_MENORES,
	'' AS DataMailing
INTO #Temp_FINAL
FROM #Temp_2



	--DECLARE @DataMailing DATE ='2015-06-01'
 --   DECLARE @SomaDia TINYINT = CASE datename(dw,@DataMailing) WHEN 'Monday' THEN 2 ELSE 0 END 

	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	-- Grava os CPF da quarentena na tabela temporaria 

	;  WITH Temp AS (
		SELECT DISTINCT CPF_CNPJ_CLIENTE COLLATE Latin1_General_CI_AS AS CPF FROM OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] WHERE Data_inclusao_calculo> DATEADD(DD,-60,@DataMailing) --and Data_inclusao_calculo < @DataMailing
		UNION
		SELECT DISTINCT CPF FROM Mailing.MailingAutoMS WHERE DataRefMailing>=DATEADD(DD, -60 -@SomaDia, @DataMailing) --and DataRefMailing < @DataMailing
		UNION
		SELECT DISTINCT  SUBSTRING(CPF,1,3) + '.' + SUBSTRING(CPF,4,3) + '.' + SUBSTRING(CPF,7,3) + '-' + SUBSTRING(CPF,10,2) FROM Mailing.MailingParIndica
	) SELECT * INTO #TempCOL FROM Temp  

	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	-- 
	--INSERT INTO  Mailing.MailingAutoMS --  --
	--(
	--		[NOME_CAMPANHA],
	--		[CODIGO_CAMPANHA],
	--		[CODIGO_MAILING],
	--		[NOME_CLIENTE],
	--		[CPF],	   
	--		DDDTelefone1,
	--		Telefone1,
	--		DDDTelefone2,
	--		Telefone2,
	--		DDDTelefone3,
	--		Telefone3,
	--		DDDTelefone4,
	--		Telefone4,
	--		[COD_TIPO_CLIENTE],
	--		[TIPO_CLIENTE],
	--		[ORIGEM_CLIENTE],
	--		[DATA_CONTATO_CS],
	--		[DATA_COTACAO_CS],
	--		[MODELO_VEICULO],
	--		[PLACA_VEICULO],
	--		VALOR_PREMIO_BRUTO,
	--		[MOTIVO_RECUSA],           
	--		[TIPO_SEGURO],
	--		[DATA_INICIO_VIGENCIA],
	--		[AGENCIA_COTACAO_CS],
	--		[NUMERO_COTACAO_CS],
	--		ValorFIPE,
	--		TipoPessoa,
	--		[Sexo],
	--		[BONUS], 
	--		CEP,
	--		[ESTADO_CIVIL],
	--		[Email],
	--		[TIPO_COND_SEGURADO],
	--		[DATA_NASC],
	--		[ANO_MODELO],
	--		[COD_FIPE],
	--		[USO_VEICULO],
	--		[BLINDADO],
	--		[CHASSI],
	--		[FORMA_CONTRATACAO],
	--		[TIPO_FRANQUIA],
	--		[DANOS_MATERIAIS],
	--		[DANOS_MORAIS],
	--		[DANOS_CORPORAIS],
	--		[ASSIS_24_HRS],
	--		[CARRO_RESERVA],
	--		[GARANTIA_CARRO_RESERVA],
	--		[APP_PASSAGEIRO],
	--		[DESP_MEDICO_HOSP],
	--		[LANT_FAROIS_RETROVIS],
	--		[VIDROS],
	--		[DESP_EXTRAORDINARIAS],
	--		[ESTENDER_COB_PARA_MENORES],
 --           [DataRefMailing]
	--)
	SELECT
			[NOME_CAMPANHA],
			[CODIGO_CAMPANHA],
			[CODIGO_MAILING],
			[NOME_CLIENTE],
			[CPF],	   
			DDDTelefone1,
			Telefone1,
			DDDTelefone2,
			Telefone2,
			DDDTelefone3,
			Telefone3,
			DDDTelefone4,
			Telefone4,
			[COD_TIPO_CLIENTE],
			[TIPO_CLIENTE],
			[ORIGEM_CLIENTE],
			[DATA_CONTATO_CS],
			[DATA_COTACAO_CS],
			[MODELO_VEICULO],
			[PLACA_VEICULO],
			VALOR_PREMIO_BRUTO,
			[MOTIVO_RECUSA],           
			[TIPO_SEGURO],
			NULL AS DATA_INICIO_VIGENCIA,
			[AGENCIA_COTACAO_CS],
			[NUMERO_COTACAO_CS],
			ValorFIPE,
			TipoPessoa,
			[Sexo],
			[BONUS_ANTERIOR], 
			CEP,
			[ESTADO_CIVIL],
			[Email],
			[TIPO_COND_SEGURADO],
			[DATA_NASC],
			[ANO_MODELO],
			[COD_FIPE],
			[USO_VEICULO],
			[BLINDADO],
			[CHASSI],
			[FORMA_CONTRATACAO],
			[TIPO_FRANQUIA],
			[DANOS_MATERIAIS],
			[DANOS_MORAIS],
			[DANOS_CORPORAIS],
			[ASSIS_24_HRS],
			[CARRO_RESERVA],
			[GARANTIA_CARRO_RESERVA],
			[APP_PASSAGEIRO],
			[DESP_MEDICO_HOSP],
			[LANT_FAROIS_RETROVIS],
			[VIDROS],
			[DESP_EXTRAORDINARIAS], 
			[ESTENDER_COB_PARA_MENORES],
			DataMailing
	INTO dbo.Temp_Teste_Mailing_BackSeg
	FROM #Temp_FINAL A
	OUTER APPLY (SELECT TOP 1 TipoVeiculo
				FROM Dados.TabelaFIPE
				WHERE CodigoCompleto=A.COD_FIPE
			) AS TV

	WHERE  Telefone1 IS NOT NULL
	AND ISNULL(TV.TipoVeiculo,'')<>'Moto'
	AND NOT EXISTS (
	                SELECT *
	                FROM Dados.Funcionario F
					WHERE F.CPF = A.[CPF]
					AND F.IDEmpresa = 1 
				   )

	AND NOT EXISTS (
		SELECT DISTINCT CPF FROM #TempCOL WHERE CPF=A.CPF COLLATE Latin1_General_CI_AS
	)
	AND  (
	          Email not like '%@caixa.gov.br'
		 )
	AND   (
	         ( 
			  [TIPO_CLIENTE] NOT like '%PARENTE DO ECONOMIÁRIO (PAIS E FILHOS)%'
			  and
              [TIPO_CLIENTE] NOT like '%CÔNJUGE DO ECONOMIÁRIO%'
			  and
              [TIPO_CLIENTE] NOT like '%AUTO EXCLUSIVO%'
			  )
			  OR
			  [TIPO_CLIENTE] IS NULL
		  )

END


