CREATE PROCEDURE [Mailing].[proc_GeraMailing_MS_Recusados_Complementar]
AS

BEGIN 



	DECLARE @DataMailing DATE =CAST(GETDATE() AS DATE)
    DECLARE @SomaDia TINYINT = CASE datename(dw,@DataMailing) WHEN 'Monday' THEN 2 ELSE 0 END 

	--PRINT DATEADD(DD, -1 -@SomaDia , @DataMailing)  
	--PRINT @DataMailing 
	--PRINT @DataMailing

		;WITH CTT AS (

		SELECT 
			Arquivo
			,	SA.DataCalculo AS [DATA_CONTATO_CS]
			,	SA.DataCalculo as [DATA_COTACAO_CS]
			,	'AQAUTORESTMS20150508' AS [NOME_CAMPANHA]
			,	'AQAUTORESTMS' AS [CODIGO_CAMPANHA]
			,	'AQAUTORESTMS_' + REPLACE(Convert(date,@DataMailing,103),'-','') [CODIGO_MAILING]
			,	PC.NomeCliente AS [NOME_CLIENTE]
			,	SA.CPFCNPJ AS [CPF]
			,	PC.DDDTelefoneContato AS DDDTelefone
			,	PC.TelefoneContato AS Telefone
			,	TC.Codigo AS [COD_TIPO_CLIENTE]
			,	TC.Descricao AS [TIPO_CLIENTE]
			,	V.Nome AS [MODELO_VEICULO]
			,	Placa AS [PLACA_VEICULO]
			,	ValorPremio AS VALOR_PREMIO_BRUTO
			,	'Não abordado' AS [MOTIVO_RECUSA]
			,	CASE TS.Descricao WHEN 'Novo' THEN 'Seguro Novo' ELSE TS.Descricao END [TIPO_SEGURO]
			,	DataInicioVigencia AS [DATA_INICIO_VIGENCIA]
			,	U.Codigo AS [AGENCIA_COTACAO_CS]
			,	NumeroCalculo AS [NUMERO_COTACAO_CS]
			,	ValorFipe AS ValorFIPE
			,	TipoPessoa AS TipoPessoa
			,	SUBSTRING(S.Descricao, 1,1) AS [Sexo]
			,	IDClasseBonusAnterior AS BONUS
			,	CEP
			,	EC.Descricao AS [ESTADO_CIVIL]
			,	PC.Email AS [Email]
			,	TRS.Descricao AS [TIPO_COND_SEGURADO]
			,	PC.DataNascimento AS [DATA_NASC]
			,	Ano AS [ANO_MODELO]
			,	CodModelo AS [COD_FIPE]
			,	TUV.Descricao AS [USO_VEICULO]
			,	(CASE Blindado WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS [BLINDADO]
			,	Chassis AS [CHASSI]
			,	FC.Descricao AS [FORMA_CONTRATACAO]
			,	TF.Descricao AS [TIPO_FRANQUIA]
			,	CobDanosMateriais AS [DANOS_MATERIAIS]
			,	CobDanosMorais AS [DANOS_MORAIS]
			,	CobDanosCorporais AS [DANOS_CORPORAIS]
			,	IDAss24h AS [ASSIS_24_HRS]
			,	IDTipoCarroReserva AS [CARRO_RESERVA]
			,	'N/A' AS [GARANTIA_CARRO_RESERVA]
			,	CobAPP AS [APP_PASSAGEIRO]
			,	DespesasMedHosp AS [DESP_MEDICO_HOSP]
			,	(CASE CobLantFarRetro WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS [LANT_FAROIS_RETROVIS]
			,	(CASE CobVidros WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS [VIDROS]
			,	(CASE CobDespesasExtras WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS [DESP_EXTRAORDINARIAS]
			,	(CASE EstendeCoberturaMenores WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS [ESTENDER_COB_PARA_MENORES]
		FROM Dados.SimuladorAuto  AS SA
		INNER JOIN Dados.TipoCliente AS TC
		ON SA.IDTipoCliente=TC.ID
		INNER JOIN Dados.Veiculo AS V
		ON SA.IDVeiculo=V.ID
		INNER JOIN Dados.TipoSeguro AS TS
		ON TS.ID=SA.IDTipoSeguro
		INNER JOIN Dados.Unidade AS U
		ON U.ID=SA.IDAgenciaVenda
		LEFT OUTER  JOIN Dados.Sexo AS S
		ON S.ID=SA.IDSexo
		LEFT OUTER JOIN Dados.EstadoCivil AS EC
		ON EC.ID=SA.IDEstadoCivil
		LEFT OUTER JOIN Dados.TipoRelacaoSegurado AS TRS
		ON TRS.ID=SA.IDTipoRelacaoSegurado
		INNER JOIN Dados.TipoUsoVeiculo AS TUV
		ON TUV.ID=SA.IDTipoUsoVeiculo
		INNER JOIN Dados.FormaContratacao AS FC
		ON FC.ID=SA.IDFormaContratacao
		INNER JOIN Dados.ClasseFranquia AS TF
		ON TF.ID=SA.IDTipoFranquia
		OUTER APPLY 
			(
					SELECT  SA.NomeCliente, SA.CPFCNPJ, SA.DataNascimento, SA.Email, SA.DDDTelefoneContato, SA.TelefoneContato

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento,PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone1)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone1)), LEN(LTRIM(RTRIM(PC.Telefone1))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDia,@DataMailing)

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone2)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone2)), LEN(LTRIM(RTRIM(PC.Telefone2))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDia,@DataMailing)
						 						
					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone3)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone3)), LEN(LTRIM(RTRIM(PC.Telefone3))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDia,@DataMailing)

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone4)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone4)), LEN(LTRIM(RTRIM(PC.Telefone4))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDia,@DataMailing)
				) PC	
				WHERE	
					
					SA.ValorPremio=0
				AND SA.TipoPessoa='F'
				AND SA.DataCalculo=DATEADD(DD, -1 -@SomaDia , @DataMailing) 
				AND TS.Descricao IN ('Seguro Novo','Novo','Renovação Congênere') 
	)
	SELECT * INTO #Tbl FROM CTT


	;WITH CTE1
	AS
	(
		SELECT * FROM #Tbl
	),
	CTE2
	AS
	(
	SELECT
			CTE1.Arquivo,
		   CTE1.[DATA_CONTATO_CS],           
		   CTE1.[DATA_COTACAO_CS],
		   CTE1.[NOME_CAMPANHA],
		   CTE1.[CODIGO_CAMPANHA],
		   CTE1.[CODIGO_MAILING],
		   CTE1.[NOME_CLIENTE],
		   CTE1.[CPF],
		   [Dados].[fn_TrataNumeroTelefone](CTE1.DDDTelefone, CTE1.Telefone) Telefone,
		   CTE1.[COD_TIPO_CLIENTE],
		   CTE1.[TIPO_CLIENTE],
		   CTE1.[MODELO_VEICULO],
		   CTE1.[PLACA_VEICULO],
		   CTE1.VALOR_PREMIO_BRUTO ,
		   CTE1.[MOTIVO_RECUSA],
		   CTE1.[TIPO_SEGURO],
		   CTE1.[DATA_INICIO_VIGENCIA],
		   CTE1.[AGENCIA_COTACAO_CS],
		   CTE1.[NUMERO_COTACAO_CS],
		   CTE1.ValorFIPE,
		   CTE1.TipoPessoa,
		   CTE1.[Sexo],
		   CTE1.BONUS,
		   CTE1.CEP,
		   CTE1.[ESTADO_CIVIL],
		   CTE1.[Email],
		   CTE1.[TIPO_COND_SEGURADO],
		   CTE1.[DATA_NASC],
		   CTE1.[ANO_MODELO],
		   CTE1.[COD_FIPE],
		   CTE1.[USO_VEICULO],
		   CTE1.[BLINDADO],
		   CTE1.[CHASSI],
		   CTE1.[FORMA_CONTRATACAO],
		   CTE1.[TIPO_FRANQUIA],
		   CTE1.[DANOS_MATERIAIS],
		   CTE1.[DANOS_MORAIS],
		   CTE1.[DANOS_CORPORAIS],
		   CTE1.[ASSIS_24_HRS],
		   CTE1.[CARRO_RESERVA],
		   CTE1.[GARANTIA_CARRO_RESERVA],
		   CTE1.[APP_PASSAGEIRO],
		   CTE1.[DESP_MEDICO_HOSP],
		   CTE1.[LANT_FAROIS_RETROVIS],
		   CTE1.[VIDROS],
		   CTE1.[DESP_EXTRAORDINARIAS],
		   CTE1.[ESTENDER_COB_PARA_MENORES]	
		  --, ROW_NUMBER() OVER (PARTITION BY CTE1.CPF ORDER BY Case WHEN LEFT(Cast(Cast(CASE WHEN CTE1.Telefone = '' OR CTE1.Telefone IS NULL THEN 0 ELSE CTE1.Telefone END as bigint) as varchar(10)),1) IN (1,2,3,4,5,6) THEN 1 ELSE 2 END, CTE1.Telefone) [LINHATE]
		  , ROW_NUMBER() OVER (PARTITION BY CTE1.CPF ORDER BY CTE1.NUMERO_COTACAO_CS DESC) [LINHATE]
		  , Case WHEN LEFT(Cast(Cast(CASE WHEN CTE1.Telefone = '' OR CTE1.Telefone IS NULL THEN 0 ELSE REPLACE(CTE1.Telefone, '-', '') END as bigint) as varchar(10)),1) IN (1,2,3,4,5,6) THEN 1 ELSE 2 END [OrdemTelefone]
		  , ROW_NUMBER() OVER (PARTITION BY CTE1.CPF ORDER BY CTE1.Email DESC) [LINHAMAIL]
	FROM CTE1
	) 
	, FINAL
	AS
	(
	SELECT A.Arquivo,
		   A.[NOME_CAMPANHA],
		   A.[CODIGO_CAMPANHA],
		   A.[CODIGO_MAILING],
		   A.[NOME_CLIENTE],
		   A.[CPF],
		   LEFT(T1.Telefone,2) DDDTelefone1,
		   RIGHT(T1.Telefone, LEN(T1.Telefone) -2) Telefone1,
		   LEFT(T2.Telefone,2) DDDTelefone2,
		   RIGHT(T2.Telefone, LEN(T2.Telefone) -2) Telefone2,
		   LEFT(T3.Telefone,2) DDDTelefone3,
		   RIGHT(T3.Telefone, LEN(T3.Telefone) -2) Telefone3,
		   LEFT(T4.Telefone,2) DDDTelefone4,
		   RIGHT(T4.Telefone, LEN(T4.Telefone) -2) Telefone4,
		   A.[COD_TIPO_CLIENTE],
		   A.[TIPO_CLIENTE],
		   'NEGATIVA OFERTA CAIXA SEGUROS' [ORIGEM_CLIENTE],
		   A.[DATA_CONTATO_CS],
		   A.[DATA_COTACAO_CS],
		   A.[MODELO_VEICULO],
		   A.[PLACA_VEICULO],
		   A.VALOR_PREMIO_BRUTO,
		   A.[MOTIVO_RECUSA],
		   A.[TIPO_SEGURO],
		   A.[DATA_INICIO_VIGENCIA],
		   A.[AGENCIA_COTACAO_CS],
		   A.[NUMERO_COTACAO_CS],
		   A.ValorFIPE,
		   A.TipoPessoa,
		   A.[Sexo],
		   A.BONUS,
		   A.CEP,
		   A.[ESTADO_CIVIL],
		   COALESCE(A.[Email], E1.Email) [Email],
		   A.[TIPO_COND_SEGURADO],
		   A.[DATA_NASC],
		   A.[ANO_MODELO],
		   A.[COD_FIPE],
		   A.[USO_VEICULO],
		   A.[BLINDADO],
		   A.[CHASSI],
		   A.[FORMA_CONTRATACAO],
		   A.[TIPO_FRANQUIA],
		   A.[DANOS_MATERIAIS],
		   A.[DANOS_MORAIS],
		   A.[DANOS_CORPORAIS],
		   A.[ASSIS_24_HRS],
		   A.[CARRO_RESERVA],
		   A.[GARANTIA_CARRO_RESERVA],
		   A.[APP_PASSAGEIRO],
		   A.[DESP_MEDICO_HOSP],
		   A.[LANT_FAROIS_RETROVIS],
		   A.[VIDROS],
		   A.[DESP_EXTRAORDINARIAS],
		   A.[ESTENDER_COB_PARA_MENORES]	
	FROM CTE2 A 

	OUTER APPLY (SELECT TOP 1  T1.Telefone Telefone, ISNULL(T1.LINHATE,0) LINHATE
					,CASE WHEN  T1.Telefone IS NULL THEN NULL 
						  ELSE 
							  CASE WHEN  T1.OrdemTelefone = 1 THEN 'FIXO' 
								   ELSE 'MÓVEL'
							  END 
							END TipoTelefone
				 FROM CTE2 T1
				 WHERE T1.CPF = A.CPF
				   --AND T1.LINHATE = 1
				   --AND T1.OrdemTelefone = 1 
				   AND T1.Telefone IS NOT NULL
				 ORDER BY T1.OrdemTelefone, T1.LINHATE, T1.Telefone) T1
	OUTER APPLY (SELECT TOP 1 T2.Telefone Telefone, T2.LINHATE
					,CASE WHEN  T2.Telefone IS NULL THEN NULL 
						  ELSE 
							  CASE WHEN  T2.OrdemTelefone = 1 THEN 'FIXO' 
								   ELSE 'MÓVEL'
							  END 
							END TipoTelefone

				 FROM CTE2 T2
				 WHERE T2.CPF = A.CPF
				   --AND T2.LINHATE = 2
				   AND ISNULL(T2.LINHATE,1) > ISNULL(T1.LINHATE,0)
				   AND ISNULL(T2.Telefone,0) <> ISNULL(T1.Telefone,0)
				   AND T2.Telefone IS NOT NULL			   
				ORDER BY T2.OrdemTelefone, T2.LINHATE, T2.Telefone
				 ) T2
	OUTER APPLY (SELECT TOP 1 T3.Telefone Telefone, T3.LINHATE
					,CASE WHEN  T3.Telefone IS NULL THEN NULL 
						  ELSE 
							  CASE WHEN  T3.OrdemTelefone = 1 THEN 'FIXO' 
								   ELSE 'MÓVEL'
							  END 
							END TipoTelefone
				 FROM CTE2 T3
				 WHERE T3.CPF = A.CPF
				   --AND T2.LINHATE = 2
				   AND ISNULL(T3.LINHATE,1) > ISNULL(T2.LINHATE,0)			   
				   AND ISNULL(T3.Telefone,0) <> ISNULL(T1.Telefone,0)
				   AND ISNULL(T3.Telefone,0) <> ISNULL(T2.Telefone,0)
				   AND T3.Telefone IS NOT NULL			   
				 ORDER BY T3.OrdemTelefone, T3.LINHATE, T3.Telefone
				 ) T3
	OUTER APPLY (SELECT TOP 1 T4.Telefone Telefone, T4.LINHATE
					,CASE WHEN  T4.Telefone IS NULL THEN NULL 
						  ELSE 
							  CASE WHEN  T4.OrdemTelefone = 1 THEN 'FIXO' 
								   ELSE 'MÓVEL'
							  END 
							END TipoTelefone
				 FROM CTE2 T4
				 WHERE T4.CPF = A.CPF
				   --AND T2.LINHATE = 2
				   AND ISNULL(T4.LINHATE,1) > ISNULL(T3.LINHATE,0)			   
				   AND ISNULL(T4.Telefone,0) <> ISNULL(T1.Telefone,0)
				   AND ISNULL(T4.Telefone,0) <> ISNULL(T2.Telefone,0)
				   AND ISNULL(T4.Telefone,0) <> ISNULL(T3.Telefone,0)
				   AND T4.Telefone IS NOT NULL			   
				 ORDER BY T4.OrdemTelefone, T4.LINHATE, T4.Telefone
				 ) T4
	OUTER APPLY (SELECT TOP 1 Email, LINHAMAIL
				 FROM CTE2 E1
				 WHERE E1.CPF = A.CPF
				   --AND T1.LINHATE = 1
				   AND E1.Email IS NOT NULL
				 ORDER BY E1.LINHAMAIL, E1.Email) E1
	OUTER APPLY (SELECT TOP 1 TipoVeiculo
				 FROM Dados.TabelaFIPE
				 WHERE CodigoCompleto=A.COD_FIPE
				) AS TV
	WHERE A.LINHATE = 1
	)
	SELECT
			A.[NOME_CAMPANHA],
			A.[CODIGO_CAMPANHA],
			A.[CODIGO_MAILING],
			A.[NOME_CLIENTE],
			A.[CPF],	   
			A.DDDTelefone1,
			A.Telefone1,
			A.DDDTelefone2,
			A.Telefone2,
			A.DDDTelefone3,
			A.Telefone3,
			A.DDDTelefone4,
			A.Telefone4,
			A.[COD_TIPO_CLIENTE],
			A.[TIPO_CLIENTE],
			A.[ORIGEM_CLIENTE],
			A.[DATA_CONTATO_CS],
			A.[DATA_COTACAO_CS],
			A.[MODELO_VEICULO],
			A.[PLACA_VEICULO],
			A.VALOR_PREMIO_BRUTO,
			A.[MOTIVO_RECUSA],           
			A.[TIPO_SEGURO],
			NULL AS DATA_INICIO_VIGENCIA,
			A.[AGENCIA_COTACAO_CS],
			A.[NUMERO_COTACAO_CS],
			A.ValorFIPE,
			A.TipoPessoa,
			A.[Sexo],
			A.[BONUS] [BONUS_ANTERIOR], --##VER
			A.CEP,
			A.[ESTADO_CIVIL],
			A.[Email],
			A.[TIPO_COND_SEGURADO],
			A.[DATA_NASC],
			A.[ANO_MODELO],
			A.[COD_FIPE],
			A.[USO_VEICULO],
			A.[BLINDADO],
			A.[CHASSI],
			A.[FORMA_CONTRATACAO],
			A.[TIPO_FRANQUIA],
			A.[DANOS_MATERIAIS],
			A.[DANOS_MORAIS],
			A.[DANOS_CORPORAIS],
			A.[ASSIS_24_HRS],
			A.[CARRO_RESERVA],
			A.[GARANTIA_CARRO_RESERVA],
			A.[APP_PASSAGEIRO],
			A.[DESP_MEDICO_HOSP],
			A.[LANT_FAROIS_RETROVIS],
			A.[VIDROS],
			A.[DESP_EXTRAORDINARIAS], 
			A.[ESTENDER_COB_PARA_MENORES],
			@DataMailing AS DataMailing
	INTO #Temp_FINAL
	FROM FINAL A
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	-- Grava os CPF da quarentena na tabela temporaria 

	;  WITH Temp AS (
		SELECT DISTINCT CPF_CNPJ_CLIENTE COLLATE Latin1_General_CI_AS AS CPF FROM OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] WHERE Codigo_campanha<>'CGAUTCOL20151215' AND Data_inclusao_calculo> DATEADD(DD,-60,@DataMailing) --and Data_inclusao_calculo < '2015-11-02'--@DataMailing
		UNION
		SELECT DISTINCT CPF FROM Mailing.MailingAutoMS WHERE DataRefMailing>=DATEADD(DD, -60 -@SomaDia, @DataMailing) --and DataRefMailing < '2015-11-02' --@DataMailing
		UNION
		SELECT DISTINCT  SUBSTRING(CPF,1,3) + '.' + SUBSTRING(CPF,4,3) + '.' + SUBSTRING(CPF,7,3) + '-' + SUBSTRING(CPF,10,2) FROM Mailing.MailingParIndica
	) SELECT * INTO #TempCOL FROM Temp  

	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	-- 
	INSERT INTO  Mailing.MailingAutoMS --  --
	(
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
			[DATA_INICIO_VIGENCIA],
			[AGENCIA_COTACAO_CS],
			[NUMERO_COTACAO_CS],
			ValorFIPE,
			TipoPessoa,
			[Sexo],
			[BONUS], 
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
            [DataRefMailing]
	)
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










