


CREATE FUNCTION [Mailing].[fn_RecuperaClienteExclusivo] (@CPF VARCHAR(20))
RETURNS @MAILING TABLE
   (
    Nome VARCHAR(120),
	CPF VARCHAR(20),
	Matricula VARCHAR(20),
	Telefone1 VARCHAR(20),
	Telefone2 VARCHAR(20),
	Telefone3 VARCHAR(20),
	Telefone4 VARCHAR(20),
	Email VARCHAR(80),
	Funcao VARCHAR(80),
	EstadoCivil VARCHAR(30),
	Area VARCHAR(50),
	Agencia VARCHAR(4),
	Lotacao VARCHAR(60),
	DataNascimento DATE,
	ProdutoGCS VARCHAR(60)
   )
WITH EXECUTE AS 'usrDWLinked'
AS    
--drop table #TEMP_CRM
--DECLARE @CPF VARCHAR(20) = '928.999.941-15'
BEGIN

	--CREATE TABLE [dbo].[TEMP_CRM](
	--	[Nome] [nvarchar](255) NULL,
	--	[CPFCNPJ] [varchar](18) NULL,
	--	[CodigoBloco] [varchar](2) NULL,
	--	[Produto] [varchar](100) NULL,
	--	[Email] [nvarchar](255) NULL,
	--	[DataNascimento] [date] NULL,
	--	[IDAgenciaCliente] [smallint] NULL,
	--	[IDProduto] [int] NULL,
	--	[Telefone] [varchar](20) NULL,
	--	[IDCargo] [smallint] NULL,
	--	[IDCargoPROPAY] [smallint] NULL,
	--	[IDUltimaFuncao] [smallint] NULL,
	--	[IDIndicadorArea] [tinyint] NULL,
	--	[LINHATE] [bigint] NULL,
	--	[LINHAPRODUTO] [bigint] NULL
	--) ON [Dados]

	--CREATE CLUSTERED INDEX IDX_TEMP_CRM ON [dbo].[TEMP_CRM]
	--(
	--  CPFCNPJ
	--)
