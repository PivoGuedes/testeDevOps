CREATE PROCEDURE [Dados].[proc_InsereContatoPessoa] 
AS


/*
Tabelas relacionadas:

Principal:	SELECT * FROM Dados.ContatoPessoa
Auxiliares:
	SELECT * FROM Dados.EmailContatoPessoa
	SELECT * FROM Dados.TelefoneContatoPessoa
	SELECT * FROM Dados.OrigemDadoContato

Finalizados:
1 - Gravados todos os CPF / CNPJ das tasks com atendimento finalizado do Salesforce.
2 - Gravados telefones fixos e móvel das task do salesforce
3 - Gravados todos os CPF / CNPJ que possuem contrato sem telefone nulo no ODS
4 - Gravados todos os CPF / CNPJ que possuem proposta sem telefone nulo no ODS
5 - Gravados os telefones fixo e móvel dos contratos do ODS.
6 - Gravar emails dos contratos
7 - Gravar telefones e emails das propostas
8 - Gravar telefones e emails das simulações de auto

Pendências de insert:

1 - Gravar telefones e emails das tabelas ad-hoc
2 - Automatizar a atualização

Exemplo de utilização:


	SELECT * FROM Dados.vw_ContatoPessoa WHERE CPFCNPJ IN ('832.737.941-00','971.417.633-68','215.958.658-70')

	CREATE VIEW Dados.vw_ContatoPessoa 
	AS

		SELECT CPFCNPJ, Celular, Fixo, Email
		FROM Dados.ContatoPessoa AS CP
		OUTER APPLY (SELECT TOP 1 Telefone AS Celular FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=1 ORDER BY Ordem Desc) AS Cel
		OUTER APPLY (SELECT TOP 1 Telefone AS Fixo FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=0 ORDER BY Ordem Desc) AS Fixo
		OUTER APPLY (SELECT TOP 1 Email FROM Dados.EmailContatoPessoa AS E WHERE CP.ID=E.IDContatoPessoa ORDER BY Ordem Desc) AS Em
		


select * from dados.propostacliente order by id desc
*/

--LIMPA TABELAS
TRUNCATE TABLE Dados.TelefoneContatoPessoa 
TRUNCATE TABLE Dados.EmailContatoPessoa 
DELETE FROM  Dados.ContatoPessoa


--SELECT * FROM Dados.TelefoneContatoPessoa 
--SELECT * FROM Dados.EmailContatoPessoa 
--SELECT * FROM Dados.ContatoPessoa


/*****************************************						INSERE PESSOAS				*************************************************************/


;WITH CT AS (
	SELECT 
		CPF_CNPJ__c
		, (CASE WHEN SUBSTRING(Call_Ani__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_Ani__c, 4,20)) >= 10   THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND ISNUMERIC(SUBSTRING(Call_Ani__c, 4,20))=1 THEN SUBSTRING(Call_Ani__c, 4,20) ELSE NULL END)ELSE NULL END ) AS Phone1__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_Ani__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone1_Mobile


		, (CASE WHEN SUBSTRING(Call_CalledNumber__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_CalledNumber__c, 4,20)) >= 10 THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND  ISNUMERIC(SUBSTRING(Call_CalledNumber__c, 4,20))=1 THEN SUBSTRING(Call_CalledNumber__c, 4,20) ELSE NULL END) ELSE NULL END)  AS Phone2__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_CalledNumber__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone2_Mobile

		,T.SystemModstamp
		,ROW_NUMBER()  OVER (PARTITION BY CPF_CNPJ__c ORDER BY T.SystemModstamp DESC) AS LastCall
		,UPPER(Name) AS Name
	FROM [SALESFORCE BACKUPS].dbo.Task  AS T
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A
	ON T.AccountId=A.Id
	WHERE Call_CalledNumber__c IS NOT NULL AND CPF_CNPJ__c IS NOT NULL
	AND Categoria__c='Atendimento Realizado'
	--AND CPF_CNPJ__c='206.093.528-81'
)

