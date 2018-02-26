CREATE PROCEDURE [dbo].[proc_RecuperaCarteiraRD]
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

DECLARE @DataIniVig DATE = '2017-01-01'
DECLARE @DataFimVig DATE = '2017-12-31'

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
			WHERE PSIG.CodigoProduto IN  ('71', '72', '10', '50', 'MC')
			--AND CNT.DataInicioVigencia >= DATEADD(M,-4,GETDATE())
				--AND CNT.DataFimVigencia BETWEEN @DataIniVig AND @DataFimVig
) AS S 
ON  T.IDContrato = S.IDContrato -- -ISNULL(T.IDContrato,-1) = ISNULL(S.IDContrato,-1)
AND T.IDProposta >= 0 --= S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, ContratoEndosso,  StatusContratoCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.ContratoEndosso, StatusContratoCan);


------Encontra contratos POR vigencia  pela proposta e prod.SIGPF
;MERGE INTO #PRP_RES T
USING
(
SELECT PRP.ID IDProposta, PRP.IDContrato, CASE WHEN PRP.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaSIGPF
FROM Dados.Proposta PRP
INNER JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF
WHERE (PSG.CodigoProduto IN  ('71', '72', '10', '50', 'MC')
	   --AND PRP.DataFimVigencia >= GETDATE()
	   --AND PRP.DataInicioVigencia> DATEADD(M,-4,GETDATE())
	   --AND PRP.DataFimVigencia BETWEEN @DataIniVig AND @DataFimVig
	  )  
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
WHERE (PSG.CodigoProduto IN  ('71', '72', '10', '50', 'MC')
	   --AND PRP.DataFimVigencia >= GETDATE()
	   --AND PRP.DataInicioVigencia> DATEADD(M,-4,GETDATE())
	   --AND PRP.DataFimVigencia BETWEEN @DataIniVig AND @DataFimVig
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
(
SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaRES
FROM Dados.Proposta PRP1
INNER JOIN Dados.PropostaResidencial PA
ON PA.IDProposta = PRP1.ID
--WHERE  --PRP1.DataFimVigencia >= GETDATE()
		--PRP1.DataFimVigencia BETWEEN @DataIniVig AND @DataFimVig
		--PRP1.DataInicioVigencia> DATEADD(M,-4,GETDATE())
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
(
SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaRES
FROM Dados.Proposta PRP1
INNER JOIN Dados.PropostaResidencial PA
ON PA.IDProposta = PRP1.ID
--WHERE  --PRP1.DataFimVigencia >= GETDATE()
		--PRP1.DataInicioVigencia> DATEADD(M,-4,GETDATE())	
	--	PRP1.DataFimVigencia BETWEEN @DataIniVig AND @DataFimVig
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


--IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like '%#ClienteRESPF%')-- OBJECT_ID = OBJECT_ID('dbo.#ClienteRESPF'))
--  DROP TABLE #ClienteRESPF;
------------------------------------------------
-- Dados do contrato RES - Conta
------------------------------------------------
---if exists DROP #ClienteRESPF
;
with cte
as
(
SELECT 
DISTINCT
--prp.idproposta
  COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) CPF
, CleansingKit.dbo.fn_getFirstName(COALESCE(PC.Nome, CC.NomeCliente)) FirstName
, CleansingKit.dbo.fn_getLastName(COALESCE(PC.Nome, CC.NomeCliente)) LastName
, COALESCE(PC.Nome, CC.NomeCliente) Nome
, PC.DataNascimento
, PE.Bairro
, PE.Cidade
, PE.Endereco
, PE.UF
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDCelular, PC.TelefoneCelular)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelCelular
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDResidencial, PC.TelefoneResidencial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelResidencial
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDComercial, PC.TelefoneComercial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelComercial
,S.Descricao Sexo
,EC.Descricao EstadoCivil
,PE.CEP
,PC.Email
,PC.Emailcomercial
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
WHERE (StatusPropCan = 0 OR  StatusPropCan IS NULL)
AND   (StatusParcelaCan = 0 OR StatusParcelaCan IS NULL)
AND   (StatusEndossoCan = 0 OR StatusEndossoCan IS NULL)
AND   (StatusContratoCan = 0 OR StatusContratoCan IS NULL)

)
SELECT *--count(distinct IDContrato)
INTO #ClienteRESPF
FROM CTE
--where not exists (select * from cte cte1
--				 where cte1.IDProposta = cte.IDProposta
--				 and cte1.ORDEM > 1)
where ORDEM = 1--  cte.idproposta is null
--ORDER BY cte.IDContrato--, ORDEM
--SELECT @@TRANCOUNT
--COMMIT
--begin tran


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
--;
--MERGE INTO 
-- Stage_SalesForce.Enqueue.account_load_cliente_RD T
--USING (
--		SELECT *--, CASE WHEN CPF LIKE '%/%' THEN '0121a0000006O7BAAU' ELSE '0121a0000006O8dAAE' END RecordTypeId
--		FROM #ClienteRESPF
--	  ) S
--ON  --S.RecordTypeId = T.RecordTypeId
----AND 
--S.CPF COLLATE SQL_Latin1_General_CP1_CI_AS = T.CPF_CNPJ__c
--WHEN NOT MATCHED THEN
--INSERT (--RecordTypeId, 
--        CPF_CNPJ__c, FirstName, LastName, Name, DataNascimento__c,  Bairro__c, Cidade__c, Endereco__c, UF__c, CEP,  Phone, Sexo, MobilePhone, EstadoCivil)--, CreatedDate, id) 
--VALUES (--S.RecordTypeId,
--        S.CPF, FirstName, LastName, s.Nome, S.DataNascimento, S.Bairro, S.Cidade, S.Endereco, S.UF, S.CEP,
--	    COALESCE(TelResidencial, TelComercial,TelCelular), S.Sexo, CASE WHEN S.TelCelular IS NULL THEN CASE WHEN RIGHT(LEFT(COALESCE(TelResidencial, TelComercial,TelCelular),3),1) IN ('7','8','9') THEN COALESCE(TelResidencial, TelComercial,TelCelular) ELSE S.TelCelular END END, S.EstadoCivil);
SELECT Celular,CPFCNPJ,Fixo into #contatopessoa FROM Dados.vw_ContatoPessoa AS C WHERE Celular IS NOT NULL OR Fixo IS NOT NULL
create clustered index cl_idx_contatopessoa_temp on #contatopessoa(CPFCNPJ)

