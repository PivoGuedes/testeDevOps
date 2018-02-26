CREATE PROCEDURE [Dados].[proc_NewInsereContatoPessoa] 
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
	CREATE VIEW Dados.vw_ContatoPessoa 	AS
		SELECT CPFCNPJ, Celular, Fixo, Email
		FROM Dados.ContatoPessoa AS CP
		OUTER APPLY (SELECT TOP 1 Telefone AS Celular FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=1 ORDER BY Ordem Desc) AS Cel
		OUTER APPLY (SELECT TOP 1 Telefone AS Fixo FROM Dados.TelefoneContatoPessoa AS T WHERE CP.ID=T.IDContatoPessoa AND IsMobile=0 ORDER BY Ordem Desc) AS Fixo
		OUTER APPLY (SELECT TOP 1 Email FROM Dados.EmailContatoPessoa AS E WHERE CP.ID=E.IDContatoPessoa ORDER BY Ordem Desc) AS Em

select * from dados.propostacliente order by id desc
*/

/*
27/11/2017 - Alterado por Raiane Lins. Tirado o DELETE na tabela Dados.ContatoPessoa e colocado o MERGE no insert desta tabela.
05/12/2017 - Alterado por Pedro Guedes. Acrescentado o s telefones da base do Last Chance 



*/


--LIMPA TABELAS
TRUNCATE TABLE Dados.TelefoneContatoPessoa 
TRUNCATE TABLE Dados.EmailContatoPessoa 
--DELETE FROM  Dados.ContatoPessoa  Retirado em 27/11/2017



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
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A ON T.AccountId=A.Id
	WHERE Call_CalledNumber__c IS NOT NULL AND CPF_CNPJ__c IS NOT NULL AND Categoria__c='Atendimento Realizado'
)

