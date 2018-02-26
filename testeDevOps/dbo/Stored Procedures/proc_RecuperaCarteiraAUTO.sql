
CREATE PROCEDURE [dbo].[proc_RecuperaCarteiraAUTO]
as 
--drop table #PRP_AUTO


declare @RowVersionContrato bigint
declare @RowVersionEndosso bigint
declare @RowVersionProposta bigint

SELECT @RowVersionContrato =  CAST(PontoParada as bigint) FROM  ControleDados.PontoParada  where NomeEntidade = 'RowVersionContrato'
SELECT @RowVersionProposta =  CAST(PontoParada as bigint) FROM  ControleDados.PontoParada  where NomeEntidade = 'RowVersionProposta'
SELECT @RowVersionEndosso =   CAST(PontoParada as bigint) FROM  ControleDados.PontoParada  where NomeEntidade = 'RowVersionEndosso'

create table #PRP_AUTO
(IDProposta BIGINT DEFAULT(0)
,IDContrato BIGINT DEFAULT(0)
,ContratoEndosso bit default(0)
,PropostaSIGPF bit default(0)
,PropostaAUTO bit default(0)
,StatusParcelaCan bit default(0)
,StatusPropCan bit default(0)
,StatusContratoCan bit default(0)
,StatusEndossoCan bit default(0)
,RowVersionProposta bigint
,RowVersionContrato bigint
,RowVersionEndosso bigint
)

CREATE CLUSTERED INDEX IDX_CL_IDContrato_IDProposta ON #PRP_AUTO (IDContrato, IDProposta);
------Encontra contratos POR vigencia  pelo contrato
;MERGE INTO #PRP_AUTO T
USING
(
	SELECT DISTINCT CNT.ID IDContrato, CNT.IDProposta, CNT.DataFimVigencia,  CASE WHEN cnt.DataCancelamento is not null THEN 1 ELSE 0 END StatusContratoCan, 1 ContratoEndosso,CNT.[RowVersion] as RowVersionContrato,EN.[RowVersion] as RowVersionEndosso
			FROM Dados.Contrato CNT
			INNER JOIN Dados.Endosso EN
			ON EN.IDContrato = CNT.ID
			INNER JOIN Dados.Produto PRD
			ON PRD.ID = EN.IDProduto
			LEFT JOIN Dados.ProdutoSIGPF PSIG
			ON PSIG.ID = PRD.IDProdutoSIGPF
			WHERE PSIG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49') 
			AND CNT.DataFimVigencia >= GETDATE() --'2016-07-30' alterada por pedro
			--AND CNT.[RowVersion] >  @RowVersionContrato


) AS S
ON  T.IDContrato = S.IDContrato -- -ISNULL(T.IDContrato,-1) = ISNULL(S.IDContrato,-1)
AND T.IDProposta >= 0 --= S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, ContratoEndosso,  StatusContratoCan,RowVersionContrato,RowVersionEndosso) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.ContratoEndosso, StatusContratoCan,RowVersionContrato,RowVersionEndosso);

--select *
--from #PRP_AUTO
--WHERE IDContrato = 6649861


------Encontra contratos POR vigencia  pela proposta e prod.SIGPF
;MERGE INTO #PRP_AUTO T
USING
(
SELECT PRP.ID IDProposta, PRP.IDContrato, CASE WHEN PRP.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaSIGPF,PRP.[RowVersion] as RowVersionProposta
FROM Dados.Proposta PRP
INNER JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF
WHERE (PSG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')
	   AND PRP.DataFimVigencia >= GETDATE()
	  )
--AND PRP.[RowVersion] > @RowVersionProposta

) AS S
ON  T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
--AND ISNULL(T.IDProposta,S.IDProposta) = ISNULL(S.IDProposta,T.IDProposta)
AND T.IDProposta >= 0
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaSIGPF, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaSIGPF, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaSIGPF = S.PropostaSIGPF
		 --, IDContrato = COALESCE(T.IDContrato, S.IDContrato),
		 , IDProposta = CASE WHEN T.IDProposta = 0 THEN S.IDProposta ELSE T.IDProposta END
		 --, [RowVersionProposta] = S.[RowVersionProposta]
		 ;

