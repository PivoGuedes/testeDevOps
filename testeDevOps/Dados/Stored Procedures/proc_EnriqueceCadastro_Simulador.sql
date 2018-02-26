CREATE PROCEDURE [Dados].[proc_EnriqueceCadastro_Simulador]
AS

/*****************************************		INSERE CPFCNPJ DAS SIMULAÇÕES DE AUTO   *************************************************************/
	
INSERT INTO Dados.ContatoPessoa (CPFCNPJ)
SELECT DISTINCT SA.CPFCNPJ
FROM Dados.SimuladorAuto AS SA
OUTER APPLY (SELECT CPFCNPJ FROM Dados.ContatoPessoa AS C WHERE C.CPFCNPJ=SA.CPFCNPJ) AS CP
WHERE TelefoneContato IS NOT NULL
AND CP.CPFCNPJ IS NULL
AND SA.CPFCNPJ IS NOT NULL
AND SA.DataArquivo>=CAST(DATEADD(D,-4,GETDATE()) AS DATE)
/*****************************************						INSERE TELEFONE FIXO DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 4 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL)
	AND SA.DataArquivo>=CAST(DATEADD(D,-4,GETDATE()) AS DATE)

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
where LastCall = 1
AND IsMobile=0

/*****************************************						INSERE TELEFONE CELULAR DE SIMULAÇÃO AUTO *************************************************************/

;WITH CT AS (
	SELECT 
		CP.ID AS IDContatoPessoa
		, (CAST(CAST(DDDTelefoneContato AS INT) AS VARCHAR(2)) + CAST(CAST(TelefoneContato AS BIGINT) AS VARCHAR(12))) AS Telefone
		, 4 AS IDOrigemDadoContato
		, 4 AS Ordem
		, (CASE WHEN SUBSTRING(TelefoneContato,1,1) IN ('6','7','8','9') THEN '1' ELSE '0' END) AS IsMobile
		,ROW_NUMBER()  OVER (PARTITION BY SA.CPFCNPJ ORDER BY SA.DataArquivo DESC) AS LastCall
		,SA.DataArquivo AS DataAtualizacao
	FROM  Dados.SimuladorAuto AS SA
	INNER JOIN Dados.ContatoPessoa AS CP
		ON SA.CPFCNPJ=CP.CPFCNPJ
	WHERE (DDDTelefoneContato IS NOT NULL AND TelefoneContato IS NOT NULL)
	AND SA.DataArquivo>=CAST(DATEADD(D,-4,GETDATE()) AS DATE)

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
where LastCall = 1
AND IsMobile=1



delete  FROM Dados.Telefonecontatopessoa where ismobile=0 and substring(telefone,3,1) in ('7','8','9')
delete  FROM Dados.Telefonecontatopessoa where telefone like '%*%'
delete  FROM Dados.Telefonecontatopessoa where len(telefone)<10