MERGE INTO Dados.ContatoPessoa AS Destino
USING (
		SELECT	DISTINCT CPF_CNPJ__c
				,Name
		FROM CT
		WHERE (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
				AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
				AND LastCall=1) AS Origem  ON (Destino.CPFCNPJ = Origem.CPF_CNPJ__c COLLATE SQL_Latin1_General_CP1_CI_AI)
WHEN NOT MATCHED 
THEN INSERT (CPFCNPJ, Nome)
VALUES (Origem.CPF_CNPJ__c , Origem.Name);

/*****************************************INSERE TELEFONE CELULAR	do Salesforce*************************************************************/

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
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A ON T.AccountId=A.Id
	WHERE Call_CalledNumber__c IS NOT NULL AND CPF_CNPJ__c IS NOT NULL	AND Categoria__c='Atendimento Realizado'
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT
	CP.ID 
	,1 AS IDOrigemDadoContato -- 1 = Salesforce
	,COALESCE(Phone1__c,Phone2__c) AS PhoneNumber
	,1 AS Ordem --Números que tiveram contato com sucesso no Salesforce são a 1ª prioridade.
	,GETDATE()
	,1 AS IsMobile
FROM CT 
INNER JOIN Dados.ContatoPessoa AS CP ON CT.CPF_CNPJ__c=CP.CPFCNPJ
WHERE (IsPhone1_Mobile=1 ) 
	AND (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
	AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
	and LastCall=1


/*****************************************	INSERE TELEFONE FIXO	do salesforce		*************************************************************/

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
	INNER JOIN [SALESFORCE BACKUPS].dbo.Account AS A ON T.AccountId=A.Id
	WHERE	Call_CalledNumber__c IS NOT NULL 
			AND CPF_CNPJ__c IS NOT NULL
			AND Categoria__c='Atendimento Realizado'
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
INNER JOIN Dados.ContatoPessoa AS CP ON CT.CPF_CNPJ__c=CP.CPFCNPJ
WHERE (IsPhone1_Mobile=0)
	AND (Phone1__c IS NOT NULL OR Phone2__c IS NOT NULL)
	AND CPF_CNPJ__c NOT IN ('000.000.000-00','00.000.000/0000-00')
	and LastCall=1

/*****************************************		INSERE CPFCNPJ DAS SIMULAÇÕES DE AUTO   *************************************************************/

MERGE INTO Dados.ContatoPessoa AS Destino
USING (
		SELECT DISTINCT SA.CPFCNPJ
		FROM Dados.SimuladorAuto AS SA
		OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=SA.CPFCNPJ) AS CP
		WHERE	TelefoneContato IS NOT NULL
				AND CP.CPFCNPJ IS NULL
				AND SA.CPFCNPJ IS NOT NULL ) AS Origem ON (Destino.CPFCNPJ = Origem.CPFCNPJ)
		WHEN NOT MATCHED 
		THEN INSERT (CPFCNPJ)
		VALUES (Origem.CPFCNPJ);


/*****************************************	INSERE TELEFONE FIXO DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 5 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL) AND SUBSTRING(TelefoneContato,1,1) NOT IN ('6','7','8','9')
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



/*****************************************	INSERE TELEFONE CELULAR DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(LTRIM(RTRIM(TelefoneContato)) AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 5 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL)
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

MERGE INTO Dados.ContatoPessoa AS Destino 
USING (
		SELECT DISTINCT RA.CPFCNPJ
		FROM Mailing.ContatoRenautvin AS RA
		OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=RA.CPFCNPJ) AS CP
		WHERE	Fone IS NOT NULL
				AND CP.CPFCNPJ IS NULL
				AND RA.CPFCNPJ IS NOT NULL
) AS ORIGEM ON (Destino.CPFCNPJ = Origem.CPFCNPJ)
WHEN NOT MATCHED
THEN INSERT (CPFCNPJ)
VALUES (Origem.CPFCNPJ);

/*****************************************	INSERE TELEFONE CELULAR DE VINCENDOS RENAUTOVIN  *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa		
		, (CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Fone AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 5 AS IDOrigemDadoContato
		, 6 AS Ordem
		, (CASE WHEN SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,GETDATE() AS DataAtualizacao
	FROM Mailing.ContatoRenautvin AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDD IS NOT NULL AND Fone IS NOT NULL)
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
where IsMobile=1

/*****************************************	INSERE TELEFONE FIXOE VINCENDOS RENAUTOVIN *************************************************************/


;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Fone AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 5 AS IDOrigemDadoContato
		, 6 AS Ordem
		, (CASE WHEN SUBSTRING(CAST(Fone AS VARCHAR(15)),1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,GETDATE() AS DataAtualizacao
	FROM Mailing.ContatoRenautvin AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDD IS NOT NULL AND Fone IS NOT NULL)
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
where IsMobile=0 


/*****************************************					INSERE CPFCNPJ DE CONTRATO CLIENTE   *************************************************************/

MERGE INTO Dados.ContatoPessoa AS Destino
USING (
		SELECT DISTINCT CC.CPFCNPJ--, NomeCliente--, CP.*
		FROM Dados.ContratoCliente AS CC
		OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=CC.CPFCNPJ) AS CP
		WHERE	Telefone IS NOT NULL
				AND CP.CPFCNPJ IS NULL) AS Origem ON (Destino.CPFCNPJ = Origem.CPFCNPJ) 
WHEN NOT MATCHED
THEN INSERT (CPFCNPJ)
VALUES (Origem.CPFCNPJ);

/*****************************************						INSERE TELEFONE CELULAR DE CONTRATO CLIENTE   *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa, 
		CC.DataArquivo AS DataAtualizacao,
		CAST(CAST(CC.DDD AS INT) AS VARCHAR(5)) + CAST(CAST(CC.Telefone AS BIGINT) AS VARCHAR(12)) AS Telefone, 
		(CASE WHEN (CAST(SUBSTRING(cast(cast(replace(Telefone,'-','') as BIGINT) as varchar),1,1) AS INT) >= 6 AND CAST(SUBSTRING(cast(cast(Telefone as BIGINT) as varchar),1,1) AS BIGINT) <=9) THEN 1 ELSE 0 END) IsMobile,
		ROW_NUMBER()  OVER (PARTITION BY CC.CPFCNPJ ORDER BY CC.DataArquivo DESC) AS LastCall
	FROM Dados.ContratoCliente AS CC
	INNER JOIN Dados.ContatoPessoa AS CP ON CC.CPFCNPJ=CP.CPFCNPJ
	WHERE CC.Telefone IS NOT NULL
)


INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, 3 AS IDOrigemDadoContato -- 3 = Contrato ODS
	, Telefone
	, 7 AS Ordem 
	, DataAtualizacao
	, 1 AS IsMobile
FROM CT
where	LastCall = 1
	AND IsMobile=1
	AND Telefone<>''


/*****************************************	INSERE TELEFONE FIXO DE CONTRATO CLIENTE   *************************************************************/
;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa, 
		CC.DataArquivo AS DataAtualizacao,
		CAST(CAST(CC.DDD AS INT) AS VARCHAR(5)) + CAST(CAST(REPLACE(CC.Telefone,'-','') AS BIGINT) AS VARCHAR(12)) AS Telefone, 
		(CASE WHEN (CAST(SUBSTRING(cast(cast(replace(Telefone,'-','') as BIGINT) as varchar),1,1) AS BIGINT)) <= 6  THEN 1 ELSE 0 END) IsMobile,
		ROW_NUMBER()  OVER (PARTITION BY CC.CPFCNPJ ORDER BY CC.DataArquivo DESC) AS LastCall--,cc.telefone
	FROM Dados.ContratoCliente AS CC
	INNER JOIN Dados.ContatoPessoa AS CP ON CC.CPFCNPJ=CP.CPFCNPJ
	WHERE CC.Telefone IS NOT NULL
)

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, 3 AS IDOrigemDadoContato 
	, Telefone
	, 7 AS Ordem 
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
	and Email  not like 'backoffice@%' 
	and Email  not like '%não possui%'

)

INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT IDContatoPessoa, 3, Email, 6, DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		Select NomeEmail from [Dados].[BlackListEmail]
	)
	AND LastCall=1



/*****************************************						INSERE CPFCNPJ DE PROPOSTA CLIENTE   *************************************************************/

MERGE INTO Dados.ContatoPessoa AS Destino
USING (
		SELECT DISTINCT PC.CPFCNPJ
		FROM Dados.PropostaCliente AS PC
		OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=PC.CPFCNPJ) AS CP
		WHERE (TelefoneResidencial IS NOT NULL OR TelefoneComercial IS NOT NULL OR TelefoneCelular IS NOT NULL OR TelefoneFax IS NOT NULL)
		AND CP.CPFCNPJ IS NULL
		AND PC.CPFCNPJ IS NOT NULL) AS Origem ON (Destino.CPFCNPJ = Origem.CPFCNPJ)
WHEN NOT MATCHED
THEN INSERT (CPFCNPJ)
VALUES (Origem.CPFCNPJ);

/*****************************************	INSERIDO POR RAIANE EM 14/09/2017   *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(COALESCE(DDDResidencial,DDDCelular,DDDComercial,DDDFax))),')',''),'(',''),'-',''),'.',''),' ',''),',','') as DDD
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TelefoneResidencial)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'')  AS Telefone
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneResidencial IS NOT NULL
			--AND DDDResidencial IS NOT NULL
			AND COALESCE(DDDResidencial,DDDCelular,DDDComercial,DDDFax) IS NOT NULL 
			AND ISNUMERIC(COALESCE(DDDResidencial,DDDCelular,DDDComercial,DDDFax)) = 1 
			AND ISNUMERIC(TelefoneResidencial) = 1 ) )

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT
	IDContatoPessoa
	, '2' as IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS BIGINT) AS VARCHAR(12)) AS Telefone
	, '8' as Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) as  IsMobile
FROM CT
WHERE   DDD <> ''
	AND Telefone <> ''
	AND Telefone <> CHAR(10)

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(COALESCE(DDDComercial,DDDResidencial,DDDCelular,DDDFax))),')',''),'(',''),'-',''),'.',''),' ',''),',','') AS DDD
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TelefoneComercial)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'')  AS Telefone
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneComercial IS NOT NULL 
			--AND DDDComercial is NOT NULL
			AND COALESCE(DDDComercial,DDDResidencial,DDDCelular,DDDFax) IS NOT NULL
			AND ISNUMERIC(COALESCE(DDDComercial,DDDResidencial,DDDCelular,DDDFax)) = 1 
			AND ISNUMERIC(TelefoneComercial) = 1) )

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT
	IDContatoPessoa
	, '2' as IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS BIGINT) AS VARCHAR(12)) AS Telefone
	, '8' as Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) as  IsMobile
FROM CT
WHERE   DDD <> ''
	AND Telefone <> ''

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(COALESCE(DDDCelular,DDDResidencial,DDDComercial,DDDFax))),')',''),'(',''),'-',''),'.',''),' ',''),',','')  AS DDD
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TelefoneCelular)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'')  AS Telefone
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneCelular IS NOT NULL 
			--AND DDDCelular IS NOT NULL
			AND COALESCE(DDDCelular,DDDResidencial,DDDComercial,DDDFax) IS NOT NULL
			AND ISNUMERIC(COALESCE(DDDCelular,DDDResidencial,DDDComercial,DDDFax)) = 1 
			AND ISNUMERIC(TelefoneCelular) = 1))

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, '2' as IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS BIGINT) AS VARCHAR(12)) AS Telefone
	, '8' as Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) as  IsMobile
FROM CT
WHERE   DDD <> ''
	AND Telefone <> ''

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(COALESCE(DDDFax,DDDResidencial,DDDCelular,DDDComercial))),')',''),'(',''),'-',''),'.',''),' ',''),',','') as DDD
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TelefoneFax)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'')  AS Telefone
		,PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP
		ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE (TelefoneFax IS NOT NULL 
			--AND DDDFax IS NOT NULL
			AND COALESCE(DDDFax,DDDResidencial,DDDCelular,DDDComercial) IS NOT NULL 
			AND ISNUMERIC(COALESCE(DDDFax,DDDResidencial,DDDCelular,DDDComercial)) = 1
			AND ISNUMERIC(TelefoneFax) = 1) )

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT 
	IDContatoPessoa
	, '2' as IDOrigemDadoContato -- 2 = Proposta ODS
	, CAST(CAST(DDD AS INT) AS VARCHAR(2)) + CAST(CAST(Telefone AS BIGINT) AS VARCHAR(12)) AS Telefone
	, '8' as Ordem 
	, DataAtualizacao
	, (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) as  IsMobile
FROM CT
WHERE   DDD <> ''
	AND Telefone <> ''


/*****************************************						INSERE EMAIL DE PROPOSTA CLIENTE   *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa,
		Email  AS Email,
		PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE Email IS NOT NULL 
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
	and Email  not like 'backoffice@%'
	and Email  not like '%não possui%'
	-- Ordem alterada pois o formato anterior estava restringindo emails validos caso o registro do lastcall fosse invalido
)

INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT IDContatoPessoa, 
		2, 
		Email, 
		8, 
		DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		Select NomeEmail from [Dados].[BlackListEmail]
	)


;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa,
		EmailComercial AS Email,
		PC.DataArquivo AS DataAtualizacao
	FROM  Dados.PropostaCliente AS PC
	INNER JOIN Dados.ContatoPessoa AS CP ON PC.CPFCNPJ=CP.CPFCNPJ
	WHERE EmailComercial IS NOT NULL
	AND Email LIKE '%_@_%_.__%' 
	AND RIGHT(EmailComercial ,3) IN ('com','org','.br','.UK','NET','.US','biz','.in')
	AND Email  NOT LIKE '%[/|~^´,;:+!$%?&*()#|]%'
	AND Email  not like '%naopossui%'
	and Email  not like '%possui%'
	and Email  not like '%nao tem%'
	and Email  not like '%naotem%'
	and Email  not like '%nao sei%'
	and Email  not like '%naosei%'
	and Email  not like '%@a.com.br%'
	and Email  not like 'backoffice@%'
	and Email  not like '%não possui%'
	-- Ordem alterada pois o formato anterior estava restringindo emails validos caso o registro do lastcall fosse invalido
)

INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT  IDContatoPessoa, 
		2, 
		Email, 
		8, 
		DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		Select NomeEmail from [Dados].[BlackListEmail]
	)


/*****************************************		INSERE CPFCNPJ DAS BASE DE FUNCIONARIOS MUNDO CAIXA ******************************************************/