;MERGE INTO #PRP_AUTO T
USING
(
SELECT PRP.ID IDProposta, PRP.IDContrato, CASE WHEN PRP.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaSIGPF,PRP.[RowVersion] as RowVersionProposta
FROM Dados.Proposta PRP
INNER JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF
WHERE (PSG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')
	   AND PRP.DataFimVigencia >= GETDATE()
	  )
	  --AND PRP.[RowVersion] > @RowVersionProposta
	--  and prp.idcontrato = 			 6649861

) AS S
ON  --T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
   T.IDContrato >= 0
AND T.IDProposta = S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaSIGPF, StatusPropCan,RowVersionProposta) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaSIGPF, StatusPropCan,S.RowVersionProposta)
WHEN MATCHED THEN
UPDATE SET PropostaSIGPF = S.PropostaSIGPF
		 , IDContrato = CASE WHEN T.IDContrato = 0 THEN S.IDContrato ELSE T.IDContrato END
		 , [RowVersionProposta] = S.[RowVersionProposta]
		 ;
		 --, IDProposta = COALESCE(T.IDProposta, S.IDProposta);
--SELECT * FROM Dados.SituacaoProposta

------Encontra contratos POR vigencia pela proposta e proposta AUTO
;MERGE INTO #PRP_AUTO T
USING
(
SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaAUTO,[RowVersion] as RowVersionProposta
FROM Dados.Proposta PRP1
INNER JOIN Dados.PropostaAutomovel PA
ON PA.IDProposta = PRP1.ID
WHERE  PRP1.DataFimVigencia >= GETDATE()
--AND PRP1.[RowVersion] > @RowVersionProposta
) AS S
ON  T.IDContrato = S.IDContrato --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
--AND ISNULL(T.IDProposta,S.IDProposta) = ISNULL(S.IDProposta,T.IDProposta)
AND T.IDProposta >= 0
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaAUTO, StatusPropCan,RowVersionProposta) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaAUTO, StatusPropCan,RowVersionProposta)
WHEN MATCHED THEN
UPDATE SET PropostaAUTO = S.PropostaAUTO
         , StatusPropCan =S.StatusPropCan
		 --, IDContrato = COALESCE(T.IDContrato, S.IDContrato),
		 , IDProposta = CASE WHEN T.IDProposta = 0 THEN S.IDProposta ELSE T.IDProposta END
		 --, RowVersionProposta = S.RowVersionProposta
		 ;


------Encontra contratos POR vigencia pela proposta e proposta AUTO
;MERGE INTO #PRP_AUTO T
USING
(
SELECT DISTINCT PRP1.ID IDProposta, PRP1.IDContrato, CASE WHEN PRP1.IDSituacaoProposta in (3, 5) THEN 1 ELSE 0 END StatusPropCan, 1 PropostaAUTO,PRP1.[RowVersion] as RowVersionProposta
FROM Dados.Proposta PRP1
INNER JOIN Dados.PropostaAutomovel PA
ON PA.IDProposta = PRP1.ID
WHERE  PRP1.DataFimVigencia >= GETDATE()
--AND PRP1.[RowVersion] > @RowVersionProposta
) AS S
ON   --ISNULL(T.IDContrato,S.IDContrato) = ISNULL(S.IDContrato,T.IDContrato)
 T.IDContrato >= 0
AND  T.IDProposta = S.IDProposta
WHEN NOT MATCHED THEN
INSERT (IDProposta, IDContrato, PropostaAUTO, StatusPropCan) VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), S.PropostaAUTO, StatusPropCan)
WHEN MATCHED THEN
UPDATE SET PropostaAUTO = S.PropostaAUTO
         , StatusPropCan =S.StatusPropCan
		 , IDContrato = CASE WHEN T.IDContrato = 0 THEN S.IDContrato ELSE T.IDContrato END
		 --, RowVersionProposta = S.RowVersionProposta
		 ;
		 --, IDProposta = COALESCE(T.IDProposta, S.IDProposta);
------------------------------------------------

