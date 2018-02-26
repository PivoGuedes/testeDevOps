CREATE PROCEDURE [dbo].[proc_RecuperaCarteiraRD_RenovacaoResidencial]
as 
	
--drop table #PRP_RES

create table #PRP_RES
(IDProposta BIGINT DEFAULT(0)
,IDContrato BIGINT DEFAULT(0)
,ContratoEndosso bit default(0)
,PropostaSIGPF bit default(0)
,PropostaRES bit default(0)
,StatusParcelaCan bit default(0)
,StatusPropCan bit default(0)
,StatusContratoCan bit default(0)
,StatusEndossoCan bit default(0)
,IDProduto INt
)


CREATE CLUSTERED INDEX IDX_CL_IDContrato_IDProposta ON #PRP_RES (IDContrato, IDProposta);
------Encontra contratos POR vigencia  pelo contrato
;MERGE INTO #PRP_RES T
USING
(
	SELECT DISTINCT CNT.ID IDContrato, CNT.IDProposta, CNT.DataFimVigencia,  CASE WHEN cnt.DataCancelamento is not null THEN 1 ELSE 0 END StatusContratoCan, 1 ContratoEndosso
			FROM Dados.Contrato CNT
			INNER JOIN Dados.Endosso EN
			ON EN.IDContrato = CNT.ID
			INNER JOIN Dados.Produto PRD
			ON PRD.ID = EN.IDProduto
			LEFT JOIN Dados.ProdutoSIGPF PSIG
			ON PSIG.ID = PRD.IDProdutoSIGPF
			WHERE PSIG.CodigoProduto IN  ('71', '72')
			AND (CNT.DataFimVigencia >=  GETDATE() OR CNT.DataFimVigencia is null) --GETDATE()
			 
) AS S
ON  T.IDContrato = S.IDContrato -- -ISNULL(T.IDContrato,-1) = ISNULL(S.IDContrato,-1)
AND T.IDProposta >= 0 --= S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, ContratoEndosso,  StatusContratoCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.ContratoEndosso, StatusContratoCan);


------Encontra contratos POR vigencia  pela proposta e prod.SIGPF
;MERGE INTO #PRP_RES T
USING
( SELECT * FROM (
			SELECT  PRP.ID IDProposta, PRP.IDContrato, CASE WHEN PRP.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaSIGPF,ROW_NUMBER() OVER (PARTITION BY IDContrato ORDER BY PRP.ID) LINHA
			FROM Dados.Proposta PRP
			INNER JOIN Dados.ProdutoSIGPF PSG
			ON PSG.ID = PRP.IDProdutoSIGPF
			WHERE (PSG.CodigoProduto IN  ('71', '72')
				   AND (PRP.DataFimVigencia   >=  GETDATE() OR PRP.DataFimVigencia is null)
		  )
			and IDContrato is not null
	) X WHERE LINHA = 1 --and IDContrato  =20309081
) AS S
ON  T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
--AND ISNULL(T.IDProposta,S.IDProposta) = ISNULL(S.IDProposta,T.IDProposta)
AND T.IDProposta >= 0
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaSIGPF, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaSIGPF, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaSIGPF = S.PropostaSIGPF
		 --, IDContrato = COALESCE(T.IDContrato, S.IDContrato),
		 , IDProposta = CASE WHEN T.IDProposta = 0 THEN S.IDProposta ELSE T.IDProposta END;


;MERGE INTO #PRP_RES T
USING
(
SELECT PRP.ID IDProposta, PRP.IDContrato, CASE WHEN PRP.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaSIGPF
FROM Dados.Proposta PRP
INNER JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF
WHERE (PSG.CodigoProduto IN  ('71', '72')
	   AND( PRP.DataFimVigencia   >= GETDATE() OR PRP.DataFimVigencia is null)
	  )
	--  and prp.idcontrato = 			 6649861

) AS S
ON  --T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
   T.IDContrato >= 0