MERGE INTO Dados.ContatoPessoa  AS Destino
USING (
		SELECT DISTINCT RA.CPF
		FROM Marketing.FuncionarioMundoCaixa AS RA
		OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=RA.CPF) AS CP
		WHERE	CP.CPFCNPJ IS NULL
				AND RA.CPF IS NOT NULL) AS Origem ON (Destino.CPFCNPJ = Origem.CPF)
WHEN NOT MATCHED 
THEN INSERT (CPFCNPJ)
VALUES (Origem.CPF);

/*****************************************	INSERE TELEFONE CELULAR DE FUNC MUNDO CAIXA  ***********************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa		
		, TelefoneCelular AS Telefone
		, 7 AS IDOrigemDadoContato
		, 4 AS Ordem 
		, '1' AS IsMobile
		,DataArquivo AS DataAtualizacao
	FROM marketing.funcionariomundocaixa AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPF=CP.CPFCNPJ
	WHERE LEN(REPLACE(RTRIM(LTRIM(TelefoneCelular)),' ','')) =11
	and try_parse(REPLACE(RTRIM(LTRIM(TelefoneCelular)),' ','') as bigint) is not null
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

/*****************************************	INSERE TELEFONE FIXO E Func Mundo Caixa *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa		
		, REPLACE(RTRIM(LTRIM(TelefonePessoal)),' ','') AS Telefone
		, 7 AS IDOrigemDadoContato
		, 4 AS Ordem 
		, '0' AS IsMobile
		,DataArquivo AS DataAtualizacao
	FROM marketing.funcionariomundocaixa AS SA
	INNER JOIN Dados.ContatoPessoa AS CP ON SA.CPF=CP.CPFCNPJ
	WHERE LEN(REPLACE(RTRIM(LTRIM(TelefonePessoal)),' ','')) =10
	and try_parse(REPLACE(RTRIM(LTRIM(TelefonePessoal)),' ','') as bigint) is not null

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

/*****************************************						INSERE EMAIL DE FUNC MUNDO CAIXA   *************************************************************/