------Encontra contratos cancelados pela parcela
;
WITH CTE
AS
(
	SELECT  IDContrato,[RowVersion] as RowVersionEndosso--, IDProposta
	FROM Dados.Endosso en --WHERE IDCONTRATO = 24684982
	inner join dados.Parcela p
	on p.IDEndosso = en.id
	WHERE EN.Arquivo LIKE '%AU00%'
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
	            FROM #PRP_AUTO P
				WHERE P.IDContrato = EN.IDContrato)
	--AND en.[Rowversion] > @RowVersionEndosso
)
UPDATE #PRP_AUTO SET StatusParcelaCan = 1,RowVersionEndosso = CTE.RowVersionEndosso
FROM CTE 
INNER JOIN #PRP_AUTO P
ON P.IDContrato = CTE.IDContrato
;

--SELECT * fROM #PRP_AUTO WHERE IDPROPOSTA = 73166639

IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like '%#ClienteAUTOPF')-- OBJECT_ID = OBJECT_ID('dbo.#ClienteAUTOPF'))
  DROP TABLE #ClienteAUTOPF;
------------------------------------------------
-- Dados do contrato AUTO - Conta 
------------------------------------------------
---if exists DROP #ClienteAUTOPF
;
with cte
as
(
SELECT 
DISTINCT                                                                                                                       
--prp.idproposta																												
  COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) CPF																							
, [dbo].[InitCap](COALESCE(PC.Nome, CC.NomeCliente)) Nome																		
, PC.DataNascimento																												
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDCelular, PC.TelefoneCelular)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelCelular
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDResidencial, PC.TelefoneResidencial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelResidencial
, COALESCE(dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(PC.DDDComercial, PC.TelefoneComercial)), dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(CC.DDD, CC.Telefone))) TelComercial			
, PC.Email																														
, PC.Emailcomercial																												
, PE.Endereco																													
, PE.Cidade																														
, PE.Bairro																														
, PE.CEP																														
, PE.UF
, S.Descricao Sexo
, EC.Descricao EstadoCivil
, ROW_NUMBER() OVER(PARTITION BY COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) ORDER BY PE.IDTipoEndereco) ORDEM
FROM #PRP_AUTO PRP
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
INTO #ClienteAUTOPF
FROM CTE
--where not exists (select * from cte cte1
--				 where cte1.IDProposta = cte.IDProposta
--				 and cte1.ORDEM > 1)
where ORDEM = 1--  cte.idproposta is null
--ORDER BY cte.IDContrato--, ORDEM
--SELECT @@TRANCOUNT
--COMMIT
--begin tran
--SELECT * FROM Stage_SalesForce.Enqueue.account_load_cliente_AUTO WHERE CPF_CNPJ__c = '035.870.871-05'

truncate table Stage_SalesForce.Enqueue.account_load_cliente_AUTO
;

SELECT Celular,CPFCNPJ,Fixo into #contatopessoa FROM Dados.vw_ContatoPessoa AS C WHERE Celular IS NOT NULL OR Fixo IS NOT NULL
create clustered index cl_idx_contatopessoa_temp on #contatopessoa(CPFCNPJ)

MERGE INTO 
 Stage_SalesForce.Enqueue.account_load_cliente_AUTO T