DECLARE @Data as DATE = getdate()
 
INSERT INTO OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS]
           ([NOME_CAMPANHA]                  
           ,[CODIGO_CAMPANHA]				 
           ,[CODIGO_MAILING]				 
           ,[NOME_CLIENTE]					 
           ,[CPF_CNPJ_CLIENTE]				 
           ,[DDD1]							 
           ,[FONE1]							 
           ,[DDD2]							 
           ,[FONE2]							 
           ,[DDD3]							 
           ,[FONE3]							 
           ,[DDD4]							 
           ,[FONE4]							 
           ,[COD_TIPO_CLIENTE]				 
           ,[TIPO_CLIENTE]					 
           ,[ORIGEM_CLIENTE]				 
           ,[DATA_CONTATO_CS]				 
           ,[DATA_COTACAO_CS]				 
           ,[MODELO_VEICULO]				 
           ,[PLACA_VEICULO]					 
           ,[VALOR_PREMIO_BRUTO]			 
           ,[MOTIVO_RECUSA]					 
           ,[TIPO_SEGURO]					 
           ,[DATA_INICIO_VIGENCIA]			 
           ,[AGENCIA_COTACAO_CS]			 
           ,[NUMERO_COTACAO_CS]				 
           ,[VALOR_FIPE]					 
           ,[TIPO_PESSOA]					 
           ,[SEXO]							 
           ,[BONUS_ANTERIOR]				 
           ,[CEP]							 
           ,[ESTADO_CIVIL]					 
           ,[E_MAIL]						 
           ,[RELACAO_COND_SEGURADO]			 
           ,[DATA_NASC]						 
           ,[ANO_MODELO]					 
           ,[COD_FIPE]						 
           ,[USO_VEICULO]					 
           ,[BLINDADO]						 
           ,[CHASSI]						 
           ,[FORMA_CONTRATACAO]				 
           ,[FRANQUIA]						 
           ,[DANOS_MATERIAIS]				 
           ,[DANOS_MORAIS]					 
           ,[DANOS_CORPORAIS]				 
           ,[ASSIS_24_HRS]					 
           ,[CARRO_RESERVA]					 
           ,[GARANTIA_CARRO_RESERVA]		 
           ,[APP_PASSAGEIRO]				 
           ,[DESP_MEDICO_HOSP]				 
           ,[LANT_FAROIS_RETROVIS]			 
           ,[VIDROS]						 
           ,[DESP_EXTRAORDINARIAS]			 
           ,[ESTENDER_COB_PARA_MENORES]	
		   )

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
	TRY_CONVERT(datetime,[DATA_CONTATO_CS], 103) [DATA_CONTATO_CS],
	TRY_CONVERT(datetime,[DATA_COTACAO_CS], 103) [DATA_CONTATO_CS],
	[MODELO_VEICULO],
	[PLACA_VEICULO],
	VALOR_PREMIO_BRUTO,
	[MOTIVO_RECUSA],           
	[TIPO_SEGURO],
	TRY_CONVERT(datetime, [DATA_INICIO_VIGENCIA], 103) [DATA_INICIO_VIGENCIA],
	[AGENCIA_COTACAO_CS],
	[NUMERO_COTACAO_CS],
	ValorFIPE,
	TipoPessoa,
	[Sexo],
	[BONUS], 
	CEP,
	[ESTADO_CIVIL],
	[Email],
	[TIPO_COND_SEGURADO],
	TRY_CONVERT(datetime, [DATA_NASC], 103) [DATA_NASC] ,
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
	[ESTENDER_COB_PARA_MENORES]
	
FROM 
     Mailing.MailingAutoMS AS MS
WHERE [DataRefMailing] = @Data 
AND [NOME_CAMPANHA]='AQAUTORESTMS20150508'
AND NOT EXISTS (SELECT * FROM  OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] AS C WHERE Data_inclusao_Calculo  = @Data AND MS.[CPF]=C.CPF_CNPJ_CLIENTE COLLATE Latin1_General_CI_AS)






END