;WITH CT AS (
	SELECT 
		C.ID AS IDContatoPessoa
		, [Dados].[fn_ValidaEmail](EmailPessoal) AS Email
		, DataArquivo AS DataAtualizacao 
	FROM marketing.funcionariomundocaixa AS CC
	INNER JOIN Dados.ContatoPessoa AS C ON C.CPFCNPJ=CC.CPF
	WHERE ISNULL([Dados].[fn_ValidaEmail](EmailPessoal),'') <> ''
)

INSERT INTO Dados.EmailContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Email, Ordem, DataAtualizacao)
SELECT IDContatoPessoa, 7, Email, 3, DataAtualizacao
FROM CT
WHERE Email NOT IN
	(
		Select NomeEmail from [Dados].[BlackListEmail]
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
	and Email  not like 'backoffice@%' 
	and Email  not like '%não possui%'
	--AND LastCall=1


/*****************************************INSERE Telefones Inserido Pelo Operador do Salesforce*************************************************************/

INSERT INTO Dados.TelefoneContatoPessoa (IDContatoPessoa,IDOrigemDadoContato, Telefone, Ordem, DataAtualizacao, IsMobile)
SELECT	CP.ID,
		6 AS IDOrigemDadoContato,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(AH.NewValue)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'') AS Telefone, 
		2 as Ordem,
		GETDATE() AS DataAtualizacao,
		CASE WHEN SUBSTRING(AH.NewValue, 3,1) IN ('6','7','8','9') THEN 1 ELSE 0 END IsMobile