USING (
		SELECT CPF, Nome, DataNascimento, CP.Celular AS TelCelular, TelResidencial, TelComercial, Email, EmailComercial, Endereco, Cidade, Bairro, CEP, UF, Sexo, EstadoCivil, Ordem,cp.Fixo
		FROM #ClienteAUTOPF AS A
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



--SELECT TOP 100  RecordTypeId, CPF_CNPJ__c, FirstName, LastName, Name, DataNascimento__c, DevLocale_SFMC__c, Bairro__c, Cidade__c, Endereco__c, UF__c, Phone--DISTINCT RecordTypeId, A.RECO-- *--[CPF_CNPJ__c], FirstName, LastName--*
--INTO Stage_SalesForce.Enqueue.account_load_cliente_AUTO
--FROM [SALESFORCE BACKUPS].DBO.Account A
--where RecordTypeId = '0121a000000AOBdAAO'

--drop
--truncate  table Stage_SalesForce.Enqueue.account_load_cliente_AUTO
------------------------------------------------
-- Dados do contrato AUTO - Contrato
------------------------------------------------
--select * from  Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] where CPF_CNPJ__c = '035.870.871-05'
TRUNCATE TABLE Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] 
--select * from #PRP_AUTO inner join dados.Contrato on IDContrato = id where NumeroContrato = '1103100833044'
--select * from dados.endosso where IDContrato = 24767905 or IDProposta = 69539872
;
with cte
as
(
SELECT 
  PRP.IDContrato 
, PRP.ContratoEndosso 
, PRP.PropostaSIGPF 
, PRP.PropostaAUTO 
, PRP.StatusParcelaCan 
, PRP.StatusPropCan 
, PRP.StatusContratoCan 
, PRP.StatusEndossoCan 
, V.Nome Veiculo
, pa1.Chassis
, PA1.Placa
, PA1.AnoModelo
, PA1.AnoFabricacao
, PRP1.DataProposta
, PRP1.NumeroProposta
, PA1.DataInicioVigencia
, PA1.DataFimVigencia
, PA1.NumeroApoliceAnterior
, PA1.CodigoSeguradora
, PRD.CodigoComercializado
, prd.Descricao [ProdutoComercializado]
--, EN.QuantidadeParcelas
, EN.ValorPremioTotal
, EN.ValorPremioLiquido
, PRP1.IDFuncionario
, PRP1.IDAgenciaVenda
, COALESCE(PC.CPFCNPJ, CC.CPFCNPJ) CPF
, [dbo].[InitCap](COALESCE(PC.Nome, CC.NomeCliente)) Nome
, COALESCE(SAU.CodFipe_Fabricante,SIM.CodFipe_Fabricante) AS CodFipe_Fabricante
, COALESCE(SAU.CodFipe_Modelo,SIM.CodFipe_Modelo) AS CodFipe_Modelo
, COALESCE(SAU.IDTipoSeguro,SIM.IDTipoSeguro) AS IDTipoSeguro
, COALESCE(SAU.IDFormaPagtoParcela1,SIM.IDFormaPagtoParcela1) AS IDFormaPagtoParcela1
, tc.Descricao as Tipo_cliente_Simulador
--, SAU.ID
--,PRP1.NumeroProposta
, COALESCE(PC.DataNascimento, Cast('1900-01-01' as Date)) DataNascimento
, ROW_NUMBER() OVER(PARTITION BY  PRP.IDProposta ORDER BY PA.DataArquivo DESC) ORDEM
, ROW_NUMBER() OVER(PARTITION BY  PRP.IDProposta ORDER BY PA1.DataArquivo ASC) ORDEM1
FROM #PRP_AUTO PRP
LEFT JOIN Dados.Proposta PRP1
ON PRP1.ID = PRP.IDProposta
LEFT JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.IDProposta
LEFT JOIN Dados.ContratoCliente CC
ON CC.IDContrato = PRP.IDContrato
LEFT JOIN Dados.PropostaAutomovel PA
ON PRP.IDProposta = PA.IDProposta
LEFT JOIN Dados.PropostaAutomovel PA1
ON PRP.IDProposta = PA1.IDProposta
LEFT JOIN Dados.Veiculo V
ON V.ID = PA1.IDVeiculo
left join Dados.SimuladorAuto SAU
ON SAU.IDProposta = coalesce(PA1.IDProposta,PA.IDProposta) --and SAU.CodigoFipe IS NOT NULL--and PA.LastValue = 1
LEFT JOIN Dados.TipoCliente tc on SAU.IDTipoCliente = tc.ID
OUTER APPLY (SELECT TOP 1 CodFipe_Fabricante,CodFipe_Modelo,IDTipoSeguro,IDFormaPagtoParcela1 FROM Dados.SimuladorAuto AS SA WHERE SA.CPFCNPJ=PC.CPFCNPJ ORDER BY ID DESC) AS SIM
OUTER APPLY (SELECT IDProduto FROM Dados.Endosso E WHERE E.IDContrato = PRP.IDContrato and IDProduto is not null and IDProduto <> -1) PRD1
OUTER APPLY (SELECT IDProduto FROM Dados.Proposta PRP1 WHERE PRP1.ID = PRP.IDProposta) PRD2
LEFT JOIN Dados.Produto PRD
ON PRD.ID =	CASE WHEN PRD1.IDProduto IS NOT NULL AND PRD1.IDProduto <> - 1 THEN PRD1.IDProduto 
			ELSE
			  PRD2.IDProduto 						
			END
OUTER APPLY (SELECT SUM(ValorPremioTotal) ValorPremioTotal, SUM(ValorPremioLiquido) ValorPremioLiquido FROM Dados.Endosso EN WHERE EN.IDContrato = PRP.IDContrato AND Arquivo like '%AU0009B%') EN
--OUTER APPLY (SELECT SUM(P.ValorPremioLiquido) ValorPremioLiquido, COUNT(*) QtdParcelas
--		     FROM Dados.Endosso EN
--			 INNER JOIN Dados.Parcela P
--			 ON P.IDEndosso = EN.ID
--		     INNER JOIN Dados.ParcelaOperacao PO
--			 ON po.id = p.IDParcelaOperacao
--			 WHERE EN.IDContrato = PRP.IDContrato
--				AND  PO.Descricao = 'GERADO PELA EMISSAO'
--		    ) EN
WHERE (StatusPropCan = 0 OR  StatusPropCan IS NULL)
AND   (StatusParcelaCan = 0 OR StatusParcelaCan IS NULL)
AND   (StatusEndossoCan = 0 OR StatusEndossoCan IS NULL)
AND   (StatusContratoCan = 0 OR StatusContratoCan IS NULL)

--AND COALESCE(PC.CPFCNPJ, CC.CPFCNPJ)  = '035.870.871-05'
)