--DECLARE @CPF VARCHAR(20) = '928.999.941-15'

	;WITH CTE
	AS
	(
	SELECT DISTINCT PC.Nome, PC.Matricula, PC.CPFCNPJ, RP.Codigo [CodigoBloco], RP.Nome [NomeBloco], COALESCE(PC.Email, A.EMail) EMail, PC.DataNascimento, PRP.IDAgenciaVenda [IDAgenciaCliente], PRP.IDProduto
	  , CASE WHEN PC.DDDTelefone = '' OR PC.DDDTelefone IS NULL THEN '0' ELSE REPLACE(REPLACE(REPLACE(PC.DDDTelefone, '-', ''), ' ', ''),'.','') END DDDTelefone
	  , CASE WHEN PC.Telefone = '' OR PC.Telefone IS NULL THEN '0' ELSE  REPLACE(REPLACE(REPLACE(PC.Telefone, '-', ''), ' ', ''),'.','') END Telefone
	  , A.IDCargo, A.IDCargoPROPAY, A.IDUltimaFuncao, A.IDUltimaUnidade, A.IDIndicadorArea, A.IDEstadoCivil, Prioriza

	  FROM 
	  	   (
			SELECT TOP 1 F.IDCargo, F.IDCargoPROPAY, F.IDUltimaFuncao, F.IDUltimaUnidade, F.IDIndicadorArea, Email, IDEstadoCivil
			FROM Dados.Funcionario F
			WHERE F.CPF = @CPF --REPLACE(REPLACE(@CPF,'.',''), '-', '')
			AND (F.IDUltimaSituacaoFuncionario IS NOT NULL AND F.IDUltimaSituacaoFuncionario NOT IN (4, 5, 6, 13, 14, 15, 16, 17, 18, 29, 30, 34, 35, 36, 37, 38))
			ORDER BY DataAdmissao DESC, DataUltimaSituacaoFuncionario DESC
			) A	    
		CROSS APPLY
	     
		 (
		   SELECT PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.Matricula, PC.DataNascimento, COALESCE(PC.Email, PC.Emailcomercial) Email, PC.DDDResidencial [DDDTelefone], REPLACE(REPLACE(REPLACE(PC.TelefoneResidencial,'.',''),'-',''),' ','') [Telefone], 1 Prioriza
		   FROM Dados.PropostaCliente PC WITH(NOLOCK) 
		   WHERE PC.CPFCNPJ = @CPF

		   UNION ALL 
		   SELECT PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.Matricula, PC.DataNascimento, COALESCE(PC.Emailcomercial, PC.Email) Email, PC.DDDComercial [DDDTelefone], REPLACE(REPLACE(REPLACE(PC.TelefoneComercial,'.',''),'-',''),' ','') [Telefone], 1 Prioriza 
		   FROM Dados.PropostaCliente PC WITH(NOLOCK)  --WHERE TelefoneResidencial LIKE '%2242438%'
		   WHERE PC.CPFCNPJ = @CPF
    
		   UNION ALL
		   SELECT  PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.Matricula, PC.DataNascimento, NULL Email, PC.DDDFax [DDDTelefone], REPLACE(REPLACE(REPLACE(PC.TelefoneFax,'.',''),'-',''),' ','') [Telefone], 1 Prioriza 
		   FROM Dados.PropostaCliente PC WITH(NOLOCK) 
		   WHERE PC.CPFCNPJ = @CPF
     
		   UNION ALL
		   SELECT  PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.Matricula, PC.DataNascimento, NULL Email, PC.DDDCelular [DDDTelefone], REPLACE(REPLACE(REPLACE(PC.TelefoneCelular,'.',''),'-',''),' ','') [Telefone], 1 Prioriza 
		   FROM Dados.PropostaCliente PC WITH(NOLOCK)
		   WHERE PC.CPFCNPJ = @CPF
     
		   UNION ALL


		   SELECT NULL IDProposta, MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI Nome,  CleansingKit.dbo.fn_FormataCPF([CPFCNPJ] COLLATE SQL_Latin1_General_CP1_CI_AI) [CPFCNPJ], Cast(MC.Matricula as varchar(20)) COLLATE SQL_Latin1_General_CP1_CI_AI Matricula, MC.DataNascimento, [EmailPessoal] COLLATE SQL_Latin1_General_CP1_CI_AI [EmailPessoal], Cast(Cast([DDDResidencial] as int) as varchar(3)) COLLATE SQL_Latin1_General_CP1_CI_AI [DDDResidencial]
		          --, Cast(Cast(REPLACE(REPLACE(REPLACE([TelefoneResidencial],'.',''),'-',''),' ','') as bigint) as varchar(10)) COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]
				  , Cast(Cast([TelefoneResidencial] as bigint) as varchar(10)) COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]
				  , 1 Prioriza
		   FROM DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC WITH(NOLOCK)
		   WHERE  MC.CPFCNPJ  = Cast(REPLACE(REPLACE(@CPF,'.',''), '-', '') as nvarchar(255))

		   UNION  ALL  
	   
		   SELECT TOP 1 NULL IDProposta, F.Nome, F.CPF, F.Matricula, F.DataNascimento, F.Email, CASE WHEN LEN(F.DDDCelular) = 9 THEN LEFT(REPLACE(REPLACE(F.DDDCelular, '(', ''), ')', ''),2) ELSE F.DDDCelular END DDDCelular, RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(F.Celular, '(', ''), ')', ''),'.',''),'-',''),' ',''),9), 0 Prioriza
		   FROM Dados.Funcionario F
		   WHERE F.CPF =  @CPF
		   ORDER BY DataAdmissao DESC, DataUltimaSituacaoFuncionario DESC
		
		   UNION  ALL  
	   
		   SELECT TOP 1 NULL IDProposta, F.Nome, F.CPF, F.Matricula, F.DataNascimento, F.Email, CASE WHEN LEN(F.DDD) = 9 THEN LEFT(REPLACE(REPLACE(F.DDD, '(', ''), ')', ''),2) ELSE F.DDD END DDD, RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(F.Telefone, '(', ''), ')', ''),'.',''),'-',''),' ',''),9), 0 Prioriza
		   FROM Dados.Funcionario F
		   WHERE F.CPF =  @CPF --'010.697.461-00'
		   ORDER BY DataAdmissao DESC, DataUltimaSituacaoFuncionario DESC	    

		) PC 
	   LEFT JOIN Dados.Proposta PRP WITH(NOLOCK)
	   ON PRP.ID = PC.IDProposta
	   LEFT JOIN Dados.Produto PRD WITH(NOLOCK)
	   ON PRP.IDProduto = PRD.ID
	   LEFT JOIN Dados.RamoPAR RP WITH(NOLOCK)
	   ON RP.ID = PRD.IDRamoPAR

	)-- select * from cte
	,
	CTE1
	AS
	(
	SELECT 
		  CTE.Nome,
		  CTE.CPFCNPJ,
		  CTE.Matricula,
		  CTE.CodigoBloco,
		  RM.Nome [Produto],
		  CTE.Email,
		  CTE.DataNascimento,
		  CTE.IDAgenciaCliente,
		  CTE.IDProduto,
		  [Dados].[fn_TrataNumeroTelefone](CTE.DDDTelefone, CTE.Telefone) Telefone,
		  CTE.IDCargo,
		  CTE.IDCargoPROPAY,
		  CTE.IDUltimaFuncao,
		  CTE.IDUltimaUnidade,
		  CTE.IDIndicadorArea,
		  CTE.IDEstadoCivil
		, ROW_NUMBER() OVER (PARTITION BY CTE.CPFCNPJ ORDER BY CTE.Prioriza ASC, Case WHEN LEFT(Cast(Cast(CASE WHEN CTE.Telefone = '' OR CTE.Telefone IS NULL THEN 0 ELSE REPLACE(CTE.Telefone, '-', '') END as bigint) as varchar(10)),1) IN (1,2,3,4,5,6) THEN 1 ELSE 2 END, CTE.Telefone) [LINHATE]
		, ROW_NUMBER() OVER (PARTITION BY  CTE.CPFCNPJ ORDER BY RM.Nome DESC ) [LINHAPRODUTO]
     
	FROM CTE WITH(NOLOCK)
	 LEFT JOIN Dados.Produto P WITH(NOLOCK)
	 ON P.ID = CTE.IDProduto
	 OUTER APPLY (SELECT * FROM Dados.fn_RecuperaRamoPAR_Mestre(P.IDRamoPAR) RM) RM
	 )
	 --INSERT INTO dbo.TEMP_CRM
	 --SELECT *
	 --FROM CTE1
	 --OPTION(MAXDOP  4);



	INSERT INTO @MAILING  (Nome,
						CPF,
						Matricula,
						Telefone1,
						Telefone2,
						Telefone3,
						Telefone4,
						Email,
						DataNascimento,
						ProdutoGCS,
						Area,
						Funcao,
						EstadoCivil,
						Agencia,
						Lotacao
						)
	SELECT 
		  A.Nome
		, A.CPFCNPJ 
		, A.Matricula
		, ISNULL(A1.Telefone, '') Telefone1

		, ISNULL(A2.Telefone, '') Telefone2

		, ISNULL(A3.Telefone, '') Telefone3  

		, ISNULL(A4.Telefone, '') Telefone4  

		, ISNULL(A.Email, '') Email
		, A.DataNascimento
		, REPLACE(ISNULL(RM1.Produto1 + ',','') +  ISNULL(RM2.Produto2 + ',','')  +  ISNULL(RM3.Produto3  + ',','')  +  ISNULL(RM4.Produto4 + ',' ,'') +  ISNULL(RM5.Produto5 + ',','') + ISNULL(RM6.Produto6 + ',' ,'') + ' ', ', ', '') [Produtos GCS]
		--, F.Matricula [IndicadorCaixa]
		--, A.IDCargo, A.IDCargoPROPAY, A.IDUltimaFuncao, A.IDUltimaUnidade, A.IDIndicadorArea
		, IA.Descricao [IDIndicadorArea]
		, COALESCE(F.Descricao, C.Cargo, CP.Descricao) Funcao
		, EC.Descricao [EstadoCivil]
		, U.Codigo [CodigoAgencia]
		, L.Codigo [CodigoLotacao]
	FROM CTE1 A
	OUTER APPLY (SELECT TOP 1  A1.Telefone Telefone, ISNULL(A1.LINHATE,0) LINHATE
		FROM CTE1 A1
		WHERE A1.CPFCNPJ = A.CPFCNPJ
		--AND A1.LINHATE = 1

		AND A1.Telefone IS NOT NULL
		ORDER BY A1.LINHATE, A1.Telefone) A1
	OUTER APPLY (SELECT TOP 1 A2.Telefone Telefone, A2.LINHATE
		FROM CTE1 A2
		WHERE A2.CPFCNPJ = A.CPFCNPJ
		--AND A2.LINHATE = 2
		AND ISNULL(A2.LINHATE,1) > ISNULL(A1.LINHATE,0)
		AND ISNULL(A2.Telefone,0) <> ISNULL(A1.Telefone,0)
		AND A2.Telefone IS NOT NULL      
	ORDER BY A2.LINHATE, A2.Telefone
		) A2
	OUTER APPLY (SELECT TOP 1 A3.Telefone Telefone, A2.LINHATE
		FROM CTE1 A3
		WHERE A3.CPFCNPJ = A.CPFCNPJ
		--AND A2.LINHATE = 2
		AND ISNULL(A3.LINHATE,1) > ISNULL(A2.LINHATE,0)      
		AND ISNULL(A3.Telefone,0) <> ISNULL(A1.Telefone,0)
		AND ISNULL(A3.Telefone,0) <> ISNULL(A2.Telefone,0)
		AND A3.Telefone IS NOT NULL      
		ORDER BY A3.LINHATE, A3.Telefone
		) A3