INSERT INTO Dados.ContatoPessoa (CPFCNPJ, Nome)
SELECT 
	DISTINCT CPF_CNPJ__c
	--,COALESCE(Phone1__c,Phone2__c) AS PhoneNumber
--	, Phone1__c
	--, Phone2__c
	,Name
--	,1 AS IsMobile
FROM CT
WHERE 
	--	(IsPhone1_Mobile=1 OR IsPhone2_Mobile=1) AND
	 (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
	AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
	and LastCall=1


/*****************************************						INSERE TELEFONE CELULAR	do Salesforce			*************************************************************/
;WITH CT AS (
	SELECT 
		CPF_CNPJ__c COLLATE SQL_Latin1_General_CP1_CI_AS AS CPF_CNPJ__c
		, (CASE WHEN SUBSTRING(Call_Ani__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_Ani__c, 4,20)) >= 10   THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND ISNUMERIC(SUBSTRING(Call_Ani__c, 4,20))=1 THEN SUBSTRING(Call_Ani__c, 4,20) ELSE NULL END)ELSE NULL END ) AS Phone1__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_Ani__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone1_Mobile


		, (CASE WHEN SUBSTRING(Call_CalledNumber__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_CalledNumber__c, 4,20)) >= 10 THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND  ISNUMERIC(SUBSTRING(Call_CalledNumber__c, 4,20))=1 THEN SUBSTRING(Call_CalledNumber__c, 4,20) ELSE NULL END) ELSE NULL END)  AS Phone2__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_CalledNumber__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone2_Mobile

		,T.SystemModstamp  AS DataAtualizacao
		,ROW_NUMBER()  OVER (PARTITION BY CPF_CNPJ__c ORDER BY T.SystemModstamp DESC) AS LastCall
		,UPPER(Name) AS Name
	FROM [SALESFORCE BACKUPS].dbo.Task  AS T
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A
	ON T.AccountId=A.Id
	WHERE Call_CalledNumber__c IS NOT NULL AND CPF_CNPJ__c IS NOT NULL
	AND Categoria__c='Atendimento Realizado'
	--AND CPF_CNPJ__c='206.093.528-81'
)
INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT
	CP.ID 
	,1 AS IDOrigemDadoContato -- 1 = Salesforce
	,COALESCE(Phone1__c,Phone2__c) AS PhoneNumber
	,1 AS Ordem -- Números que tiveram contato com sucesso no Salesforce são a 1ª prioridade.
	,GETDATE()
	,1 AS IsMobile
FROM CT 
INNER JOIN Dados.ContatoPessoa AS CP
ON CT.CPF_CNPJ__c=CP.CPFCNPJ
WHERE 
		(IsPhone1_Mobile=1 ) --OR IsPhone2_Mobile=1
	AND (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
	AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
	and LastCall=1


/*****************************************						INSERE TELEFONE FIXO	do salesforce		*************************************************************/

;WITH CT AS (
	SELECT 
		CPF_CNPJ__c COLLATE SQL_Latin1_General_CP1_CI_AS AS CPF_CNPJ__c
		, (CASE WHEN SUBSTRING(Call_Ani__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_Ani__c, 4,20)) >= 10   THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND ISNUMERIC(SUBSTRING(Call_Ani__c, 4,20))=1 THEN SUBSTRING(Call_Ani__c, 4,20) ELSE NULL END)ELSE NULL END ) AS Phone1__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_Ani__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone1_Mobile


		, (CASE WHEN SUBSTRING(Call_CalledNumber__c, 1,6) NOT IN ('+55800') AND LEN(SUBSTRING(Call_CalledNumber__c, 4,20)) >= 10 THEN 
			(CASE WHEN Call_CalledNumber__c NOT LIKE '%-%' AND  ISNUMERIC(SUBSTRING(Call_CalledNumber__c, 4,20))=1 THEN SUBSTRING(Call_CalledNumber__c, 4,20) ELSE NULL END) ELSE NULL END)  AS Phone2__c

		, (CASE WHEN SUBSTRING(ISNULL(Call_CalledNumber__c,'0'), 6,1) IN ('6','7','8','9') THEN 1 ELSE 0 END) IsPhone2_Mobile

		,T.SystemModstamp  AS DataAtualizacao
		,ROW_NUMBER()  OVER (PARTITION BY CPF_CNPJ__c ORDER BY T.SystemModstamp DESC) AS LastCall
		,UPPER(Name) AS Name
	FROM [SALESFORCE BACKUPS].dbo.Task  AS T
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A
	ON T.AccountId=A.Id
	WHERE Call_CalledNumber__c IS NOT NULL AND CPF_CNPJ__c IS NOT NULL
	AND Categoria__c='Atendimento Realizado'
	--AND CPF_CNPJ__c='206.093.528-81'
)
INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT
	CP.ID 
	,1 AS IDOrigemDadoContato -- 1 = Salesforce
	,COALESCE(Phone1__c,Phone2__c) AS PhoneNumber
	,1 AS Ordem -- Números que tiveram contato com sucesso no Salesforce são a 1ª prioridade.
	,GETDATE()
	,0 AS IsMobile