--SELECT NULL AccountId							 
--	 , CTE.CPF
--     , AnoModelo [DevAnoModeloVeiculo__c]
--	 , COALESCE(case when AnoFabricacao = 0 then null else AnoFabricacao End,AnoModelo) [DevAnoFabricacaoVeiculo__c]
--     , CTE.DataFimVigencia [DevDataVencimento__c]
--	 , NULL [DevDiasParaVencer__c]
--	 , NULL [DevElegivelRA__c]
--	 , Veiculo [DevModeloVeiculo__c]
--	 , CNT.NumeroContrato [DevNumeroApolice__c]
--	 , Placa [DevPlacaVeiculo__c]
--	 , 'AUTO' [DevProduto__c]
--	 , 'Brazil'[BillingCountry] 
--	 , 'BR' [BillingCountryCode] 
--	 , NumeroApoliceAnterior
--	 , CodigoSeguradora
--	 , DataProposta
--	 , CodigoComercializado
--	 , ProdutoComercializado
--	 , Chassis
--	 , CTE.DataInicioVigencia
--	 , NumeroProposta
--	 , COALESCE(CNT.QuantidadeParcelas,1) QuantidadeParcelas
--	 , COALESCE(CTE.ValorPremioLiquido, CNT.ValorPremioLiquido) ValorPremioLiquido
--	 , COALESCE(CTE.ValorPremioTotal, CNT.ValorPremioTotal) ValorPremioTotal
--	 , U.Codigo CodigoUnidade
--	 , U.Nome NomeUnidade
--	 , RIGHT('00000000' + ISNULL(F.Matricula,''),8) MatriculaIndicador
--	 , F.Nome NomeIndicador
--	 , F.CPF [CPFIndicador]
--	 , MAR.Id
--	 , MODE.Id
--	 , ANO.Id
--	 ,ORDEM1
--	 --,CodFipe_Fabricante
--	 --,CodFipe_Modelo
--	 --,CTE.ID
--	 -- ,CodFipe_Fabricante
--	 --,CodFipe_Modelo
--	 --,CTE.ID
--	,IDFormaPagtoParcela1
--	 --count(distinct IDContrato)
	 