AND T.IDProposta = S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaSIGPF, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaSIGPF, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaSIGPF = S.PropostaSIGPF
		 , IDContrato = CASE WHEN T.IDContrato = 0 THEN S.IDContrato ELSE T.IDContrato END;
		 --, IDProposta = COALESCE(T.IDProposta, S.IDProposta);
--SELECT * FROM Dados.SituacaoProposta

------Encontra contratos POR vigencia pela proposta e proposta RES
;MERGE INTO #PRP_RES T
USING
( select * from (
		SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaRES,row_number() over (partition by IDcontrato order by IDContrato) linha
		FROM Dados.Proposta PRP1
		INNER JOIN Dados.PropostaResidencial PA
		ON PA.IDProposta = PRP1.ID
		WHERE  ( PRP1.DataFimVigencia   >=  GETDATE() OR PRP1.DataFimVigencia is null)
		) x where linha = 1
) AS S
ON  T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
--AND ISNULL(T.IDProposta,S.IDProposta) = ISNULL(S.IDProposta,T.IDProposta)
AND T.IDProposta >= 0
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaRES, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaRES, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaRES = S.PropostaRES
         , StatusPropCan =S.StatusPropCan
		 --, IDContrato = COALESCE(T.IDContrato, S.IDContrato),
		 , IDProposta = CASE WHEN T.IDProposta = 0 THEN S.IDProposta ELSE T.IDProposta END;


------Encontra contratos POR vigencia pela proposta e proposta RES
;MERGE INTO #PRP_RES T
USING
( select * from (
		SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaRES,row_number() over (partition by IDcontrato order by IDContrato) linha
		FROM Dados.Proposta PRP1
		INNER JOIN Dados.PropostaResidencial PA
		ON PA.IDProposta = PRP1.ID
		WHERE  ( PRP1.DataFimVigencia   >= GETDATE() OR PRP1.DataFimVigencia is null)
			) x where linha = 1
) AS S
ON   --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
 T.IDContrato >= 0
AND  T.IDProposta = S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaRES, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaRES, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaRES = S.PropostaRES
         , StatusPropCan =S.StatusPropCan
		 , IDContrato = CASE WHEN T.IDContrato = 0 THEN S.IDContrato ELSE T.IDContrato END;
		 --, IDProposta = COALESCE(T.IDProposta, S.IDProposta);
------------------------------------------------



------Encontra contratos cancelados pela parcela
;
WITH CTE
AS
(
	SELECT  IDContrato--, IDProposta
	FROM Dados.Endosso en --WHERE IDCONTRATO = 24684982
	inner join dados.Parcela p
	on p.IDEndosso = en.id
	WHERE EN.Arquivo LIKE '%MR00%'
	AND P.DataArquivo <= GETDATE()
	AND P.IDParcelaOperacao IN (SELECT PO.ID
								FROM Dados.ParcelaOperacao PO
								--WHERE ID IN (14,
								--			16,
								--			19,
								--			22,
								--			24,
								--			26)
								where Descricao like '%canc%'
							   )
	AND EXISTS (SELECT *
	            FROM #PRP_RES P
				WHERE P.IDContrato = EN.IDContrato)
)
UPDATE #PRP_RES SET StatusParcelaCan = 1
FROM CTE 
INNER JOIN #PRP_RES P
ON P.IDContrato = CTE.IDContrato
;


IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like '%#ClienteRESPF%')-- OBJECT_ID = OBJECT_ID('dbo.#ClienteRESPF'))
  DROP TABLE #ClienteRESPF;