FROM CT 
INNER JOIN Dados.ContatoPessoa AS CP
ON CT.CPF_CNPJ__c=CP.CPFCNPJ
WHERE 
		(IsPhone1_Mobile=0)
	AND (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
	AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
	and LastCall=1



/*****************************************					INSERE CPFCNPJ DE CONTRATO CLIENTE   *************************************************************/

INSERT INTO Dados.ContatoPessoa (CPFCNPJ)
SELECT DISTINCT CC.CPFCNPJ--, NomeCliente--, CP.*
FROM Dados.ContratoCliente AS CC
OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=CC.CPFCNPJ) AS CP
WHERE Telefone IS NOT NULL
AND CP.CPFCNPJ IS NULL


/*****************************************						INSERE TELEFONE CELULAR DE CONTRATO CLIENTE   *************************************************************/
;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa, 
		CC.DataArquivo AS DataAtualizacao,
		CAST(CAST(CC.DDD AS INT) AS VARCHAR(5)) + CAST(CAST(CC.Telefone AS INT) AS VARCHAR(12)) AS Telefone, 
		(CASE WHEN (CAST(SUBSTRING(cast(cast(replace(Telefone,'-','') as int) as varchar),1,1) AS INT) >= 6 AND CAST(SUBSTRING(cast(cast(Telefone as int) as varchar),1,1) AS INT) <=9) THEN 1 ELSE 0 END) IsMobile,
		ROW_NUMBER()  OVER (PARTITION BY CC.CPFCNPJ ORDER BY CC.DataArquivo DESC) AS LastCall
	FROM Dados.ContratoCliente AS CC
	INNER JOIN Dados.ContatoPessoa AS CP
	ON CC.CPFCNPJ=CP.CPFCNPJ
	WHERE CC.Telefone IS NOT NULL
)
INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, 3 AS IDOrigemDadoContato -- 3 = Contrato ODS
	, Telefone
	, 3 AS Ordem 
	, DataAtualizacao
	, 1 AS IsMobile
FROM CT
where LastCall = 1
AND IsMobile=1
AND Telefone<>''


/*****************************************						INSERE TELEFONE FIXO DE CONTRATO CLIENTE   *************************************************************/
;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa, 
		CC.DataArquivo AS DataAtualizacao,
		CAST(CAST(CC.DDD AS INT) AS VARCHAR(5)) + CAST(CAST(REPLACE(CC.Telefone,'-','') AS INT) AS VARCHAR(12)) AS Telefone, 
		(CASE WHEN (CAST(SUBSTRING(cast(cast(replace(Telefone,'-','') as int) as varchar),1,1) AS INT)) <= 6  THEN 1 ELSE 0 END) IsMobile,
		ROW_NUMBER()  OVER (PARTITION BY CC.CPFCNPJ ORDER BY CC.DataArquivo DESC) AS LastCall--,cc.telefone
		

	FROM Dados.ContratoCliente AS CC
	INNER JOIN Dados.ContatoPessoa AS CP
	ON CC.CPFCNPJ=CP.CPFCNPJ
	WHERE CC.Telefone IS NOT NULL
	--and CP.CPFCNPJ = '075.045.227-75'
)
INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, 3 AS IDOrigemDadoContato -- 3 = Contrato ODS
	, Telefone
	, 3 AS Ordem 
	, DataAtualizacao
	, 0 AS IsMobile