OUTER APPLY (SELECT TOP 1 A4.Telefone Telefone, A4.LINHATE
	FROM CTE1 A4
	WHERE A4.CPFCNPJ = A.CPFCNPJ
	--AND T2.LINHATE = 2
	AND ISNULL(A4.LINHATE,1) > ISNULL(A3.LINHATE,0)      
	AND ISNULL(A4.Telefone,0) <> ISNULL(A1.Telefone,0)
	AND ISNULL(A4.Telefone,0) <> ISNULL(A2.Telefone,0)
	AND ISNULL(A4.Telefone,0) <> ISNULL(A3.Telefone,0)
	AND A4.Telefone IS NOT NULL      
	ORDER BY A4.LINHATE, A4.Telefone
	) A4
	OUTER APPLY (SELECT TOP 1 A1.Produto [Produto1], A1.[LINHAPRODUTO]
		FROM CTE1 A1
		WHERE A1.CPFCNPJ = A.CPFCNPJ
		AND A1.Produto IS NOT NULL
		ORDER BY [LINHAPRODUTO]
		) RM1
	OUTER APPLY (SELECT TOP 1 A2.Produto [Produto2], A2.[LINHAPRODUTO]
		FROM CTE1 A2
		WHERE A2.CPFCNPJ = A.CPFCNPJ
		AND A2.Produto IS NOT NULL
		--AND A2.LINHAPRODUTO = 2
		AND A2.[LINHAPRODUTO] > RM1.[LINHAPRODUTO]
		AND A2.Produto <> RM1.Produto1
		) RM2
	OUTER APPLY (SELECT TOP 1 A3.Produto [Produto3], A3.[LINHAPRODUTO]
		FROM CTE1 A3
		WHERE A3.CPFCNPJ = A.CPFCNPJ
		AND A3.Produto IS NOT NULL
		--AND A3.LINHAPRODUTO = 3
		AND A3.[LINHAPRODUTO] > RM2.[LINHAPRODUTO]
		AND A3.Produto <> RM2.Produto2
		ORDER BY [LINHAPRODUTO]
		) RM3
	OUTER APPLY (SELECT TOP 1 A4.Produto [Produto4], A4.[LINHAPRODUTO]
		FROM CTE1 A4
		WHERE A4.CPFCNPJ = A.CPFCNPJ
		AND A4.Produto IS NOT NULL
		--AND A4.LINHAPRODUTO = 4
		AND A4.[LINHAPRODUTO] > RM3.[LINHAPRODUTO]
		AND A4.Produto <> RM3.Produto3
		ORDER BY [LINHAPRODUTO]
		) RM4
	OUTER APPLY (SELECT TOP 1 A5.Produto [Produto5], A5.[LINHAPRODUTO]
		FROM CTE1 A5
		WHERE A5.CPFCNPJ = A.CPFCNPJ
		AND A5.Produto IS NOT NULL
		--AND A5.LINHAPRODUTO = 5
		AND A5.[LINHAPRODUTO] > RM4.[LINHAPRODUTO]
		AND A5.Produto <> RM4.Produto4
		ORDER BY [LINHAPRODUTO]
		) RM5
	OUTER APPLY (SELECT TOP 1 A6.Produto [Produto6]
		FROM CTE1 A6
		WHERE A6.CPFCNPJ = A.CPFCNPJ
		AND A6.Produto IS NOT NULL
		--AND A6.LINHAPRODUTO = 6
		AND A6.[LINHAPRODUTO] > RM5.[LINHAPRODUTO]
		AND A6.Produto <> RM5.Produto5
		ORDER BY [LINHAPRODUTO]
		) RM6
	LEFT JOIN Dados.IndicadorArea IA
	ON IA.ID = A.IDIndicadorArea
	LEFT JOIN Dados.Cargo C
	ON C.ID = A.IDCargo
	LEFT JOIN Dados.CargoPROPAY CP
	ON CP.ID = A.IDCargoPROPAY
	LEFT JOIN Dados.Funcao F
	ON F.ID = A.IDUltimaFuncao
	LEFT JOIN Dados.EstadoCivil EC
	ON EC.ID = A.IDEstadoCivil
	LEFT JOIN Dados.Unidade U
	ON U.ID = A.IDAgenciaCliente
	LEFT JOIN Dados.Unidade L
	ON L.ID = A.IDUltimaUnidade
	WHERE A.LINHATE = 1
  RETURN
 END
 --AND NOT (A1.Telefone IS NULL AND A2.Telefone IS NULL AND A3.Telefone IS NULL AND A4.Telefone IS NULL)