------------------------------------------------
-- Dados do contrato RES - Conta     SELECT * INTO select * into #RENOVACAORD FROM DBM.Fabrica_camp.dbo.MKDRERES_SFMC  where   DATA_MAILING   = '2016-09-26 14:57:12.070' OR ([Data Fim Vigencia] >= '2016-09-28' and 	[Data Fim Vigencia] <= '2016-10-13') alter table #RENOVACAORD add CPFFormat varchar(20) update #RENOVACAORD  set CPFFormat = CleansingKit.dbo.fn_formataCPF(CPF)
------------------------------------------------
---if exists DROP table #RENOVACAORD --#ClienteRESPF     28/09/2016 e 13/10/2016
--select * from  #RENOVACAORD where  telefone ='' and emailadress =''
--select top 1 * from     DBM.Fabrica_camp.dbo.MKDRERES_SFMC order by DATA_MAILING desc
select *  into #RENOVACAORD  FROM DBM.Fabrica_camp.dbo.MKDRERES_SFMC  where   DATA_MAILING   ='2016-10-06 15:16:55.687'-- >=  '2016-09-04' OR ([Data Fim Vigencia] >= '2016-09-04' and 	[Data Fim Vigencia] <= '2016-09-29') 
alter table #RENOVACAORD add CPFFormat varchar(20) 
update #RENOVACAORD  set CPFFormat = CleansingKit.dbo.fn_formataCPF(CPF)
CREATE CLUSTERED INDEX CL_IDX_CPFrd_TEMP ON #RENOVACAORD (CPFFormat)
;
with cte
as
(
SELECT 
DISTINCT
--prp.idproposta
  COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) CPF
, CleansingKit.[dbo].[CapitalizeFirstLetter](CleansingKit.dbo.fn_getFirstName(COALESCE(PC.Nome, CC.NomeCliente))) FirstName
, CleansingKit.[dbo].[CapitalizeFirstLetter](CleansingKit.dbo.fn_getLastName(COALESCE(PC.Nome, CC.NomeCliente))) LastName
, COALESCE(PC.Nome, CC.NomeCliente) Nome
, PC.DataNascimento
, PE.Bairro
, PE.Cidade
, PE.Endereco
, PE.UF
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(NULL, RRD.Telefone)),dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDCelular, PC.TelefoneCelular)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelCelular
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDResidencial, PC.TelefoneResidencial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelResidencial
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDComercial, PC.TelefoneComercial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelComercial
,S.Descricao Sexo
,EC.Descricao EstadoCivil
,PE.CEP
,coalesce(RRD.EmailAdress COLLATE SQL_Latin1_General_CP1_CI_AI,PC.Email) EMAIL
,PC.Emailcomercial
,RRD.Exclusivo
,RRD.[Nova Proposta]
,RRD.Premio
,RRD.Parcelas
,RRD.[Valor por Parcela]
,RRD.[Codigo de Barras]
,RRD.[Tipo Renovacao]
,RRD.[Data Vencimento]
,RRD.EmailAdress
,RRD.Telefone
,RRD.COD_CAMPANHA
,RRD.NOME_CAMPANHA
,RRD.[Numero Apolice]
--,RRD.CPF cpfRES
--,CodigoUnidade
--,NomeUnidade
--,MatriculaIndicador
--,NomeIndicador
, ROW_NUMBER() OVER(PARTITION BY COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) ORDER BY PE.IDTipoEndereco) ORDEM
FROM #PRP_RES PRP
LEFT JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.IDProposta
LEFT JOIN Dados.ContratoCliente CC
ON CC.IDContrato = PRP.IDContrato
LEFT JOIN Dados.Sexo S
ON S.ID = PC.IDSexo
LEFT JOIN Dados.EstadoCivil EC
ON EC.ID = PC.IDEstadoCivil
LEFT JOIN Dados.PropostaEndereco PE
ON PE.IDProposta = PRP.IDProposta
AND PE.LastValue = 1
INNER JOIN #RENOVACAORD RRD 
ON RRD.CPFFormat = PC.CPFCNPJ collate SQL_Latin1_General_CP1_CI_AS

--WHERE (StatusPropCan = 0 OR  StatusPropCan IS NULL)
--AND   (StatusParcelaCan = 0 OR StatusParcelaCan IS NULL)
--AND   (StatusEndossoCan = 0 OR StatusEndossoCan IS NULL)
--AND   (StatusContratoCan = 0 OR StatusContratoCan IS NULL)