FROM CT
where LastCall = 1
AND IsMobile=0
AND Telefone<>''


/*****************************************						INSERE EMAIL DE CONTRATO CLIENTE   *************************************************************/

;WITH CT AS (
	SELECT 
		C.ID AS IDContatoPessoa
		, [Dados].[fn_ValidaEmail](COALESCE(Email, EmailComercial)) AS Email
		, DataArquivo AS DataAtualizacao 
		, ROW_NUMBER()  OVER (PARTITION BY CC.CPFCNPJ ORDER BY CC.DataArquivo DESC) AS LastCall
	FROM Dados.PropostaCliente AS CC
	INNER JOIN Dados.ContatoPessoa AS C ON C.CPFCNPJ=CC.CPFCNPJ
	WHERE Email IS NOT NULL OR EmailComercial IS NOT NULL
)
INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT IDContatoPessoa, 3, Email, 3, DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		'NAOTEM@NAOTEM.COM.BR'
		,'NONE@NONE.COM.BR'
		,'SEM@SEM.COM.BR'
		,'NAOPOSSUI@NAOPOSSUI.COM.BR'
		,'0'
		,''
		,'n?o possui'
		,'XXX@XXX.COM.BR'
		,'NAOTEM@GMAIL.COM'
		,'NT@NT.COM.BR'
		,'NAOTEM@HOTMAIL.COM'
		,'.'
		,'GR@GR.COM'
		,'NAOTEM@NAOTEM.COM'
		,'NAOTENHO@EMAIL.COM.BR'
		,'F.F@CAIXA.GOV'
		,'NAOPOSSUI@NOEMAIL.COM'
		,'XXXX@COM.BR'
		,'XXXX@XXX.XX'
		,'NAOTENHO@HOTMAIL.COM'
		,'HAHAH@HAHA.COM.BR'
		,'NAOINFORMADO@NAOINFORMADO.COM.BR'
		,'NAO@NAO.COM.BR'
		,'A@AMAIL.COM'
		,'nery@hy.com.br'
		,'FAFF@GBL.COM.BR'
		,'XX@XX.COM.BR'
		,'NAO.TEM@NAO.TEM.COM.BR'
		,'NAOTEM@FAZER.OQE.BR'
		,'NAO@NAOTEM.COM.BR'
		,'A@A.COM.BR'
		,'A@HOTMAIL.COM'
		,'A@A.COM.BR'
		,'X@X.COM.BR'
		,'XX@XX.COM.BR'
		,'GUY@OOOO.COM'
		,'00@00.00.00'
		,'NAOPOSSUI@NAOTEM.COM.BR'
		,'AAA@AAA.COM.BR'
		,'.@.COM.BR'
		,'BRASIL@HOTMAIL.COM'
		,'AAAAA@SAAAAA.COM'
		,'NAOTEM@BOL.COM.BR'
		,'A@CAIXA.COM.BR'
		,'AJR@OI.COM.BR'
		,'XXX@GMAIL.COM'
		,'XXXXX@XXXX.XXXX'
		,'PROT@SIO.COM.BR'
		,'ENECARAUTOMEC@XX.COM.BR'
		,'NAOTEM@NAO.COM.BR'
		,'naotenho@naotenho.com'
	)
	AND Email LIKE '%_@_%_.__%' 
	AND RIGHT(Email ,3) IN ('com','org','.br','.UK','NET','.US','biz','.in')
	AND Email  NOT LIKE '%[/|~^´,;:+!$%?&*()#|]%'
	AND Email  not like '%naopossui%'
	and Email  not like '%possui%'
	and Email  not like '%nao tem%'
	and Email  not like '%naotem%'
	and Email  not like '%nao sei%'
	and Email  not like '%naosei%'
	and Email  not like '%@a.com.br%'
	and Email  not like 'caixa@caixa.com.br'
	and Email  not like 'nao@nao.com.br'
	and Email  not like 'backseg@backseg.com.br'
	and Email  not like 'backoffice@%'
	and Email  not like 'n@n.com.br' 
	and Email  not like '%não possui%'
	and Email  not like '@'
	and Email  not like '0@0.COM.BR'
	and Email  not like 'XXX@GMAIL.COM'
	AND LastCall=1