MERGE INTO 
 Stage_SalesForce.Enqueue.account_load_cliente_RD T
USING (
		SELECT CPF, Nome, DataNascimento, CP.Celular AS TelCelular, TelResidencial, TelComercial, Email, EmailComercial, Endereco, Cidade, Bairro, CEP, UF, Sexo, EstadoCivil, Ordem,cp.Fixo
		FROM #ClienteRESPF AS A
		--OUTER APPLY (SELECT Celular FROM Dados.vw_ContatoPessoa AS C WHERE Celular IS NOT NULL OR Fixo IS NOT NULL AND C.CPFCNPJ=A.CPF) AS CP
		OUTER APPLY (SELECT Celular,Fixo FROM #contatopessoa AS C WHERE C.CPFCNPJ=A.CPF) AS CP
	  ) S
ON  --S.RecordTypeId = T.RecordTypeId
--AND 
S.CPF COLLATE SQL_Latin1_General_CP1_CI_AS = T.CPF_CNPJ__c
WHEN NOT MATCHED THEN
INSERT (--RecordTypeId, 
        CPF_CNPJ__c
		, FirstName
		, LastName
		, Name
		, DataNascimento__c
		, DevLocale_SFMC__c
		, Email
		, CEP
		, Bairro__c
		, Cidade__c
		, Endereco__c
		, UF__c
		, Phone
		, Sexo
		, MobilePhone   ----
		, EstadoCivil
		)--, CreatedDate, id) 