--FROM CTE
--LEFT JOIN Dados.vw_Unidade U
--ON U.IDUnidade = CTE.IDAgenciaVenda
--LEFT JOIN Dados.Funcionario F
--ON F.ID = CTE.IDFuncionario
--LEFT JOIN Dados.Contrato CNT
--ON CTE.IDContrato = CNT.ID
--LEFT JOIN [SALESFORCE BACKUPS].dbo.Marca__c MAR
--ON MAR.Codigo_da_Marca__c = CTE.CodFipe_Fabricante
--LEFT JOIN [SALESFORCE BACKUPS].dbo.Modelo__c MODE
--ON MODE.Codigo_do_Modelo__c = CTE.CodFipe_Modelo AND MODE.Marca__c = MAR.Id
--LEFT JOIN [SALESFORCE BACKUPS].dbo.Ano_Modelo_de_Veiculo__c ANO
--ON ANO.Modelo__c = MODE.Id and ANO.Name = COALESCE(CTE.AnoModelo,CTE.AnoFabricacao)

----where not exists (select * from cte cte1
----				 where cte1.IDProposta = cte.IDProposta
----				 and cte1.ORDEM1 > 1)
--where ORDEM1 = 1
----and CTE.CPF = '645.889.809-63'

--select * from Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] where CPF_CNPJ__c = '035.870.871-05'
--select * 
--from Dados.Proposta p 
--inner join Dados.PropostaCliente pc on pc.IDProposta= p.ID
--where pc.cpfcnpj = '035.870.871-05'
INSERT INTO Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] 
(      AccountId
     , CPF_CNPJ__c                              
     , [DevAnoModeloVeiculo__c]					
	 , [DevAnoFabricacaoVeiculo__c]				
     , [DevDataVencimento__c]					
	 , [DevDiasParaVencer__c]					
	 , [DevElegivelRA__c]						
	 , [DevModeloVeiculo__c]					
	 , [DevNumeroApolice__c]					
	 , [DevPlacaVeiculo__c]						
	 , [DevProduto__c]							
	 , [BillingCountry] 						
	 , [BillingCountryCode] 					
	 , [NumeroApoliceAnterior__c]				
	 , CodigoSeguradoraAnterior					
	 , DataProposta								
	 , CodigoComercializado						
	 , ProdutoComercializado					
	 , Chassi__c								
	 , DataInicioVigencia                       
	 , NumeroProposta                           
	 , Parcelas__c								
	 , Premio_liquido__c						
	 , Premio__c	
	 , CodigoUnidade
	 , NomeUnidade
	 , MatriculaIndicador
	 , NomeIndicador
	 , CPFIndicador		
	 ,Tipo_de_seguro__c
	, Renovacao__c
	, MarcaVeiculo__c
	, ModeloVeiculo__c
	, Ano_Modelo_de_Veiculo__c
	, Numero_da_proposta__c
	, StatusContrato__c
	, Forma_de_pagamento__c
	, Tipo_cliente_Simulador 
	,Marca__c
	,DataEmissao
	,Tipo_de_Veiculo__c
)												   
SELECT NULL AccountId							 
	 , CTE.CPF
     , AnoModelo [DevAnoModeloVeiculo__c]
	 , COALESCE( CASE WHEN AnoFabricacao = 0 THEN NULL ELSE  AnoFabricacao END,AnoModelo) [DevAnoFabricacaoVeiculo__c]
     , COALESCE(CTE.DataFimVigencia, CNT.DataFimVigencia) AS [DevDataVencimento__c]
	 , NULL [DevDiasParaVencer__c]
	 , NULL [DevElegivelRA__c]
	 , Veiculo [DevModeloVeiculo__c]
	 , CNT.NumeroContrato [DevNumeroApolice__c]
	 , Placa [DevPlacaVeiculo__c]
	 , 'AUTO' [DevProduto__c]
	 , 'Brazil'[BillingCountry] 
	 , 'BR' [BillingCountryCode] 
	 , NumeroApoliceAnterior
	 , CodigoSeguradora
	 , DataProposta
	 , CodigoComercializado
	 , ProdutoComercializado
	 , Chassis
	 , COALESCE(CTE.DataInicioVigencia, CNT.DataInicioVigencia) AS DataInicioVigencia
	 , NumeroProposta
	 , COALESCE(CNT.QuantidadeParcelas,1) QuantidadeParcelas
	 , COALESCE(CTE.ValorPremioLiquido, CNT.ValorPremioLiquido) ValorPremioLiquido
	 , COALESCE(CTE.ValorPremioTotal, CNT.ValorPremioTotal) ValorPremioTotal
	 , U.Codigo CodigoUnidade
	 , U.Nome NomeUnidade
	 , RIGHT('00000000' + ISNULL(F.Matricula,''),8) MatriculaIndicador
	 , F.Nome NomeIndicador
	 , F.CPF [CPFIndicador]
	 --, MAR.Id
	 --, MODE.Id
	 --, ANO.Id
	 ,CASE WHEN IDTipoSeguro in (0,1) then 'Novo' Else 'Renovação' end as Tipo_de_seguro__c
	 ,CASE WHEN IDTipoSEguro = 22 then 'Automática' 
			WHEN IDTipoSeguro = 19 then 'Congênere'
			WHEN IDTipoSeguro NOT IN (0,1,22,19) THEN 'Manual'
			Else ''
		END AS Renovacao__c
	, MAR.Id as MarcaVeiculo__c
	, MODE.Id as ModeloVeiculo__c
	, ANO.Id as Ano_Modelo_de_Veiculo__c
	, NumeroProposta as Numero_da_proposta__c
	, 'Ativo' as StatusContrato__c
	--, Indicador__c
	, CASE WHEN IDFormaPagtoParcela1 = 99 THEN 'Débito'
	Else 'Boleto'End Forma_de_pagamento__c
	,Tipo_cliente_Simulador
	, MAR.Name as Marca__c
	, CNT.DataEmissao
	,MAR.Tipo_de_Veiculo__c
	 --count(distinct IDContrato)