/*****************************************						INSERE CPFCNPJ DE PROPOSTA CLIENTE   *************************************************************/

INSERT INTO Dados.ContatoPessoa (CPFCNPJ)
SELECT DISTINCT PC.CPFCNPJ--, NomeCliente--, CP.*
FROM Dados.PropostaCliente AS PC
OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=PC.CPFCNPJ) AS CP
WHERE (TelefoneResidencial IS NOT NULL OR TelefoneComercial IS NOT NULL OR TelefoneCelular IS NOT NULL)
AND CP.CPFCNPJ IS NULL
AND PC.CPFCNPJ IS NOT NULL


/*****************************************						INSERE TELEFONE CELULAR DE PROPOSTA CLIENTE   *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,COALESCE(DDDResidencial, DDDComercial, DDDCelular) AS DDD
		,COALESCE(TelefoneResidencial, TelefoneCelular, TelefoneComercial) AS Telefone
		,ROW_NUMBER()  OVER (PARTITION BY PC.CPFCNPJ ORDER BY PC.DataArquivo DESC) AS LastCall
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneComercial IS NOT NULL OR TelefoneResidencial IS NOT NULL OR TelefoneCelular IS NOT NULL)
), CT1 AS (
	SELECT 
		IDContatoPessoa
	, 2 AS IDOrigemDadoContato -- 2 = Proposta ODS
	, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(Telefone)),')',''),'(',''),'-',''),' ',''),'.',''),',','') AS Telefone
	, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(DDD)),')',''),'(',''),'-',''),'.',''),' ',''),',','') AS DDD
	, 4 AS Ordem 
	, DataAtualizacao
	, LastCall
	FROM CT
),CT2 AS (
	SELECT 
		IDContatoPessoa
	, IDOrigemDadoContato -- 2 = Proposta ODS
	, DDD
	, Telefone
	, Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
	, LastCall
	FROM CT1
	WHERE ISNUMERIC(Telefone)=1 AND ISNUMERIC(DDD)=1
	AND  LEN(Telefone) >= 8
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS INT) AS VARCHAR(12)) AS Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT2
where LastCall = 1
AND IsMobile=1


/*****************************************						INSERE TELEFONE FIXO DE PROPOSTA CLIENTE   *************************************************************/


;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,COALESCE(DDDResidencial, DDDComercial, DDDCelular) AS DDD
		,COALESCE(TelefoneResidencial, TelefoneCelular, TelefoneComercial) AS Telefone
		,ROW_NUMBER()  OVER (PARTITION BY PC.CPFCNPJ ORDER BY PC.DataArquivo DESC) AS LastCall
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneComercial IS NOT NULL OR TelefoneResidencial IS NOT NULL OR TelefoneCelular IS NOT NULL)
),
CT1 AS (
	SELECT 
		IDContatoPessoa
	, 2 AS IDOrigemDadoContato -- 2 = Proposta ODS
	, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(Telefone)),')',''),'(',''),'-',''),' ',''),'.',''),',','') AS Telefone
	, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(DDD)),')',''),'(',''),'-',''),'.',''),' ',''),',','') AS DDD
	, 4 AS Ordem 
	, DataAtualizacao
	, LastCall
	FROM CT
)
,CT2 AS (
	SELECT 
		IDContatoPessoa
	, IDOrigemDadoContato -- 2 = Proposta ODS
	, DDD
	, Telefone
	, Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
	, LastCall
	FROM CT1
	WHERE ISNUMERIC(Telefone)=1 AND ISNUMERIC(DDD)=1 AND  LEN(Telefone) >= 8
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS INT) AS VARCHAR(12)) AS Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT2
where LastCall = 1
AND IsMobile=0

