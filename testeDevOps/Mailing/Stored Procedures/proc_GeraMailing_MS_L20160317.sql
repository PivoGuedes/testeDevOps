
CREATE PROCEDURE [Mailing].[proc_GeraMailing_MS_L20160317](@DataMailing DATE /*A data será subtraida de um para a correta referência do mailing*/ )
AS

BEGIN 
	
	--DECLARE @DataMailing DATE ='2015-11-04'
	DECLARE @DataMailingRegistro DATE = @DataMailing


    DECLARE @SomaDiaInicio TINYINT = CASE datename(dw,@DataMailing) 
		WHEN 'Monday' THEN 2 
		WHEN 'Tuesday' THEN 2 
		WHEN 'Wednesday' THEN 2 
		ELSE 0 END 


    DECLARE @SomaDiaFim TINYINT = CASE datename(dw,@DataMailing) 
		WHEN 'Monday' THEN 2
		ELSE 0 END 

	DECLARE @TotalRegistrosRetAuto INT

	SELECT @TotalRegistrosRetAuto=COUNT(ID) FROM Dados.Atendimento WHERE DataArquivo= DATEADD(DD,(-1-@SomaDiaFim),@DataMailing) AND Arquivo LIKE '%DEVOLUÇÃO_PAR%'

	--IF (ISNULL(@TotalRegistrosRetAuto,0) = 0)
	--BEGIN
	--	SET @DataMailing =DATEADD(DD, -3 -@SomaDiaInicio , @DataMailingRegistro)  
	--END

	--PRINT DATEADD(DD,(-3-@SomaDiaInicio),@DataMailing) 
	--PRINT @DataMailingRegistro



	SELECT * INTO #MUNDOCAIXA
	FROM DBM.DBM_MKT.DBO.MUNDO_CAIXA

	CREATE CLUSTERED INDEX [IDX_CL_MUNDOCAIXA] ON #MUNDOCAIXA
	(
		[CPFCNPJ] ASC
	)

	CREATE NONCLUSTERED INDEX [IDX_NCL_MUNDOCAIXA_CPF] ON #MUNDOCAIXA
	(
		[CPFCNPJ] ASC
	)
	INCLUDE ([Nome],[DataNascimento],[EmailPessoal],[DDDResidencial],[TelefoneResidencial],[Matricula]) 
	WHERE ([CPFCNPJ]<>'000')
	


	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientesMS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
		DROP TABLE [dbo].[ClientesMS_TEMP];

    CREATE TABLE [dbo].[ClientesMS_TEMP]
	(
		[ID] [int] NOT NULL,
		[CPF] [varchar](18) NOT NULL,
		[CPF_NOFORMAT] [varchar](18) NULL,
		[DataNascimento] [date] NULL,
		[Nome] [varchar](150) NULL,
		[IDTelefoneEfetivo] [int] NULL,
		[IDAgenciaIndicacao] [smallint] NULL,
		[DateTime_Contato_Efetivo] [datetime] NULL,
		[IDTipoCliente] [tinyint] NULL,
		[CotacaoRealizada] [char](2) NULL,
		[ClassificaDataContato] [bigint] NULL,
		[Arquivo] [varchar](60) NULL,
		IDStatusFinal INT NULL,
		IDStatusLigacao INT NULL,
		RegraAplicada VARCHAR(100)
	) 

	-------------------------------------------------------------------------------------------------------------------------------------------
	--Carrega os clientes elegíveis em uma tabela temporária --INÍCIO		
	-------------------------------------------------------------------------------------------------------------------------------------------											  
	INSERT INTO [ClientesMS_TEMP] ([ID],[CPF],[CPF_NOFORMAT],[DataNascimento],[Nome],[IDTelefoneEfetivo],[IDAgenciaIndicacao],
								   [DateTime_Contato_Efetivo],[IDTipoCliente],[CotacaoRealizada],[ClassificaDataContato],[Arquivo], IDStatusFinal, IDStatusLigacao)
	SELECT 
	         A.ID
		   , A.CPF
		   , (replace(replace(replace(A.[CPF],'.',''),'/',''),'-','')) CPF_NOFORMAT
		   , A.DataNascimento
		   , A.Nome
		   , A.IDTelefoneEfetivo
		   , A.IDAgenciaIndicacao
		   , A.DateTime_Contato_Efetivo
		   , A.IDTipoCliente
		   , (CASE WHEN ISNUMERIC(A.CotacaoRealizada)=1 THEN A.CotacaoRealizada ELSE NULL END) AS CotacaoRealizada
		   , ROW_NUMBER() OVER(PARTITION BY A.CPF ORDER BY DateTime_Contato_Efetivo DESC) [N]
		   , A.Arquivo
		   , IDStatus_Final
		   , IDStatus_Ligacao
		FROM Dados.Atendimento A WITH (NOLOCK)
		INNER JOIN DADOS.STATUS_FINAL SFA
		ON SFA.ID = A.IDStatus_Final
		LEFT JOIN DADOS.Status_Ligacao SLA
		ON SLA.ID = A.IDStatus_Ligacao
	    WHERE  (
				   Arquivo LIKE 'SSIS_PAR_VENDA_NULL_ATIVO%' 
				OR Arquivo LIKE 'SSIS_PAR_VENDA_AQAUTSIS%'
				OR Arquivo LIKE 'SSIS_PAR_VENDA_NULL_RECEPTIVO%'
				OR Arquivo like 'SSIS_D%_RET_NULL_ATIVO%'
				OR Arquivo like 'SSIS_D%_RET_NULL_RECEPTIVO%'
				OR Arquivo like 'SSIS_D%_RET_AQAUTSIS%'
				OR Arquivo like 'SSIS_D%_RET_AUTO%'
				OR Arquivo like '%DEVOLUÇÃO_PAR_%_CAIXA SEGUROS%'
				) 
				AND A.NomeCampanha='AQAUTSIS20150901'
				AND A.DataArquivoCalculada IS NOT NULL
				AND SFA.Nome NOT LIKE '%transbordo%' --Elemina os transbordo
				AND
				(
		        (
					--A.DataArquivoCalculada>=DATEADD(DD,(-1-@SomaDia),@DataMailing)
					A.DataArquivoCalculada BETWEEN DATEADD(DD,(-3-@SomaDiaInicio),@DataMailing) AND DATEADD(DD,(-1-@SomaDiaFim),@DataMailingRegistro)
					AND EXISTS
					(
						SELECT ID FROM [Mailing].[MailingAutoKPN] AS MAK
						WHERE MAK.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						and MAK.cpf=a.CPF_NOFORMAT
						--and a.datacalculo=MAK.datacalculo
						and MAK.DataRefMailing=	DATEADD(DD, -3 -@SomaDiaInicio, @DataMailingRegistro)  
					)
					 
					AND
					(  
						
						A.IDStatus_Ligacao in 
											(
											SELECT ID--, *
											FROM Dados.Status_Ligacao WITH (NOLOCK)
											where nome in 
														(											
														'Caiu Ligação',
														'Caixa Postal',
														'Chamada Rejeitada',
														'Fax',
														'Ligação muda / ruído',
														'Mensagem Operadora / Fora de Serviço',
														'Não atende / Não responde',
														'Ocupado',
														'Privado',
														'Público',
														'Rediscagens',
														'Sem Agente Disponível',
														'Sem Tronco Disponível',
														'Telefone de Recado',
														'Telefone Errado'
														)

											)
						OR
						A.IDStatus_Final in 
											(
											SELECT ID--, *
											FROM Dados.Status_Final WITH (NOLOCK)
											where nome in 
														(											
														'Caiu Ligação',
														'Caixa Postal',
														'Chamada Rejeitada',
														'Fax',
														'Ligação muda / ruído',
														'Mensagem Operadora / Fora de Serviço',
														'Não atende / Não responde',
														'Ocupado',
														'Privado',
														'Público',
														'Rediscagens',
														'Sem Agente Disponível',
														'Sem Tronco Disponível',
														'Telefone de Recado',
														'Telefone Errado'
														)
											)
					)
					AND
					NOT EXISTS --Sem negócio fechado
								
								(
									SELECT *
									FROM Dados.Atendimento B WITH (NOLOCK)
									--WHERE B.DateTime_Contato_Efetivo >= DATEADD(DD,(-5 -@SomaDia),@DataMailing)
									WHERE B.NomeCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
									AND B.DataArquivoCalculada >= DATEADD(DD,(-3 -@SomaDiaInicio),@DataMailing) --and B.DataArquivoCalculada < DATEADD(DD,0, @DataMailing)
									AND B.CPF = A.CPF
									AND   (  B.IDStatus_Ligacao in 
														(
														SELECT ID--, *
														FROM Dados.Status_Ligacao WITH (NOLOCK)
														where nome in ( 'Apoio a Rede',
																		'Atendimento para outro Produto / Assunto',
																		'Cliente já possui outro seguro residencial',
																		'Cliente não aceita pagamento no mesmo dia',
																		'Cliente não elegível',
																		'Cliente não solicitou contato',
																		'Cliente recusou contato - Papafila',
																		'CPF já consta como cliente do produto',
																		'CPF não identificado/divergente',
																		'Falecido',
																		'Fidelidade à seguradora/corretora atual',
																		'Já contratou com a Caixa Seguradora',
																		'Já contratou com outras seguradoras',
																		'Não possui Veiculo',
																		'Prefere fechar na agência CAIXA',
																		'Prefere fechar na Caixa',
																		'Prefere pagamento em boleto',
																		'Proposta aceita',
																		'Proposta aceita com aplicação de desconto',
																		'Proposta aceita com aplicação de equiparação',
																		'Proposta Aceita NÃO Correntista',
																		'Renovação Automática Cancelada',
																		'Sem dados da Conta Corrente para Estorno',
																		'Sem interesse em seguro',
																		'Solicitação de Segunda Via de Boleto',
																		'Trote'
																	)
																)	
										
										OR
										B.IDStatus_Final in 
														(
														SELECT ID--, *
														FROM Dados.Status_Final WITH (NOLOCK)
														where nome in ( 'Apoio a Rede',
																		'Atendimento para outro Produto / Assunto',
																		'Cliente já possui outro seguro residencial',
																		'Cliente não aceita pagamento no mesmo dia',
																		'Cliente não elegível',
																		'Cliente não solicitou contato',
																		'Cliente recusou contato - Papafila',
																		'CPF já consta como cliente do produto',
																		'CPF não identificado/divergente',
																		'Falecido',
																		'Fidelidade à seguradora/corretora atual',
																		'Já contratou com a Caixa Seguradora',
																		'Já contratou com outras seguradoras',
																		'Não possui Veiculo',
																		'Prefere fechar na agência CAIXA',
																		'Prefere fechar na Caixa',
																		'Prefere pagamento em boleto',
																		'Proposta aceita',
																		'Proposta aceita com aplicação de desconto',
																		'Proposta aceita com aplicação de equiparação',
																		'Proposta Aceita NÃO Correntista',
																		'Renovação Automática Cancelada',
																		'Sem dados da Conta Corrente para Estorno',
																		'Sem interesse em seguro',
																		'Solicitação de Segunda Via de Boleto',
																		'Trote'
																	)
															)
													)

											)
									)


				OR --OU QUE NO DIA ANTERIOR TENHA DECLINADO
				(
						A.DataArquivoCalculada >= DATEADD(DD,(-1-@SomaDiaFim),@DataMailingRegistro) --and A.DataArquivoCalculada < DATEADD(DD,0, @DataMailing)
						-- AND CPF = '108.133.857-17'
						AND 
						(  A.IDStatus_Ligacao in 
												(
												SELECT ID--, *
												FROM Dados.Status_Ligacao WITH (NOLOCK)
												where nome in (
																'Apenas pesquisando',
																'Cliente não Possui Vinculo CEF',
																'Desconfiança/Desconhecimento sobre PAR CORRETORA',
																'Fidelidade a seguradora/corretora atual',
																'Fora do período de renovação (vence em mais de 30 dias)',
																'Insatisfeito com coberturas/planos/benefícios',
																'Menor valor na concorrência (Cliente com menor preço no mercado)',
																'Menor valor na concorrência',
																'Preço Alto (Cliente sem condições financeiras)',
																'Preço Alto',
																'Recusou-se/Desistiu a conversar',
																'Sistemas não permitiram cotação (Impossível cotar)',
																'Telefone não pertence ao cliente',
																'Veículo fora de aceitação em todas seguradoras (Seguradoras não retornaram cálculo)'
															)
												)
							OR
							A.IDStatus_Final in 
												(
												SELECT ID--, *
												FROM Dados.Status_Final WITH (NOLOCK)
												where nome in (
																'Apenas pesquisando',
																'Cliente não Possui Vinculo CEF',
																'Desconfiança/Desconhecimento sobre PAR CORRETORA',
																'Fidelidade a seguradora/corretora atual',
																'Fora do período de renovação (vence em mais de 30 dias)',
																'Insatisfeito com coberturas/planos/benefícios',
																'Menor valor na concorrência (Cliente com menor preço no mercado)',
																'Menor valor na concorrência',
																'Preço Alto (Cliente sem condições financeiras)',
																'Preço Alto',
																'Recusou-se/Desistiu a conversar',
																'Sistemas não permitiram cotação (Impossível cotar)',
																'Telefone não pertence ao cliente',
																'Veículo fora de aceitação em todas seguradoras (Seguradoras não retornaram cálculo)'
															)
												)
									)
	  
					)
				)

	/********************************************************************************************/
	/*Trecho para distribuição dos leads de acordo com a regra. INICIO*/
	/********************************************************************************************/
	UPDATE [ClientesMS_TEMP] SET RegraAplicada='Sem negócio fechado D5' WHERE
	IDStatusLigacao in 
	(
		SELECT ID
		FROM Dados.Status_Ligacao 
		where nome in (
						'Caiu Ligação',
						'Caixa Postal',
						'Chamada Rejeitada',
						'Fax',
						'Ligação muda / ruído',
						'Mensagem Operadora / Fora de Serviço',
						'Não atende / Não responde',
						'Ocupado',
						'Privado',
						'Público',
						'Rediscagens',
						'Sem Agente Disponível',
						'Sem Tronco Disponível',
						'Telefone de Recado',
						'Telefone Errado'
					)
		)
	OR
	IDStatusFinal in 
		(
		SELECT ID--, *
		FROM Dados.Status_Final WITH (NOLOCK)
		where nome in (
						'Caiu Ligação',
						'Caixa Postal',
						'Chamada Rejeitada',
						'Fax',
						'Ligação muda / ruído',
						'Mensagem Operadora / Fora de Serviço',
						'Não atende / Não responde',
						'Ocupado',
						'Privado',
						'Público',
						'Rediscagens',
						'Sem Agente Disponível',
						'Sem Tronco Disponível',
						'Telefone de Recado',
						'Telefone Errado'
					)
		)


		UPDATE [ClientesMS_TEMP] SET RegraAplicada='Recusa dia anterior' WHERE
		IDStatusLigacao in 
		(
			SELECT ID--, *
			FROM Dados.Status_Ligacao
			where nome in (
							'Apenas pesquisando',
							'Cliente não Possui Vinculo CEF',
							'Desconfiança/Desconhecimento sobre PAR CORRETORA',
							'Fidelidade a seguradora/corretora atual',
							'Fora do período de renovação (vence em mais de 30 dias)',
							'Insatisfeito com coberturas/planos/benefícios',
							'Menor valor na concorrência (Cliente com menor preço no mercado)',
							'Menor valor na concorrência',
							'Preço Alto (Cliente sem condições financeiras)',
							'Preço Alto',
							'Recusou-se/Desistiu a conversar',
							'Sistemas não permitiram cotação (Impossível cotar)',
							'Telefone não pertence ao cliente',
							'Veículo fora de aceitação em todas seguradoras (Seguradoras não retornaram cálculo)'
						)
			)
			OR
			IDStatusFinal in 
			(
			SELECT ID--, *
			FROM Dados.Status_Final WITH (NOLOCK)
			where nome in (
							'Apenas pesquisando',
							'Cliente não Possui Vinculo CEF',
							'Desconfiança/Desconhecimento sobre PAR CORRETORA',
							'Fidelidade a seguradora/corretora atual',
							'Fora do período de renovação (vence em mais de 30 dias)',
							'Insatisfeito com coberturas/planos/benefícios',
							'Menor valor na concorrência (Cliente com menor preço no mercado)',
							'Menor valor na concorrência',
							'Preço Alto (Cliente sem condições financeiras)',
							'Preço Alto',
							'Recusou-se/Desistiu a conversar',
							'Sistemas não permitiram cotação (Impossível cotar)',
							'Telefone não pertence ao cliente',
							'Veículo fora de aceitação em todas seguradoras (Seguradoras não retornaram cálculo)'
						)
			)

	/********************************************************************************************/
	/*Trecho para distribuição dos leads de acordo com a regra. FIM */
	/********************************************************************************************/

	-----------------------------------------------------------------------------------------------------------------------------------------
	--Carrega os clientes elegíveis em uma tabela temporária --FIM		
	-------------------------------------------------------------------------------------------------------------------------------------------	
	-------------------------------------------------------------------------------------------------------------------------------------------
	--Captura os dados dos clientes (aqui os clientes passam a aparecer varias vezes pois criam-se varias linhas de contatos por cliente) - INÍCIO
	-------------------------------------------------------------------------------------------------------------------------------------------	
	;WITH CTE
	AS
	(--DECLARE @DataMailing DATE = '2014-09-02'
	     SELECT *
	     FROM [dbo].[ClientesMS_TEMP]
	)
	,
	CTE1
	AS
	(
	SELECT A.Arquivo,
		   A.DateTime_Contato_Efetivo [DATA_CONTATO_CS],		  
		   CASE WHEN A.CotacaoRealizada = 1 THEN A.DateTime_Contato_Efetivo ELSE SA.DataCalculo END [DATA_COTACAO_CS],
		   --A.DATAARQUIVO,
		   'AQUISICAO_SEGURO AUTO_MS' [NOME_CAMPANHA],
		   'AQAUTOMS' [CODIGO_CAMPANHA],
		   'AQAUTOMS_' + REPLACE(Convert(date,@DataMailingRegistro,103),'-','') [CODIGO_MAILING],

		   --A.[NOME_CAMPANHA], 
		   --REPLACE(A.[NOME_CAMPANHA],'_','') [CODIGO_CAMPANHA],
		   --REPLACE(A.[NOME_CAMPANHA],'_','') + '_' + REPLACE(Cast(Cast(DataArquivo as Date) as varchar(10)),'-','') [CODIGO_MAILING],
		   ISNULL(A.Nome, SA.NomeCliente) [NOME_CLIENTE],
		   A.CPF [CPF],
		   --######ACT.TelefoneEmail [Telefone],
		   CASE WHEN PC.DDDTelefone = '' OR PC.DDDTelefone IS NULL THEN '0' ELSE REPLACE(REPLACE(PC.DDDTelefone, '-', ''), ' ', '') END DDDTelefone,
		   CASE WHEN PC.Telefone = '' OR PC.Telefone IS NULL THEN '0' ELSE  REPLACE(REPLACE(PC.Telefone, '-', ''), ' ', '') END Telefone,
		   TC.Codigo [COD_TIPO_CLIENTE],
		   TC.Descricao [TIPO_CLIENTE],
		   V.Nome [MODELO_VEICULO],
		   ISNULL(AV.Placa,SA.Placa) [PLACA_VEICULO],
		   CASE WHEN AV.Premio_Atual IS NULL OR AV.Premio_Atual <= 0 THEN ISNULL(SA.ValorPremio,0) ELSE AV.Premio_Atual END [VALOR_PREMIO_BRUTO],
		   SL.Nome [MOTIVO_RECUSA],
		   CASE TS.Descricao WHEN 'Novo' THEN 'Seguro Novo' ELSE TS.Descricao END [TIPO_SEGURO],
		   DataInicioVigencia [DATA_INICIO_VIGENCIA],
		   U.Codigo	[AGENCIA_COTACAO_CS],
		   SA.NumeroCalculo [NUMERO_COTACAO_CS],
		   SA.ValorFIPE,
		   SA.TipoPessoa,
		   LEFT(S.Descricao,1) [Sexo],
		   --Cast(REPLACE(CB.Descricao, '%', '') as int) BONUS,
		   Cast(CB.ID as int) BONUS,
		   SA.CEP,
		   EC.Descricao [ESTADO_CIVIL], --CASE WHEN EC.Descricao IS NULL OR EC.Descricao = '' THEN 'N/A' ELSE EC.Descricao END [ESTADO_CIVIL],
		   ISNULL(SA.EMail, PC.Email) Email ,
		   TRS.Descricao [TIPO_COND_SEGURADO],--CASE WHEN TRS.Descricao IS NULL OR TRS.Descricao = '' THEN 'N/A' ELSE TRS.Descricao END [TIPO_COND_SEGURADO],
		   ISNULL(SA.DataNascimento, A.DataNascimento)  [DATA_NASC],--CASE WHEN (A.DataNascimento IS NULL OR A.DataNascimento = '') AND (SA.DataNascimento IS NULL OR SA.DataNascimento = '') THEN 'N/A' ELSE ISNULL(SA.DataNascimento, A.DataNascimento) END [DATA_NASC],
		   SA.Ano [ANO_MODELO],
		   CASE WHEN V.[CodigoFIPE] IS NULL OR RTRIM(V.[CodigoFIPE]) = '' THEN -1 ELSE V.[CodigoFIPE] END [COD_FIPE],
		   TUV.Descricao [USO_VEICULO],
		   CASE WHEN SA.Blindado = 1 THEN 'S' WHEN SA.Blindado = 0 THEN 'N' ELSE NULL END [BLINDADO],
		   SA.Chassis [CHASSI],
		   FC.Descricao [FORMA_CONTRATACAO],
		   CF.Descricao [TIPO_FRANQUIA],
		   SA.CobDanosMateriais [DANOS_MATERIAIS],
		   SA.CobDanosMorais [DANOS_MORAIS],
		   SA.CobDanosCorporais [DANOS_CORPORAIS],
		   SA.IDAss24h [ASSIS_24_HRS],
		   SA.IDCarroReserva [CARRO_RESERVA],
		   CASE WHEN TCR.Descricao IS NULL OR TCR.Descricao = '' THEN 'N/A' ELSE TCR.Descricao END [GARANTIA_CARRO_RESERVA],
		   SA.CobAPP [APP_PASSAGEIRO],
		   SA.DespesasMedHosp [DESP_MEDICO_HOSP],
		   CASE WHEN SA.CobLantFarRetro = 1 THEN 'S' WHEN SA.CobLantFarRetro = 0 THEN 'N' ELSE NULL END [LANT_FAROIS_RETROVIS],
		   CASE WHEN SA.CobVidros = 1 THEN 'S' WHEN SA.CobVidros = 0 THEN 'N' ELSE NULL END [VIDROS],
		   CASE WHEN SA.CobDespesasExtras = 1 THEN 'S' WHEN SA.CobDespesasExtras = 0 THEN 'N' ELSE NULL END [DESP_EXTRAORDINARIAS],
		    CASE WHEN SA.EstendeCoberturaMenores = 1 THEN 'S' WHEN SA.EstendeCoberturaMenores = 0 THEN 'N' ELSE NULL END [ESTENDER_COB_PARA_MENORES]	   
	FROM CTE A
	OUTER APPLY (
						 SELECT  PC.Nome, PC.CPF, PC.DataNascimento,PC.Email Email, CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone1)),2) ELSE NULL END [DDDTelefone]
																										                          , CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone1)), LEN(LTRIM(RTRIM(PC.Telefone1))) - 2) ELSE NULL END [Telefone] 
			
						 FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
						 WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						 AND EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPF = A.CPF_NOFORMAT) AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)

						 UNION ALL
						 SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone2)),2) ELSE NULL END [DDDTelefone]
																										                          , CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone2)), LEN(LTRIM(RTRIM(PC.Telefone2))) - 2) ELSE NULL END [Telefone] 
			
						 FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
						 WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						 AND EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPF = A.CPF_NOFORMAT) AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)
						 						
						 UNION ALL
						 SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone3)),2) ELSE NULL END [DDDTelefone]
																										                          , CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone3)), LEN(LTRIM(RTRIM(PC.Telefone3))) - 2) ELSE NULL END [Telefone] 
			
						 FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
						 WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						 AND EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPF = A.CPF_NOFORMAT) AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing) 

						 UNION ALL
						 SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone4)),2) ELSE NULL END [DDDTelefone]
																										                          , CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone4)), LEN(LTRIM(RTRIM(PC.Telefone4))) - 2) ELSE NULL END [Telefone] 
			
						 FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
						 WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						 AND EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPF = A.CPF_NOFORMAT) AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)

						 


						 UNION ALL
						 SELECT  B.Nome, B.CPF, B.DataNascimento, ACE.TelefoneEmail Email, CASE WHEN  LEN(LTRIM(RTRIM(ACT.TelefoneEmail))) >=10 THEN left(LTRIM(RTRIM(ACT.TelefoneEmail)),2) ELSE NULL END [DDDTelefone]
																										 , CASE WHEN  LEN(LTRIM(RTRIM(ACT.TelefoneEmail))) >=10 THEN RIGHT(LTRIM(RTRIM(ACT.TelefoneEmail)), LEN(LTRIM(RTRIM(ACT.TelefoneEmail))) - 2) ELSE NULL END [Telefone] 
						 FROM CTE B WITH(NOLOCK)	
						  LEFT JOIN Dados.AtendimentoContatos ACT
						  ON ACT.ID = B.IDTelefoneEfetivo
						  AND ACT.TipoContato = 'Telefone'	
						  LEFT JOIN Dados.AtendimentoContatos ACE
						  ON ACE.ID = B.IDTelefoneEfetivo
						  AND ACE.TipoContato = 'Email'	
						 WHERE B.CPF = A.CPF	 
						 --UNION ALL

						 --SELECT NULL IDProposta, MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI, B.CPFCNPJ [CPFCNPJ], MC.DataNascimento, MC.EmailPessoal COLLATE SQL_Latin1_General_CP1_CI_AI, [DDDResidencial], [TelefoneResidencial]
						 --FROM  DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC
						 --INNER JOIN CTE B
						 --ON B.CPFCNPJ_BIGINT = Cast(MC.CPFCNPJ as bigint)
				) PC	
	LEFT JOIN Dados.AtendimentoClientePropostas [ACP] WITH(NOLOCK) 
	ON ACP.IDAtendimento = A.ID
	LEFT JOIN Dados.AtendimentoVeiculo AV WITH(NOLOCK) 
	ON AV.IDAtendimento = A.ID
	LEFT JOIN Dados.Status_Ligacao SL WITH(NOLOCK) 
	ON SL.ID = AV.IDStatus_Ligacao
	OUTER APPLY 
	            (
				 SELECT TOP 1 SA.IDTipoSeguro, SA.DataNascimento, SA.NumeroCalculo, SA.ValorFIPE, SA.NomeCliente, SA.TipoPessoa, SA.IDSexo
							, SA.IDClasseBonusAnterior, CEP, IDEstadoCivil, SA.IDTipoRelacaoSegurado, SA.DataInicioVigencia
							, SA.Ano, SA.CodModelo, SA.Blindado, SA.Chassis, SA.IDFormaContratacao, SA.DataCalculo
							, SA.IDTipoFranquia, SA.CobDanosMateriais, SA.CobDanosMorais, SA.IDAss24h, Email
							, SA.IDCarroReserva, SA.IDTipoCarroReserva, SA.CobAPP, SA.DespesasMedHosp, SA.IDVeiculo
							, SA.CobLantFarRetro, SA.CobVidros, SA.CobDespesasExtras, SA.EstendeCoberturaMenores
							, SA.IDTipoCliente, SA.IDTipoUsoVeiculo, SA.CobDanosCorporais, SA.Placa, SA.ValorPremio, SC.Descricao AS SituacaoCalculo
				 FROM Dados.SimuladorAuto SA WITH(NOLOCK) 
					left join Dados.Veiculo V WITH(NOLOCK) 
					ON  V.ID = SA.IDVeiculo
					INNER JOIN Dados.SituacaoCalculo AS SC
					ON SC.ID=SA.IDSituacaoCalculo
				 WHERE SA.CPFCNPJ = A.CPF
				 AND SA.DataCalculo >= DATEADD(DD,-15,@DataMailing)
				 --AND '2014-08-25' >= SA.DataCalculo
				 and SA.IDSituacaoCalculo NOT IN (4)
				 --AND mailing = mailing
				 ORDER BY SA.DataCalculo DESC, V.Codigo DESC
				) SA
		OUTER APPLY ( 
	              SELECT TOP 1 V.Codigo [CodigoFIPE], V.Nome 
	              FROM Dados.Veiculo V WITH(NOLOCK) 
	              WHERE V.ID = AV.IDVeiculo	OR V.ID = SA.IDVeiculo
				  and V.Codigo <> 0			    
				  ORDER BY Codigo DESC
				) V
	LEFT JOIN Dados.TipoCliente TC WITH(NOLOCK) 
	ON TC.ID = COALESCE(A.IDTipoCliente, SA.IDTipoCliente)
	LEFT JOIN Dados.TipoSeguro TS WITH(NOLOCK) 
	ON TS.ID = SA.IDTipoSeguro 
	LEFT JOIN Dados.Unidade U WITH(NOLOCK) 
	ON U.ID = A.IDAgenciaIndicacao
	LEFT JOIN Dados.Sexo S WITH(NOLOCK) 
	ON S.ID = SA.IDSexo
	LEFT JOIN Dados.EstadoCivil EC WITH(NOLOCK) 
	ON EC.ID = SA.IDEstadoCivil
	LEFT JOIN Dados.TipoRelacaoSegurado TRS WITH(NOLOCK) 
	ON TRS.ID = SA.IDTipoRelacaoSegurado
	LEFT JOIN Dados.FormaContratacao FC WITH(NOLOCK) 
	ON FC.ID = SA.IDFormaContratacao
	LEFT JOIN Dados.ClasseFranquia CF WITH(NOLOCK) 
	ON CF.ID = SA.IDTipoFranquia
	LEFT JOIN Dados.TipoCarroReserva TCR WITH(NOLOCK) 
	ON TCR.ID = SA.IDTipoCarroReserva
	LEFT JOIN Dados.TipoUsoVeiculo TUV WITH(NOLOCK) 
	ON TUV.ID = SA.IDTipoUsoVeiculo
	LEFT JOIN Dados.ClasseBonus CB
	ON CB.ID = SA.IDClasseBonusAnterior
	WHERE A.[ClassificaDataContato] = 1
	AND ISNULL(A.Nome, SA.NomeCliente)  IS NOT NULL
	AND TS.Descricao IN ('Novo','Renovação Congênere')
	AND SA.SituacaoCalculo NOT IN ('Proposta efetivada')
	--ORDER BY CPF
	) 
	--INSERE EM UMA TABELA TEMPORÁRIA
	SELECT * 
	INTO #A
	FROM CTE1
	-------------------------------------------------------------------------------------------------------------------------------------------
	--Captura os dados dos clientes (aqui os clientes passam a aparecer varias vezes pois criam-se varias linhas de contatos por cliente) - FIM
	-------------------------------------------------------------------------------------------------------------------------------------------	


	-------------------------------------------------------------------------------------------------------------------------------------------
	--Alimenta o mailing fazendo transformação de linha (dos contatos) em coluna, e removendo os clientes exclusivos do resultado - INÍCIO
	-------------------------------------------------------------------------------------------------------------------------------------------	




		;WITH CTT AS (
		SELECT * FROM #A

		UNION ALL
		
		SELECT 
			Arquivo
			,	SA.DataCalculo
			,	SA.DataCalculo as DataCotacao
			,	'AQUISICAO_SEGURO AUTO_MS' AS NomeCampanha
			,	'AQAUTOMS' AS CodigoCampanha
			,	'AQAUTOMS_' + REPLACE(Convert(date,@DataMailingRegistro,103),'-','') [CODIGO_MAILING]
			,	PC.NomeCliente
			,	SA.CPFCNPJ
			--,	MAK.CPF
			,	PC.DDDTelefoneContato
			,	PC.TelefoneContato 
			,	TC.Codigo AS CodigoTipoCliente 
			,	TC.Descricao AS DescricaoTipoCliente 
			,	V.Nome AS ModeloVeiculo
			,	Placa
			,	ValorPremio
			,	'Não abordado' AS MotivoRecusa
			,	CASE TS.Descricao WHEN 'Novo' THEN 'Seguro Novo' ELSE TS.Descricao END [TIPO_SEGURO]
			,	DataInicioVigencia
			,	U.Codigo AS AgenciaVenda
			,	NumeroCalculo
			,	ValorFipe
			,	TipoPessoa
			,	SUBSTRING(S.Descricao, 1,1) AS Sexo
			,	IDClasseBonusAnterior
			,	CEP
			,	EC.Descricao AS EstadoCivil
			,	PC.Email
			,	TRS.Descricao AS TipoCondSegurado
			,	PC.DataNascimento
			,	Ano
			,	CodModelo
			,	TUV.Descricao AS TipoUsoVeiculo
			,	(CASE Blindado WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS Blindado
			,	Chassis
			,	FC.Descricao AS FormaContratacao
			,	TF.Descricao AS TipoFranquia
			,	CobDanosMateriais
			,	CobDanosMorais
			,	CobDanosCorporais
			,	IDAss24h
			,	IDTipoCarroReserva
			,	'N/A' AS GarantiaCarroReserva
			,	CobAPP AS APP_Passageiro
			,	DespesasMedHosp 
			,	(CASE CobLantFarRetro WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS LANT_FAROIS_RETROVIS
			,	(CASE CobVidros WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS CobVidros
			,	(CASE CobDespesasExtras WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS CobDespesasExtras
			,	(CASE EstendeCoberturaMenores WHEN 0 THEN 'N' WHEN 1 THEN 'S' END) AS EstendeCoberturaMenores
		FROM Dados.SimuladorAuto  AS SA
		INNER JOIN Dados.TipoCliente AS TC
		ON SA.IDTipoCliente=TC.ID
		INNER JOIN Dados.Veiculo AS V
		ON SA.IDVeiculo=V.ID
		INNER JOIN Dados.TipoSeguro AS TS
		ON TS.ID=SA.IDTipoSeguro
		INNER JOIN Dados.Unidade AS U
		ON U.ID=SA.IDAgenciaVenda
		INNER JOIN Dados.Sexo AS S
		ON S.ID=SA.IDSexo
		INNER JOIN Dados.EstadoCivil AS EC
		ON EC.ID=SA.IDEstadoCivil
		INNER JOIN Dados.TipoRelacaoSegurado AS TRS
		ON TRS.ID=SA.IDTipoRelacaoSegurado
		INNER JOIN Dados.TipoUsoVeiculo AS TUV
		ON TUV.ID=SA.IDTipoUsoVeiculo
		INNER JOIN Dados.FormaContratacao AS FC
		ON FC.ID=SA.IDFormaContratacao
		INNER JOIN Dados.ClasseFranquia AS TF
		ON TF.ID=SA.IDTipoFranquia
		INNER JOIN Mailing.MailingAutoKPN AS MAK
		ON SA.CPFCNPJ_NOFORMAT=MAK.CPF
		AND MAK.DataRefMailing>=SA.DataCalculo
		INNER JOIN Dados.SituacaoCalculo AS SC
		ON SA.IDSituacaoCalculo=SC.ID
		AND SC.Descricao<>'Proposta efetivada'
		OUTER APPLY 
			(
					SELECT  SA.NomeCliente, SA.CPFCNPJ, SA.DataNascimento, SA.Email, SA.DDDTelefoneContato, SA.TelefoneContato

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento,PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone1)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone1))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone1)), LEN(LTRIM(RTRIM(PC.Telefone1))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
					AND SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone2)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone2))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone2)), LEN(LTRIM(RTRIM(PC.Telefone2))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
					AND SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)
						 						
					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone3)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone3))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone3)), LEN(LTRIM(RTRIM(PC.Telefone3))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
					AND SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)

					UNION ALL
					SELECT  PC.Nome, PC.CPF, PC.DataNascimento, PC.Email Email, 
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN left(LTRIM(RTRIM(PC.Telefone4)),2) ELSE NULL END [DDDTelefone],
							CASE WHEN  LEN(LTRIM(RTRIM(PC.Telefone4))) >=10 THEN RIGHT(LTRIM(RTRIM(PC.Telefone4)), LEN(LTRIM(RTRIM(PC.Telefone4))) - 2) ELSE NULL END [Telefone] 
					FROM Mailing.MailingAutoKPN PC WITH(NOLOCK) 
					WHERE PC.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
					AND SA.CPFCNPJ_NOFORMAT=PC.CPF AND PC.DataCalculo >= DATEADD(DD,-15 -@SomaDiaInicio,@DataMailing)

					
					

				) PC	
				WHERE	MAK.DataRefMailing=DATEADD(DD, -3 -@SomaDiaInicio , @DataMailingRegistro)    AND TS.Descricao IN ('Seguro Novo','Novo','Renovação Congênere') --DATEADD(DD, (-@SomaDiaD5), @DataMailing)  AND ValorPremio=0 AND TS.Descricao IN ('Seguro Novo','Novo')
				AND NOT EXISTS (	SELECT ID FROM Dados.Atendimento AS C2 
									WHERE 
									SA.CPFCNPJ_NOFORMAT=C2.CPF_NOFORMAT
									
									AND (C2.Arquivo LIKE '%SSIS_DEVOLUÇÃO_PAR_%_CAIXA SEGUROS.txt' OR C2.NomeCampanha='AQAUTSIS20150901')
									AND DataArquivoCalculada<@DataMailingRegistro
								)
				AND EXISTS		(
						SELECT ID FROM [Mailing].[MailingAutoKPN] AS MAK
						WHERE MAK.CodCampanha = 'AQAUTSIS20150901' ----Lincoln(20160316): incluido o filtro codigo de campanha
						AND MAK.cpf=sa.cpfcnpj_noformat
						and sa.datacalculo=MAK.datacalculo
						and MAK.DataRefMailing<@DataMailingRegistro
							
					)
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
	SELECT CTE1.Arquivo,
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
			@DataMailingRegistro AS DataMailing
	INTO #Temp_FINAL
	FROM FINAL A
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	-- Grava os CPF da quarentena na tabela temporaria 

	;  WITH Temp AS (
		SELECT DISTINCT CPF_CNPJ_CLIENTE COLLATE Latin1_General_CI_AS AS CPF FROM OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] WHERE Codigo_campanha = 'AQAUTOMS' AND Data_inclusao_calculo> DATEADD(DD,-60,@DataMailingRegistro) --and Data_inclusao_calculo < '2015-11-04'
		
		UNION
		
		SELECT DISTINCT CPF 
		FROM Mailing.MailingAutoMS 
		WHERE CODIGO_CAMPANHA = 'AQAUTOMS' ----Lincoln(20160316): incluido o filtro codigo de campanha
		AND DataRefMailing>=DATEADD(DD, -60 -@SomaDiaFim, @DataMailingRegistro) --and DataRefMailing < '2015-11-04'
				
		UNION
		SELECT DISTINCT  SUBSTRING(CPF,1,3) + '.' + SUBSTRING(CPF,4,3) + '.' + SUBSTRING(CPF,7,3) + '-' + SUBSTRING(CPF,10,2) FROM Mailing.MailingParIndica 
	) SELECT * INTO #TempCOL FROM Temp  


	------Alterado em 2016-01-22 por Pedro Guedes para processar corretamente a carga de enriquecimento dos telefones.
	;with ct_tel as (
        select CPFCNPJ as CPF, DDDResidencial as DDD, TelefoneResidencial as Telefone from #MUNDOCAIXA MC where TelefoneResidencial is not null  --and MC.Empresa ='Enriquecimento'
        UNION ALL
        select CPFCNPJ, DDDCelular, TelefoneCelular from #MUNDOCAIXA MC where TelefoneCelular is not null --and MC.Empresa ='Enriquecimento'
        UNION ALL
        select CPFCNPJ, DDDComercial, TelefoneComercial from #MUNDOCAIXA MC where TelefoneComercial is not null --and MC.Empresa ='Enriquecimento'
        UNION ALL
        select CPFCNPJ,try_parse(ddd as float) as DDD,try_parse(telefone as float)  as Telefone from (SELECT CPFCNPJ,replace(replace(replace(DDDFax,'-',''),' ',''),'.','') AS DDD,  replace(replace(replace(TelefoneFax,'-',''),' ',''),'.','')  as Telefone from #MUNDOCAIXA MC where TelefoneFax is not null AND TelefoneFax <> 'NULL' and TelefoneFax <> '' AND TelefoneFax <> 'NULL' AND tELEFONEFAX IS NOT NULL)x where try_parse(ddd as float) is not null and try_parse(telefone as float)is not null--and MC.Empresa ='Enriquecimento'
       )
       select 
             SUBSTRING(right('000000000' + CPF,11),1,3) + '.'+SUBSTRING(right('000000000' + CPF,11),4,3) + '.'+SUBSTRING(right('000000000' + CPF,11),7,3) + '-'+SUBSTRING(right('000000000' + CPF,11),10,2) COLLATE SQL_Latin1_General_CP1_CI_AI AS CPF,
             DDD , CAST(CAST(Telefone AS BIGINT) AS VARCHAR(20)) AS  Telefone,
             ROW_NUMBER() OVER (PARTITION BY CPF ORDER BY Telefone DESC) AS Ordem
       into #Temp_TelMC
       from ct_tel

	
	--------;with ct_tel as (
	--------	select CPFCNPJ as CPF, DDDResidencial as DDD, TelefoneResidencial as Telefone from #MUNDOCAIXA MC where TelefoneResidencial is not null and MC.Empresa ='Enriquecimento'
	--------	UNION ALL
	--------	select CPFCNPJ, DDDCelular, TelefoneCelular from #MUNDOCAIXA MC where TelefoneCelular is not null and MC.Empresa ='Enriquecimento'
	--------	UNION ALL
	--------	select CPFCNPJ, DDDComercial, TelefoneComercial from #MUNDOCAIXA MC where TelefoneComercial is not null and MC.Empresa ='Enriquecimento'
	--------	UNION ALL
	--------	select CPFCNPJ, DDDFAX, TelefoneFax from #MUNDOCAIXA MC where TelefoneFax is not null and MC.Empresa ='Enriquecimento'
	--------)
	--------select 
	--------	SUBSTRING(right('000000000' + CPF,11),1,3) + '.'+SUBSTRING(right('000000000' + CPF,11),4,3) + '.'+SUBSTRING(right('000000000' + CPF,11),7,3) + '-'+SUBSTRING(right('000000000' + CPF,11),10,2) COLLATE SQL_Latin1_General_CP1_CI_AI AS CPF,
	--------	DDD , CAST(CAST(Telefone AS BIGINT) AS VARCHAR(20)) AS Telefone,
	--------	ROW_NUMBER() OVER (PARTITION BY CPF ORDER BY Telefone DESC) AS Ordem
	--------into #Temp_TelMC
	--------from ct_tel
	
	
	
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	/****************************************************************************************************************************/
	 
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
			COALESCE(TEL1.DDD, DDDTelefone2) AS DDDTelefone2,
			COALESCE(TEL1.Telefone,Telefone2) AS Telefone2,
			COALESCE(TEL2.DDD,DDDTelefone3) AS DDDTelefone3,
			COALESCE(TEL2.Telefone,Telefone3) AS Telefone3,
			COALESCE(TEL3.DDD,DDDTelefone4) AS DDDTelefone4,
			COALESCE(TEL3.Telefone,Telefone4) AS Telefone4,
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
	OUTER APPLY (select DDD,Telefone from #Temp_TelMC AS T WHERE T.CPF=A.CPF AND T.Ordem=1) AS TEL1 ----and (LEN(T.Telefone) <= 9)
	OUTER APPLY (select DDD,Telefone from #Temp_TelMC AS T WHERE T.CPF=A.CPF AND T.Ordem=2) AS TEL2
	OUTER APPLY (select DDD,Telefone from #Temp_TelMC AS T WHERE T.CPF=A.CPF AND T.Ordem=3) AS TEL3
	OUTER APPLY (select DDD,Telefone from #Temp_TelMC AS T WHERE T.CPF=A.CPF AND T.Ordem=4) AS TEL4
	WHERE  Telefone1 IS NOT NULL
	AND ISNULL(TV.TipoVeiculo,'')<>'Moto'
	AND NOT EXISTS (
	                SELECT *
	                FROM Dados.Funcionario F
					WHERE F.CPF = A.[CPF]
					AND F.IDEmpresa = 1 
				   )

	AND NOT EXISTS (
					SELECT DISTINCT CPF 
					FROM #TempCOL
					WHERE CPF=A.CPF COLLATE Latin1_General_CI_AS
					)

	-----Exclui os registros que possuem status de proposta efetivada dentro do período de 7 dias
	AND NOT EXISTS (
					SELECT SA.CPFCNPJ
					FROM Dados.SimuladorAuto AS SA
					WHERE DataArquivo>=DATEADD(DD, -7 -@SomaDiaInicio, @DataMailingRegistro) ----and SA.DataArquivo < '20160201'
					AND SA.IDSituacaoCalculo = 4
					AND SA.CPFCNPJ = A.CPF
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

	/**************************************************************************/
	/*Trecho de código que atualiza campo de rastreamento dos leads - inicio*/
	/**************************************************************************/

	UPDATE Mailing.MailingAutoMS SET RegraAplicada=T.RegraAplicada FROM  
	Mailing.MailingAutoMS AS M 
	INNER JOIN [ClientesMS_TEMP] AS T
	ON M.CPF=T.CPF
	WHERE DataRefMailing=@DataMailingRegistro

	UPDATE Mailing.MailingAutoMS SET RegraAplicada='Não abordado' WHERE 
	DataRefMailing=@DataMailingRegistro
	AND MOTIVO_RECUSA='Não abordado'
	AND CODIGO_CAMPANHA = 'AQAUTOMS' -----Lincoln(20160316): incluido o filtro codigo de campanha
	/**************************************************************************/
	/*Trecho de código que atualiza campo de rastreamento dos leads - inicio*/
	/**************************************************************************/



	DECLARE @TotalQuarentena INT
	DECLARE @TotalTelefoneNull INT
	DECLARE @TotalMotos INT
	DECLARE @TotalEconomiarios INT

	SELECT @TotalQuarentena= COUNT(DISTINCT CPF) FROM #Temp_FINAL WHERE CPF  COLLATE Latin1_General_CI_AS IN (SELECT * FROM #TempCOL)

	SELECT @TotalTelefoneNull=COUNT(DISTINCT CPF) FROM #Temp_FINAL WHERE Telefone1 IS NULL

	SELECT @TotalMotos=COUNT(*) FROM #Temp_FINAL AS F 
	OUTER APPLY (SELECT TOP 1 TipoVeiculo
				FROM Dados.TabelaFIPE
				WHERE CodigoCompleto=F.COD_FIPE
			) AS TV
	WHERE ISNULL(TV.TipoVeiculo,'')='Moto'

	SELECT @TotalEconomiarios=COUNT(*) 
	FROM #Temp_FINAL AS A
	WHERE 
	(	Email like '%@caixa.gov.br'
		 OR
		(
				 ( 
				  [TIPO_CLIENTE] like '%PARENTE DO ECONOMIÁRIO (PAIS E FILHOS)%'
				  OR
				  [TIPO_CLIENTE] like '%CÔNJUGE DO ECONOMIÁRIO%'
				  OR
				  [TIPO_CLIENTE] like '%AUTO EXCLUSIVO%'
				  )
				  OR
				  [TIPO_CLIENTE] IS NULL
		)
		OR 	EXISTS (
	                SELECT *
	                FROM Dados.Funcionario F
					WHERE F.CPF = A.[CPF]
					AND F.IDEmpresa = 1 
				   )
	)



	/**************************************************************************/
	/*****	Grava log de envio	****/
	/**************************************************************************/

	DECLARE @TotalRegistros INT=0
	DECLARE @CodigoMailing VARCHAR(100)
	DECLARE @NomeCampanha VARCHAR(100)

	DECLARE @TotalCPFInicio INT
	SELECT @TotalCPFInicio=(SELECT ISNULL(COUNT(CPF),0) FROM #Temp_FINAL)

	--DECLARE @DataMailing DATE 
	--SET @DataMailing ='2015-03-10'
	
	SELECT @TotalRegistros=COUNT(*),@CodigoMailing=Codigo_Mailing,  @NomeCampanha=Nome_campanha 
	FROM Mailing.MailingAutoMS 
	WHERE DataRefMailing=@DataMailingRegistro AND Nome_Campanha='AQUISICAO_SEGURO AUTO_MS' GROUP BY Codigo_Mailing, Nome_campanha

	EXEC [Mailing].[proc_RegistraLogMailing_MS] @DataMailing=@DataMailingRegistro, @Empresa='SistemasSeguros', @NomeArquivo=@CodigoMailing, @QtdREgistros=@TotalRegistros, @Campanha=@NomeCampanha
	--PRINT @CodigoMailing




	/**********************************************************************************************************/
	/**********************************************************************************************************/

	DECLARE @texto VARCHAR(max)

	DECLARE @NaoCotados VARCHAR(10) = (SELECT ISNULL(COUNT(*),0) AS NCotados FROM mailing.mailingautoms WHERE datarefmailing=@DataMailingRegistro AND CODIGO_CAMPANHA = 'AQAUTOMS' AND DataEnvioMailing IS NULL)
	DECLARE @RegraAplicada VARCHAR(50), @QTDLeads INT;
	SET @Texto = '<table><tr><td>Total de leads</td><td>' +  CAST(@TotalCPFInicio AS VARCHAR(10)) + '</td></tr>
	<tr><td>Economiarios</td><td>' + CAST(@TotalEconomiarios AS VARCHAR(10)) + '</td></tr>
	<tr><td>Motos</td><td>' + CAST(@TotalMotos AS VARCHAR(10)) + '</td></tr>
	<tr><td>Não cotados pelo COL</td><td>' + @NaoCotados + '</td></tr>
	'
	DECLARE Mailing_cursor CURSOR FOR
	

	WITH C AS (
		SELECT ISNULL(RegraAplicada,'Não identificado') AS RegraAplicada, count(*) AS QtdLeads 
		FROM mailing.mailingautoms 
		WHERE datarefmailing=@DataMailingRegistro 
		AND CODIGO_CAMPANHA = 'AQAUTOMS'
		GROUP BY RegraAplicada
	)
	SELECT * FROM C;



	OPEN Mailing_cursor;

	FETCH NEXT FROM Mailing_cursor
	INTO @RegraAplicada, @QTDLeads;

	WHILE @@FETCH_STATUS = 0
	BEGIN

	   --SET @Texto = @Texto + @RegraAplicada + ' ' +  CAST(@QTDLeads AS VARCHAR(5)) + '    '
	   SELECT @Texto=(@Texto + '<tr><td>' + @RegraAplicada + '</td><td>' + CAST(@QTDLeads AS VARCHAR(5)) + '</td></tr>')
	   -- This is executed as long as the previous fetch succeeds.
	   FETCH NEXT FROM Mailing_cursor
	   INTO @RegraAplicada, @QTDLeads;
	END
	SET @Texto=@Texto+'</table>'
	--@TotalCPFInicio
	UPDATE [ControleDados].[LogMailing] SET QuantidadeEconomiarios=@TotalEconomiarios, QuantidadeMotos=@TotalMotos, TextoVariavel=@Texto WHERE Campanha='AQUISICAO_SEGURO AUTO_MS' AND DataRefMailing=@DataMailingRegistro 

	CLOSE Mailing_cursor;
	DEALLOCATE Mailing_cursor;

END