--select * from #RENOVACAORD
--update #RENOVACAORD set CPFFormat = CleansingKit.dbo.fn_FormataCPF(CPF) 
) --select * from dados.produtosigpf where id =  where codigocomercializado = '1805'
SELECT *--count(distinct IDContrato)
INTO #ClienteRESPF

  
FROM CTE
--inner join SALESFORCE_PROD...Account ac where ac.TipoCorrespondente__c = 'ADES AUT'
--where not exists (select * from cte cte1
--				 where cte1.IDProposta = cte.IDProposta
--				 and cte1.ORDEM > 1)
where ORDEM = 1--  cte.idproposta is null
--ORDER BY cte.IDContrato--, ORDEM
--SELECT @@TRANCOUNT
--COMMIT
--begin tran
--select * from #PRP_RES where IDContrato = 22130274
--select * from Dados.Contrato where NumeroContrato = '1201402764034'
--select * from #ClienteRESPF drop table #ClienteRESPF
--SELECT COUNT(DISTINCT #PRP_RES.IDContrato), PSG.CodigoComercializado, PSG.Descricao

UPDATE #PRP_RES SET IDProduto = PSG.ID
FROM #PRP_RES
	INNER JOIN Dados.Proposta PRD
	ON PRD.ID = #PRP_RES.IDProposta
	OUTER APPLY (SELECT TOP 1 * 
				 FROM Dados.Endosso EN
				 WHERE EN.IDContrato = #PRP_RES.IDContrato
				   AND EN.IDProduto IS NOT NULL
				 ORDER BY EN.DataArquivo DESC
				 ) E
	LEFT JOIN Dados.Produto PSG
	ON PSG.ID = CASE WHEN PRD.IDProduto IS NULL OR PRD.IDProduto = -1 THEN E.IDProduto ELSE PRD.IDProduto END
WHERE StatusParcelaCan = 0 
  AND StatusPropCan = 0 
  AND StatusContratoCan = 0 
  AND StatusEndossoCan = 0

--GROUP BY PSG.CodigoComercializado, PSG.Descricao
--ORDER BY CodigoComercializado


truncate table Stage_SalesForce.Enqueue.account_load_cliente_RD
;
MERGE INTO 
 Stage_SalesForce.Enqueue.account_load_cliente_RD T
USING (
		SELECT *--, CASE WHEN CPF LIKE '%/%' THEN '0121a0000006O7BAAU' ELSE '0121a0000006O8dAAE' END RecordTypeId
		FROM #ClienteRESPF
	  ) S
ON  --S.RecordTypeId = T.RecordTypeId
--AND 
S.CPF COLLATE SQL_Latin1_General_CP1_CI_AS = T.CPF_CNPJ__c
WHEN NOT MATCHED THEN
INSERT (--RecordTypeId, 
        CPF_CNPJ__c, FirstName, LastName, Name, DataNascimento__c,  Bairro__c, Cidade__c, Endereco__c, UF__c, CEP,  Phone, Sexo, MobilePhone, EstadoCivil)--, CreatedDate, id) 
VALUES (--S.RecordTypeId,
        S.CPF, FirstName, LastName, s.Nome, S.DataNascimento, S.Bairro, S.Cidade, S.Endereco, S.UF, S.CEP,
	    COALESCE(TelResidencial, TelComercial,TelCelular), S.Sexo, CASE WHEN S.TelCelular IS NULL THEN CASE WHEN RIGHT(LEFT(COALESCE(TelResidencial, TelComercial,TelCelular),3),1) IN ('7','8','9') THEN COALESCE(TelResidencial, TelComercial,TelCelular) ELSE S.TelCelular END END, S.EstadoCivil);

------------------------------------------------
-- Dados do contrato RES - Contrato
------------------------------------------------