VALUES (--S.RecordTypeId,
        S.CPF
		, CleansingKit.dbo.fn_getFirstName(s.Nome)
		, CleansingKit.dbo.fn_getLastName(S.Nome)
		, s.Nome
		, S.DataNascimento
		, 'br'
		, COALESCE(S.Email, S.EmailComercial)
		, S.CEP
        , S.Bairro
		, S.Cidade
		, S.Endereco
		, S.UF
		, COALESCE(Fixo, TelResidencial, TelComercial,TelCelular)
		, S.Sexo
		, S.TelCelular
		, S.EstadoCivil
		);--, getdate(),  RIGHT(REPLACE(NEWID(), '-',''),18));

------------------------------------------------
-- Dados do contrato RES - Contrato
------------------------------------------------
truncate table Stage_SalesForce.Enqueue.[Contract_load_contract_RD]

;
with cte
as
(
	SELECT 
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
		, dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDCelular, PC.TelefoneCelular)) TelCelular
		, dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDResidencial, PC.TelefoneResidencial)) TelResidencial
		, dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDComercial, PC.TelefoneComercial)) TelComercial
		, COALESCE(PRP1.DataInicioVigencia, CNT.DataInicioVigencia, PRP2.DataInicioVigencia) DataInicioVigencia
		, COALESCE(CNT.DataFimVigencia, PRP1.DataFimVigencia, PRP2.DataFimVigencia) DataFimVigencia
		, COALESCE(RN.Apolice_Renovada, CNTA.NumeroContrato, PA1.NumeroApoliceAnterior) NumeroApoliceAnterior
		, CASE WHEN CNT.EnderecoLocalRisco IS NOT NULL THEN CNT.EnderecoLocalRisco ELSE COALESCE(CC.Endereco, PE.Endereco) END EnderecoLocalRisco 
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
		, '0121a0000006OH5AAM' AS RecordTypeID
		, A.Classifica
		, ROW_NUMBER() OVER(PARTITION BY  PRP.IDContrato ORDER BY A.Classifica, PA.DataArquivo DESC) ORDEM
		, ROW_NUMBER() OVER(PARTITION BY  PRP.IDContrato, PRP.IDProposta ORDER BY PA1.DataArquivo ASC) ORDEM1
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
		OUTER APPLY (SELECT CASE WHEN RIGHT('00000000000000000000' + CNT.NumeroContrato,16) = RIGHT('00000000000000000000' + COALESCE(PRP2.NumeroProposta, PRP1.NumeroProposta) ,16) THEN 1 ELSE 0 END CLASSIFICA) A
		OUTER APPLY (SELECT TOP 1 NumeroApoliceAnterior, IndicadorRenovacaoAutomatica, ValorPrimeiraParcela, ValorDemaisParcelas, DataArquivo
		        from Dados.PropostaResidencial PA
				WHERE PRP.IDProposta = PA.IDProposta
				ORDER BY PA.DataArquivo DESC
				) PA
		OUTER APPLY (SELECT TOP 1 NumeroApoliceAnterior, DataArquivo
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
	
--	AND PRP.IDContrato = 19769433--22395310 --19691146--23015438--19584042
--AND PRP.IDProposta = 66571097

--19985745
--20179033
--select  * from  Stage_SalesForce.Enqueue.[Contract_load_contract_RD]
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
	,RecordTypeId
)																													
SELECT DISTINCT																			
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
, CTE.RecordTypeID																		
--into Stage_SalesForce.Enqueue.[Contract_load_contract_RES]	
--INTO Stage_SalesForce.Enqueue.[Contract_load_contract_RD]							
FROM CTE	
LEFT JOIN [SALESFORCE BACKUPS].dbo.Opportunity op
ON op.NumeroApolice__c = cte.NumeroContrato COLLATE SQL_Latin1_General_CP1_CI_AS
--LEFT JOIN Dados.Contrato CNT
--ON CNT.ID = CTE.IDContrato
LEFT JOIN Dados.vw_Unidade U
ON U.IDUnidade = CTE.IDAgenciaVenda
LEFT JOIN Dados.Funcionario F
ON F.ID = CTE.IDFuncionario												
where ORDEM = 1 and op.Dev_Origem_Integracao__c   IS NULL		

--select * from controledados.logdmdb13