/*****************************************						INSERE EMAIL DE PROPOSTA CLIENTE   *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,COALESCE(Email , EmailComercial) AS Email
		,ROW_NUMBER()  OVER (PARTITION BY PC.CPFCNPJ ORDER BY PC.DataArquivo DESC) AS LastCall
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (Email IS NOT NULL OR EmailComercial IS NOT NULL)
)
INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT IDContatoPessoa, 2, Email, 2, DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		'NAOTEM@NAOTEM.COM.BR'
		,'NONE@NONE.COM.BR'
		,'SEM@SEM.COM.BR'
		,'NAOPOSSUI@NAOPOSSUI.COM.BR'
		,'0'
		,''
		,'n?o possui'
		,'XXX@XXX.COM.BR'
		,'NAOTEM@GMAIL.COM'
		,'NT@NT.COM.BR'
		,'NAOTEM@HOTMAIL.COM'
		,'.'
		,'GR@GR.COM'
		,'NAOTEM@NAOTEM.COM'
		,'NAOTENHO@EMAIL.COM.BR'
		,'F.F@CAIXA.GOV'
		,'NAOPOSSUI@NOEMAIL.COM'
		,'XXXX@COM.BR'
		,'XXXX@XXX.XX'
		,'NAOTENHO@HOTMAIL.COM'
		,'HAHAH@HAHA.COM.BR'
		,'NAOINFORMADO@NAOINFORMADO.COM.BR'
		,'NAO@NAO.COM.BR'
		,'A@AMAIL.COM'
		,'nery@hy.com.br'
		,'FAFF@GBL.COM.BR'
		,'XX@XX.COM.BR'
		,'NAO.TEM@NAO.TEM.COM.BR'
		,'NAOTEM@FAZER.OQE.BR'
		,'NAO@NAOTEM.COM.BR'
		,'A@A.COM.BR'
		,'A@HOTMAIL.COM'
		,'A@A.COM.BR'
		,'X@X.COM.BR'
		,'XX@XX.COM.BR'
		,'GUY@OOOO.COM'
		,'00@00.00.00'
		,'NAOPOSSUI@NAOTEM.COM.BR'
		,'AAA@AAA.COM.BR'
		,'.@.COM.BR'
		,'BRASIL@HOTMAIL.COM'
		,'AAAAA@SAAAAA.COM'
		,'NAOTEM@BOL.COM.BR'
		,'A@CAIXA.COM.BR'
		,'AJR@OI.COM.BR'
		,'XXX@GMAIL.COM'
		,'XXXXX@XXXX.XXXX'
		,'PROT@SIO.COM.BR'
		,'ENECARAUTOMEC@XX.COM.BR'
		,'NAOTEM@NAO.COM.BR'
		,'naotenho@naotenho.com'

	)
	AND Email LIKE '%_@_%_.__%' 
	AND RIGHT(Email ,3) IN ('com','org','.br','.UK','NET','.US','biz','.in')
	AND Email  NOT LIKE '%[/|~^´,;:+!$%?&*()#|]%'
	AND Email  not like '%naopossui%'
	and Email  not like '%possui%'
	and Email  not like '%nao tem%'
	and Email  not like '%naotem%'
	and Email  not like '%nao sei%'
	and Email  not like '%naosei%'
	and Email  not like '%@a.com.br%'
	and Email  not like 'caixa@caixa.com.br'
	and Email  not like 'nao@nao.com.br'
	and Email  not like 'backseg@backseg.com.br'
	and Email  not like 'backoffice@%'
	and Email  not like 'n@n.com.br' 
	and Email  not like '%não possui%'
	and Email  not like '@'
	and Email  not like '0@0.COM.BR'
	and Email  not like 'XXX@GMAIL.COM'
	AND LastCall=1


/*****************************************		INSERE CPFCNPJ DAS SIMULAÇÕES DE AUTO   *************************************************************/
	