CREATE NONCLUSTERED INDEX [ncl_idx_TMP_RES]
ON [dbo].[#PRP_RES] ([StatusParcelaCan],[StatusPropCan],[StatusContratoCan],[StatusEndossoCan])
INCLUDE ([IDProposta],[IDContrato],[ContratoEndosso],[PropostaSIGPF],[PropostaRES])
CREATE NONCLUSTERED INDEX [ncl_idx_status_temp]
ON [dbo].[#PRP_RES] ([IDProposta],[StatusParcelaCan],[StatusPropCan],[StatusContratoCan],[StatusEndossoCan])
INCLUDE ([IDContrato],[ContratoEndosso],[PropostaSIGPF],[PropostaRES])


truncate table Stage_SalesForce.Enqueue.[Contract_load_contract_RD]  

;
with cte
as
(   --SELECT * from #RENOVACAORD where [Nome Completo]= 'ANDRE LUIZ OLIVEIRA DA SILVA'
	SELECT distinct
		  PRP.IDContrato 
		, PRP.IDProposta
		, PRP.ContratoEndosso 
		, PRP.PropostaSIGPF 
		, PRP.PropostaRES 
		, PRP.StatusParcelaCan 
		, PRP.StatusPropCan 
		, PRP.StatusContratoCan 
		, PRP.StatusEndossoCan 
		, CNT.NumeroContrato
		, COALESCE(PRP2.NumeroProposta, PRP1.NumeroProposta) NumeroProposta
		, CASE WHEN PA.IndicadorRenovacaoAutomatica = 1 THEN 'Sim' ELSE 'Não' END RenovacaoAutomatica
		, PRP1.DataProposta
		, PRD.CodigoComercializado
		, PRD.Descricao [ProdutoComercializado]
		, PSG.CodigoProduto [CodigoProdutoSIGPF]
		, PSG.Descricao [ProdutoSIGPF]
		, pf.TelCelular--dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDCelular, PC.TelefoneCelular)) TelCelular
		, pf.TelResidencial--dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDResidencial, PC.TelefoneResidencial)) TelResidencial
		, pf.TelComercial--dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDComercial, PC.TelefoneComercial)) TelComercial
		, COALESCE(PRP1.DataInicioVigencia, CNT.DataInicioVigencia, PRP2.DataInicioVigencia) DataInicioVigencia
		, COALESCE(CNT.DataFimVigencia, PRP1.DataFimVigencia, PRP2.DataFimVigencia) DataFimVigencia
		, COALESCE(RN.Apolice_Renovada, CNTA.NumeroContrato, PA1.NumeroApoliceAnterior) NumeroApoliceAnterior
		, pf.Endereco EnderecoLocalRisco--CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN CNT.EnderecoLocalRisco ELSE COALESCE(CC.Endereco, PE.Endereco) END EnderecoLocalRisco 
		, CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN CNT.BairroLocalRisco ELSE COALESCE(CC.Bairro, PE.Bairro) END BairroLocalRisco
		, CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN CNT.CidadeLocalRisco ELSE COALESCE(CC.Cidade, PE.Cidade) END CidadeLocalRisco
		, CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN CNT.UFLocalRisco ELSE COALESCE(CC.UF, PE.UF) END UFLocalRisco
		, CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN NULL ELSE COALESCE(CC.CEP, PE.CEP) END CEP
		, COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) CPF_CNPJ
		, COALESCE(PC.Nome, CC.NomeCliente) Nome
		, CleansingKit.dbo.fn_getFirstName(COALESCE(PC.Nome, CC.NomeCliente)) FirstName
        , CleansingKit.dbo.fn_getLastName(COALESCE(PC.Nome, CC.NomeCliente)) LastName
		, COALESCE(PC.DataNascimento, Cast('1900-01-01' as Date)) DataNascimento
		, COALESCE(CNT.QuantidadeParcelas, E.QuantidadeParcelas) QuantidadeParcelas
		,  COALESCE(EN.ValorPremioTotal, CNT.ValorPremioTotal) ValorPremioTotal	 															 
        , COALESCE(EN.ValorPremioLiquido, CNT.ValorPremioLiquido) ValorPremioLiquido		
	 
		, PA.ValorPrimeiraParcela
		, PA.ValorDemaisParcelas
		, PRP1.IDAgenciaVenda
		, PRP1.IDFuncionario
		, A.Classifica
		, pf.[Nova Proposta] as NovaProposta
		, pf.Parcelas as NovasParcelas
		, TRY_PARSE(replace(replace(pf.[Valor por Parcela],'.',''),',','.') AS DECIMAL(18,2)) as ValorPorParcela
		, pf.[Codigo de Barras] as CodigoDeBarras--,pf.[Numero Apolice]
		, pf.[Tipo Renovacao] as TipoRenovacao
		, ROW_NUMBER() OVER(PARTITION BY  PRP.IDContrato ORDER BY A.Classifica, PA.DataArquivo DESC) ORDEM
		, ROW_NUMBER() OVER(PARTITION BY  PRP.IDContrato, PRP.IDProposta ORDER BY PA1.DataArquivo ASC) ORDEM1
		, PA2.ValorImportanciaSegurada
		, COALESCE(PA.IDTipoSeguro,PA1.IDTipoSeguro) as IDTipoSeguro
	FROM #PRP_RES PRP	
	
		CROSS APPLY (SELECT TOP 1 DataProposta, RenovacaoAutomatica, DataInicioVigencia, DataFimVigencia, IDProduto, NumeroProposta, IDAgenciaVenda, IDFuncionario
					 FROM Dados.Proposta PRP1
					 WHERE PRP1.ID = PRP.IDProposta
					 AND PRP1.DataProposta IS NOT NULL
					) PRP1
		OUTER APPLY (SELECT TOP 1 DataInicioVigencia, DataFimVigencia, IDProduto, NumeroProposta
					 FROM Dados.Proposta PRP2
					 WHERE PRP2.ID = PRP.IDProposta
					 AND PRP1.DataProposta IS NULL
					) PRP2
		LEFT JOIN Dados.Contrato CNT
		ON CNT.ID = PRP.IDContrato
		LEFT JOIN Dados.PropostaCliente PC
		ON PC.IDProposta = PRP.IDProposta
		LEFT JOIN Dados.ContratoCliente CC
		ON CC.IDContrato = PRP.IDContrato
		inner join #ClienteRESPF pf on pf.CPF = PC.CPFCNPJ and pf.[Numero Apolice] = NumeroContrato COLLATE Latin1_General_CI_AS
		OUTER APPLY (SELECT CASE WHEN RIGHT('00000000000000000000' + CNT.NumeroContrato,16) = RIGHT('00000000000000000000' + COALESCE(PRP2.NumeroProposta, PRP1.NumeroProposta) ,16) THEN 1 ELSE 0 END CLASSIFICA) A
		OUTER APPLY (SELECT TOP 1 NumeroApoliceAnterior, IndicadorRenovacaoAutomatica, ValorPrimeiraParcela, ValorDemaisParcelas, DataArquivo,IDTipoSeguro
		        from Dados.PropostaResidencial PA
				WHERE PRP.IDProposta = PA.IDProposta
				ORDER BY PA.DataArquivo DESC
				) PA
		OUTER APPLY (SELECT TOP 1 NumeroApoliceAnterior, DataArquivo,IDTipoSeguro
		             from Dados.PropostaResidencial PA1
					 WHERE PRP.IDProposta = PA1.IDProposta
					  ORDER BY PA1.DataArquivo ASC
						) PA1		
		LEFT JOIN Dados.Contrato CNTA
		ON CNTA.ID = CNT.IDContratoAnterior
		OUTER APPLY (SELECT TOP 1 * 
					 FROM Dados.PropostaEndereco PE
					 WHERE PE.IDProposta = PRP.IDProposta
					   AND PE.LastValue = 1
					 ORDER BY PE.IDTipoEndereco ASC
					) PE
		OUTER APPLY (SELECT TOP 1 * 
					 FROM Dados.Endosso EN
					 WHERE EN.IDContrato = PRP.IDContrato
					   AND EN.IDProduto IS NOT NULL
					 ORDER BY EN.DataArquivo DESC
					 ) E
		OUTER APPLY (SELECT sum(ValorImportanciaSegurada) as ValorImportanciaSegurada
		             from Dados.PropostaCobertura PA2
					 WHERE PRP.IDProposta = PA2.IDProposta
					 -- ORDER BY PA2.DataArquivo ASC
						) PA2
		LEFT JOIN Dados.Produto PRD
		ON PRD.ID = CASE WHEN (PRP1.IDProduto IS NULL OR PRP1.IDProduto = -1) 
						  and (PRP2.IDProduto IS NULL OR PRP2.IDProduto = -1) THEN E.IDProduto 
						 ELSE 
							 CASE WHEN PRP1.IDProduto IS NOT NULL AND PRP1.IDProduto <> - 1 THEN PRP1.IDProduto 
								  ELSE
									PRP2.IDProduto 
							  END
					END
		LEFT JOIN Dados.ProdutoSIGPF PSG
		ON PSG.ID = PRD.IDProdutoSIGPF
		OUTER APPLY (SELECT SUM(ValorPremioTotal) ValorPremioTotal, SUM(ValorPremioLiquido) ValorPremioLiquido FROM Dados.Endosso EN WHERE EN.IDContrato = PRP.IDContrato AND Arquivo like ('D%[_]PAR%')) EN
		OUTER APPLY (SELECT TOP 1 Apolice_Renovada FROM [Dados].[RenovacaoPatrimonial] RP WHERE RP.Numero_Apolice = CNT.NumeroContrato AND [Apolice_Renovada] IS NOT NULL) RN
	WHERE (StatusPropCan = 0 OR  StatusPropCan IS NULL)
	AND   (StatusParcelaCan = 0 OR StatusParcelaCan IS NULL)
	AND   (StatusEndossoCan = 0 OR StatusEndossoCan IS NULL)
	AND   (StatusContratoCan = 0 OR StatusContratoCan IS NULL)
	--and PRP.IDcontrato = 22130274
	and PSG.CodigoProduto in ('71','72') --and pf.CPF is null
	--and pf.Nome = 'ANDRE LUIZ OLIVEIRA DA SILVA'
	--and PRP.IdProposta = 63581399
	--order by IDProposta
	--select * from #ClienteRESPF