FROM [SALESFORCE BACKUPS].[dbo].[AccountHistory] AH
INNER JOIN [SALESFORCE BACKUPS].[dbo].[User] U on AH.CreatedById = U.id
INNER JOIN [SALESFORCE BACKUPS].[dbo].Account A on AH.AccountId = A.Id
INNER JOIN Dados.ContatoPessoa AS CP ON A.CPF_CNPJ__c = CP.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE Field in (
'Celular2__pc',
'Celular3__pc',
'PersonMobilePhone',
'Phone',
'Telefone3__pc',
'Telefonee2__pc'
) 
AND u.name <> 'Integrador Wiz'
AND NewValue IS NOT NULL
AND LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(AH.NewValue)),')',''),'(',''),'-',''),' ',''),'.',''),',',''),char(9),'')) < 20


/*****************************************     INSERE TELEFONE FIXO DE LAST CHANCE *************************************************************/

;WITH CT AS (
       SELECT 
             CP.ID AS IDContatoPessoa
             --, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
             ,Telefone
             , 8 AS IDOrigemDadoContato
             , 3 AS Ordem
             , (CASE WHEN SUBSTRING(Telefone,3,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
             ,ROW_NUMBER()  OVER (PARTITION BY pc.CPFCNPJ ORDER BY SA.Codigo DESC) AS LastCall
             ,pc.DataArquivo AS DataAtualizacao
       from  [Corporativo].[Marketing].[LastChance] SA 
       inner join dados.propostacliente pc on pc.id = SA.idcliente
       INNER JOIN Dados.ContatoPessoa AS CP ON pc.CPFCNPJ=CP.CPFCNPJ
       WHERE Telefone IS NOT NULL AND SUBSTRING(Telefone,3,1) NOT IN ('6','7','8','9')
       union
             SELECT 
             CP.ID AS IDContatoPessoa
             --, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
             ,TelefoneAlternativo as Telefone
             , 8 AS IDOrigemDadoContato
             , 3 AS Ordem
             , (CASE WHEN SUBSTRING(TelefoneAlternativo,3,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
             ,ROW_NUMBER()  OVER (PARTITION BY pc.CPFCNPJ ORDER BY SA.Codigo DESC) AS LastCall
             ,pc.DataArquivo AS DataAtualizacao
       from  [Corporativo].[Marketing].[LastChance] SA 
       inner join dados.propostacliente pc on pc.id = SA.idcliente
       INNER JOIN Dados.ContatoPessoa AS CP ON pc.CPFCNPJ=CP.CPFCNPJ
       WHERE  TelefoneAlternativo IS NOT NULL AND SUBSTRING(TelefoneAlternativo,3,1) NOT IN ('6','7','8','9')
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
		AND ISNUMERIC(Telefone)=1



/*****************************************     INSERE TELEFONE CELULAR DE LAST CHANCE *************************************************************/

;WITH CT AS (
       SELECT 
             CP.ID AS IDContatoPessoa
             , Telefone  
             , 8 AS IDOrigemDadoContato
             , 3 AS Ordem
              , (CASE WHEN SUBSTRING(Telefone,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
             ,ROW_NUMBER()  OVER (PARTITION BY pc.CPFCNPJ ORDER BY SA.codigo DESC) AS LastCall
             ,pc.DataArquivo AS DataAtualizacao
       from  [Corporativo].[Marketing].[LastChance] SA 
       inner join dados.propostacliente pc on pc.id = SA.idcliente
       INNER JOIN Dados.ContatoPessoa AS CP ON pc.CPFCNPJ=CP.CPFCNPJ
       WHERE Telefone IS NOT NULL
       AND SUBSTRING(Telefone,3,1) IN ('6','7','8','9')
 
       union
             SELECT 
             CP.ID AS IDContatoPessoa
             , TelefoneAlternativo  
             , 8 AS IDOrigemDadoContato
             , 3 AS Ordem
             , (CASE WHEN SUBSTRING(TelefoneAlternativo,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
             ,ROW_NUMBER()  OVER (PARTITION BY pc.CPFCNPJ ORDER BY SA.codigo DESC) AS LastCall
             ,pc.DataArquivo AS DataAtualizacao
       from  [Corporativo].[Marketing].[LastChance] SA 
       inner join dados.propostacliente pc on pc.id = SA.idcliente
       INNER JOIN Dados.ContatoPessoa AS CP ON pc.CPFCNPJ=CP.CPFCNPJ
       WHERE TelefoneAlternativo IS NOT NULL
       AND SUBSTRING(TelefoneAlternativo,3,1) IN ('6','7','8','9')

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
      AND ISNUMERIC(Telefone)=1


/*****************************************************************REMOVE LIXO *************************************************************/

delete  FROM Dados.Telefonecontatopessoa where ismobile=0 and substring(telefone,3,1) in ('6','7','8','9');
delete  FROM Dados.Telefonecontatopessoa where telefone like '%999999999%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%888888888%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%777777777%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%666666666%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%555555555%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%444444444%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%333333333%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%222222222%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%111111111%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%000000000%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%988888888%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%987654321%';
delete  FROM Dados.Telefonecontatopessoa where telefone like '%*%';
delete  FROM Dados.Telefonecontatopessoa where substring(telefone,1,1) = 0;
delete  FROM Dados.Telefonecontatopessoa where substring(telefone,2,1) = 0;

/************************************************	Ajusta nono dígito ********************************************************************/

Update Dados.TelefoneContatoPessoa SET Telefone=LEFT(Telefone,2) + '9' +RIGHT(Telefone,8) WHERE IsMobile=1 and len(telefone)=10;


/************************************************Deletar Emails Repetidos********************************************************************/

;WITH RepEmail as (
			SELECT	EP.ID,
					EP.IDContatoPessoa, 
					EP.Email,
					ROW_NUMBER () OVER (PARTITION BY EP.IDContatoPessoa, EP.Email order by EP.DataAtualizacao desc) ROW
			FROM Dados.EmailContatoPessoa EP
)
Delete tcp
FROM Dados.EmailContatoPessoa tcp
INNER JOIN RepEmail on tcp.ID = RepEmail.ID
where RepEmail.row > 1

/************************************************Deletar Telefones Repetidos********************************************************************/

;With Rep as (
			select	ID,
					IDcontatoPessoa,
					Telefone,
					ROW_NUMBER () OVER (partition by IDContatoPessoa, Telefone order by ordem) as ROW
			from Dados.TelefoneContatoPessoa 
)

Delete tcp
FROM Dados.TelefoneContatoPessoa tcp
INNER JOIN Rep on tcp.ID = rep.ID
where rep.row > 1

/********************************************************************************************************************************************/

delete  FROM Dados.Telefonecontatopessoa where len(telefone)<10;
delete  FROM Dados.Telefonecontatopessoa where len(telefone)>11;

--Acrescentado por Raiane. Retirar os telefones celulares, onde o nono dígito for diferente de 9
delete  FROM Dados.Telefonecontatopessoa where ismobile=1 and substring(telefone,3,1) <> '9';


/****************************************************DELETA TELEFONES QUE ESTÃO NA BLACKLIST **************************************************/

DELETE TP
FROM Dados.Telefonecontatopessoa TP
INNER JOIN Dados.ContatoPessoa CP ON TP.IDContatoPessoa = CP.ID
INNER JOIN Dados.BlackListTelefone BT ON CP.CPFCNPJ_AS = BT.CPFContato COLLATE SQL_Latin1_General_CP1_CI_AI AND TP.Telefone = BT.Telefone 