FROM CTE
LEFT JOIN Dados.vw_Unidade U
ON U.IDUnidade = CTE.IDAgenciaVenda
LEFT JOIN Dados.Funcionario F
ON F.ID = CTE.IDFuncionario
LEFT JOIN Dados.Contrato CNT
ON CTE.IDContrato = CNT.ID
LEFT JOIN [SALESFORCE BACKUPS].dbo.Marca__c MAR
ON MAR.Codigo_da_Marca__c = CTE.CodFipe_Fabricante
LEFT JOIN [SALESFORCE BACKUPS].dbo.Modelo__c MODE
ON MODE.Codigo_do_Modelo__c = CTE.CodFipe_Modelo and MODE.Marca__c = MAR.Id
LEFT JOIN [SALESFORCE BACKUPS].dbo.Ano_Modelo_de_Veiculo__c ANO
ON ANO.Modelo__c = MODE.Id and ANO.Name = COALESCE(CTE.AnoModelo,CTE.AnoFabricacao)
LEFT JOIN [SALESFORCE BACKUPS].dbo.Contrato__c CTR
ON CTR.NumeroApolice__c  = CNT.NumeroContrato COLLATE SQL_Latin1_General_CP1_CI_AS
--where not exists (select * from cte cte1
--				 where cte1.IDProposta = cte.IDProposta
--				 and cte1.ORDEM > 1)
where ORDEM1 = 1
and ISNULL(CTR.StatusContrato__c,'') <> 'Cancelado'
and MAR.Name is not null


SELECT @RowVersionContrato= MAX(RowVersionContrato),
	   @RowVersionEndosso= MAX(RowVersionEndosso),
	   @RowVersionProposta = MAX(RowVersionProposta) 
FROM #PRP_AUTO
UPDATE Stage_Salesforce.ControleDados.PontoParada set PontoParada  = @RowVersionContrato where NomeEntidade = 'RowVersionContrato'
UPDATE Stage_Salesforce.ControleDados.PontoParada set PontoParada  = @RowVersionProposta  where NomeEntidade = 'RowVersionProposta'
UPDATE Stage_Salesforce.ControleDados.PontoParada set PontoParada  = @RowVersionEndosso  where NomeEntidade = 'RowVersionEndosso'

--and not exists (select * from Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] cnt where cnt.Numero_da_proposta__c = CTE.NumeroProposta COLLATE SQL_Latin1_General_CP1_CS_AS)

--select * from Stage_Salesforce.ControleDados.PontoParada
 --and  CTE.CPF = '008.727.210-51' --AND CTE.CPF NOT LIKE '/'--  cte.idproposta is null
--ORDER BY cte.IDContrato, ORDEM
 