--	AND PRP.IDContrato = 19769433--22395310 --19691146--23015438--19584042
--AND PRP.IDProposta = 66571097

--19985745
--20179033
)
INSERT INTO Stage_SalesForce.Enqueue.[Contract_load_contract_RD] 
(   
   [CPF_CNPJ]
	,[Nome]
	,[FirstName]
	,[LastName]
	,[NumeroContrato]
	,[NumeroApoliceAnterior]
	,[Telefone]
	,[DataProposta]
	,[RenovacaoAutomatica]
	,[CodigoComercializado]
	,[ProdutoComercializado]
	,[CodigoProdutoSIGPF]
	,[ProdutoSIGPF]
	,[DataFimVigencia]
	,[EnderecoLocalRisco]
	,[BairroLocalRisco]
	,[CidadeLocalRisco]
	,[UFLocalRisco]
	,[Pais]
	,[PaisCodigo]
	,[CEP]
	,[Ramo]
	,[IDContrato]
	,[IDProposta]
	,[DataInicioVigencia]
	,[NumeroProposta]
	,[QuantidadeParcelas]
	,[ValorPremioTotal]
	,[ValorPremioLiquido]
	,[ValorDemaisParcelas]
	,[ValorPrimeiraParcela]
	,[CodigoUnidade]
	,[NomeUnidade]
	,[MatriculaIndicador]
	,[NomeIndicador]
	,[CPFIndicador]
	,NovaProposta
	,NovasParcelas
	,ValorPorParcela
	, CodigoDeBarras
	,TipoRenovacao
	,Importancia_Segurada__c
	,RenovacaoAtual__c
)																													
SELECT 																						
   CPF_CNPJ		                                                                                                                                                     