INSERT INTO Dados.ContatoPessoa (CPFCNPJ)
SELECT DISTINCT SA.CPFCNPJ
FROM Dados.SimuladorAuto AS SA
OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=SA.CPFCNPJ) AS CP
WHERE TelefoneContato IS NOT NULL
AND CP.CPFCNPJ IS NULL
AND SA.CPFCNPJ IS NOT NULL


/*****************************************						INSERE TELEFONE FIXO DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 2 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL)
	AND SUBSTRING(TelefoneContato,1,1) NOT IN ('6','7','8','9')
)
INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato 
	, Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT
where IsMobile=0



/*****************************************						INSERE TELEFONE CELULAR DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(LTRIM(RTRIM(TelefoneContato)) AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 2 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL)
	--AND SA.CPFCNPJ='255.210.209-34'
	AND SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9')
	AND ISNUMERIC(TelefoneContato)=1
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato 
	, Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT
where IsMobile=1



/*****************************************		INSERE CPFCNPJ DAS BASE DE VINCENDOS RENAUTOVIN *************************************************************/
	
INSERT INTO Dados.ContatoPessoa (CPFCNPJ)
SELECT DISTINCT RA.CPFCNPJ
FROM Mailing.ContatoRenautvin AS RA
OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=RA.CPFCNPJ) AS CP
WHERE Fone IS NOT NULL
AND CP.CPFCNPJ IS NULL
AND RA.CPFCNPJ IS NOT NULL



/*****************************************	INSERE TELEFONE CELULAR DE VINCENDOS RENAUTOVIN  *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Fone AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 5 AS IDOrigemDadoContato
		, 2 AS Ordem
		, (CASE WHEN SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		--,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY DDD DESC) AS LastCall
		,GETDATE() AS DataAtualizacao
	FROM Mailing.ContatoRenautvin AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDD IS NOT NULL AND Fone IS NOT NULL)
	--AND SA.CPFCNPJ='255.210.209-34'
	AND SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) IN ('6','7','8','9')
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato 
	, Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT
where 
IsMobile=1


/*****************************************	INSERE TELEFONE FIXOE VINCENDOS RENAUTOVIN *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Fone AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 5 AS IDOrigemDadoContato
		, 2 AS Ordem
		, (CASE WHEN SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		--,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY DDD DESC) AS LastCall
		,GETDATE() AS DataAtualizacao
	FROM Mailing.ContatoRenautvin AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDD IS NOT NULL AND Fone IS NOT NULL)
	--AND SA.CPFCNPJ='255.210.209-34'
	AND SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) NOT IN ('6','7','8','9')
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, IDOrigemDadoContato 
	, Telefone
	, Ordem 
	, DataAtualizacao
	, IsMobile
FROM CT
where 
IsMobile=0 


/*****************************************						REMOVE LIXO *************************************************************/

delete  FROM Dados.Telefonecontatopessoa where ismobile=0 and substring(telefone,3,1) in ('7','8','9')
delete  FROM Dados.Telefonecontatopessoa where telefone like '%99999999%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%88888888%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%77777777%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%66666666%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%55555555%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%44444444%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%33333333%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%22222222%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%11111111%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%00000000%'
delete  FROM Dados.Telefonecontatopessoa where telefone like '%*%'


/************************************************	Ajusta nono dígito ********************************************************************/
Update Dados.TelefoneContatoPessoa SET Telefone=LEFT(Telefone,2) + '9' +RIGHT(Telefone,8) WHERE IsMobile=1 and len(telefone)=10

delete  FROM Dados.Telefonecontatopessoa where len(telefone)<10
delete  FROM Dados.Telefonecontatopessoa where len(telefone)>11