--FOX 1.6 GII FLEX 4P            2015


--select * from [SALESFORCE BACKUPS].dbo.Marca__c m
--inner join [SALESFORCE BACKUPS].dbo.Modelo__c mo on mo.Marca__c = m.Id and mo.Id = 'a271a000000YaltAAC'
--inner join [SALESFORCE BACKUPS].dbo.Ano_Modelo_de_Veiculo__c am on am.Modelo__c = mo.Id 
--where m.Id =  'a261a000000ZLpjAAG'

--	a271a000000YZznAAG	a251a000000NwLLAA0

	
--	select * from [SALESFORCE BACKUPS].dbo.Modelo__c 







--	select * from  #PRPautoteste t 
--	inner join Dados.Proposta p on p.NumeroProposta = t.NumeroProposta COLLATE SQL_Latin1_General_CP1_CI_AI
--	inner join Dados.Simuladorauto sa on sa.IDProposta = p.ID






--select * from Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO]  WHERE Ano_Modelo_de_Veiculo__c  IS NULL AND CPF_CNPJ__c = '398.613.170-15'
----184093 

--%%
--select v.*,sa.CodigoFipe,SA.IDProposta,p.ID,sa.*,pa.* from Dados.PropostaCliente pc  
--inner join Dados.Proposta p on p.ID = pc.IDProposta
--left join Dados.PropostaAutomovel pa on pa.IDProposta = p.ID
--inner join DAdos.Veiculo v on v.ID = pa.IDVeiculo
--left join Dados.SimuladorAuto sa on sa.IDProposta = p.Id
--where pc.CPFCNPJ in ('093.308.417-08'),
--'142.069.949-00',      
--'124.234.527-21')      
--NumeroProposta = '080502440133550'

--1050824

--select * from [SALESFORCE BACKUPS].dbo.Ano_Modelo_de_Veiculo__c  where Modelo__c = 'a271a000000YZkSAAW'
--select * from [SALESFORCE BACKUPS].dbo.Marca__c where Id = 'a261a000000ZLofAAG'

--select * from [SALESFORCE BACKUPS].dbo.Modelo__c where Id = 'a271a000000YZkSAAW'




--select * from Dados.TipoSeguro
--select * from Corporativo.Dados.SimuladorAuto sa
--inner join dados.veiculo v on v.id = sa.IDVeiculo
--where Placa in ('IXJ4882','IPW1659')
--order by DataCalculo desc



--select * from Dados.Proposta where ID = 63500210


--55920011)

--select IDSituacaoProposta,* from Corporativo.Dados.Proposta where ID IN (49727816,
--55920011)




--select * from DAdos.Proposta where ID IN (61808141,
--69946314)



--SELECT * FROM OBERON.FENAE.DBO.SIMULADOR_AUTO WHERE PROPOSTA LIKE '%80514440131078%'

--select * from Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] 
--	where CPF_CNPJ__c = '894.122.307-53'
	





--	CASE WHEN IDTipoSeguro in (0,1) then 'Novo' Else 'Renovação' end as Tipo_de_seguro__c
--	 ,CASE WHEN IDTipoSEguro = 22 then 'Automática' 
--			WHEN IDTipoSeguro = 19 then 'Congênere'
--			WHEN IDTipoSeguro NOT IN (0,1,22,19) THEN 'Manual'
--			Else ''
--		END AS Renovacao__c
--	, MAR.Id as MarcaVeiculo__c
--	, MODE.Id as ModeloVeiculo__c
--	, ANO.Id as Ano_Modelo_de_Veiculo__c
--	, NumeroProposta as Numero_da_proposta__c
--	, 'Ativo' as StatusContrato__c
--	, Indicador__c
--	, CASE WHEN IDFormaPagtoParcela1 = 99 THEN 'Débito'
--	Else 'Boleto'End Forma_de_pagamento__c

--	alter table Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO]  add  Tipo_cliente_Simulador nvarchar(50)
--	select Marca__c,* from Stage_SalesForce.Enqueue.[Contract_load_contract_AUTO] where Name like 'ADELKIZA%'
--	select * from SALESFORCE_PROD...Account where Name like 'ADELKIZA%'