,  CTE.Nome																						 
,  FirstName																					 
,  LastName                                 													
,  CTE.NumeroContrato																				 
,  NumeroApoliceAnterior																		 
,  COALESCE(TelCelular, TelResidencial, TelComercial) Telefone									 
,  DataProposta																					 
,  RenovacaoAutomatica																			 
,  CodigoComercializado																			 
,  [ProdutoComercializado]																		 
,  [CodigoProdutoSIGPF]																			 
,  [ProdutoSIGPF]																				 
,  CTE.DataFimVigencia																				 
,  ISNULL(EnderecoLocalRisco,'')  EnderecoLocalRisco				                             
,  ISNULL(BairroLocalRisco, '') BairroLocalRisco												 
,  CTE.CidadeLocalRisco																				
,  CTE.UFLocalRisco																						
,  'Brazil' Pais																				 
,  'br' PaisCodigo																				 
,  CTE.CEP																						 
, CASE WHEN [CodigoProdutoSIGPF] IN ('10', '71', '72')  THEN 'Residencial'						 
	   WHEN [CodigoProdutoSIGPF] IN ('50', 'MC') THEN 'MR Empresarial'							 
	   ELSE 'NÃO IDENTIFICADO'																	 
  END Ramo																						 
, IDContrato																					 
, CTE.IDProposta																					 
, CTE.DataInicioVigencia																		 
, CTE.NumeroProposta																			 
, CTE.QuantidadeParcelas																		 
, CTE.ValorPremioTotal ValorPremioTotal	 															 
, CTE.ValorPremioLiquido ValorPremioLiquido																			 
, CTE.ValorDemaisParcelas																		 
, CTE.ValorPrimeiraParcela																		 
, U.Codigo CodigoUnidade																		 
, U.Nome NomeUnidade																			 
, ISNULL(RIGHT('00000000' + F.Matricula,8), '')  MatriculaIndicador								
, F.Nome NomeIndicador																			
, F.CPF [CPFIndicador]	
,NovaProposta
	,NovasParcelas
	,ValorPorParcela
	, CodigoDeBarras	
	,TipoRenovacao	
	,ValorImportanciaSegurada	
	,ts.Descricao															
--into Stage_SalesForce.Enqueue.[Contract_load_contract_RES]	
--INTO Stage_SalesForce.Enqueue.[Contract_load_contract_RD]							
FROM CTE	
--LEFT JOIN Dados.Contrato CNT
--ON CNT.ID = CTE.IDContrato
LEFT JOIN Dados.vw_Unidade U
ON U.IDUnidade = CTE.IDAgenciaVenda
LEFT JOIN Dados.Funcionario F
ON F.ID = CTE.IDFuncionario	
LEFT JOIN Dados.TipoSeguro ts on ts.ID = CTE.IDTipoSeguro											
where ORDEM = 1		



--SELECT error,len(N_da_Proposta__C),* FROM [Salesforce Backups].dbo.Opportunity_load_RD_PF



--select * from Stage_SalesForce.Enqueue.[Contract_load_contract_RD] where DataFimVigencia = '2016-09-11'


--S

--SELECT * FROM [Salesforce Backups].dbo.Account_load_cliente_RD_PF 

select *  from #RENOVACAORD rr 
left join  [Salesforce Backups].dbo.Contrato__c_load_RD_PF c on c.NumeroApolice__c = rr.[Numero Apolice] COLLATE SQL_Latin1_General_CP1_CI_AS
where [Data Fim Vigencia]  = '2016-09-05' AND c.NumeroApolice__c is  null and rr.[Numero Apolice] = '1201402764034'


--SELECT * FROM #PRP_RES where IDContrato= 22038844


--SELECT * FROM Corporativo.Dados.Contrato where NumeroContrato = '1201402739795'



--SELECT DISTINCT CNT.ID IDContrato, CNT.IDProposta, CNT.DataFimVigencia,  CASE WHEN cnt.DataCancelamento is not null THEN 1 ELSE 0 END StatusContratoCan, 1 ContratoEndosso
--			FROM Dados.Contrato CNT
--			LEFT JOIN Dados.Endosso EN
--			ON EN.IDContrato = CNT.ID
--			LEFT JOIN Dados.Produto PRD
--			ON PRD.ID = EN.IDProduto
--			LEFT JOIN Dados.ProdutoSIGPF PSIG
--			ON PSIG.ID = PRD.IDProdutoSIGPF
--			WHERE PSIG.CodigoProduto IN  ('71', '72')
--		--	AND CNT.DataFimVigencia >=  '2016-09-04'--GETDATE()
--			AND NumeroContrato = '1201402771439'