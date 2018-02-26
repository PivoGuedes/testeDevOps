CREATE FUNCTION Dados.fn_RecuperaFuncionariosRede()
RETURNS TABLE
AS
RETURN
WITH CTE
AS
(
	SELECT 
	      CASE WHEN (RR.IDTipoRegiao = 4 OR HR.IDTipoVaga <> -1) AND F.Nome IS NULL THEN 'POSIÇÃO VAGA' 		      
		  ELSE COALESCE(F.Nome, RR.Nome)
		  END Nome
		, CASE  WHEN (RR.IDTipoRegiao = 4 OR RR.IDTipoRegiao = 3) AND  HR.IDTipoVaga <> -1 THEN 'ASSISTENTE DE VENDAS'
				WHEN RR.IDTipoRegiao = 3 and HR.IDTipoVaga = -1 THEN 'GERENTE DE VENDAS'
				WHEN RR.IDTipoRegiao = 2 THEN 'GERENTE REGIONAL'
				WHEN RR.IDTipoRegiao = 1 THEN 'SUPERINTENDENTE COMERCIAL REDE'
		  END [Cargo]	
		--, RTRIM(LTRIM(CP.Descricao)) [Cargo1]
		, RTRIM(LTRIM(S.Descricao)) [Sexo]
		--, U.Codigo
		, CASE WHEN U.Codigo = -1 THEN NULL ELSE U.Codigo END CodigoUnidade
		, RTRIM(LTRIM(CASE WHEN U.Codigo = -1 THEN NULL ELSE U.Nome END)) [NomeUnidade]
		, RTRIM(LTRIM(U.UFMunicipio)) UFMunicipio
		, RTRIM(LTRIM(U.NomeMunicipio)) NomeMunicipio
		, RTRIM(LTRIM(U.DDD)) DDD
		, RTRIM(LTRIM(COALESCE(Telefone1, Telefone2))) Telefone
		, CASE  WHEN (RR.IDTipoRegiao = 4 OR RR.IDTipoRegiao = 3) AND  HR.IDTipoVaga <> -1 THEN RIGHT(F.Matricula,6)
		    ELSE COALESCE(RIGHT(F.Matricula,6), '-' + RIGHT('00000' + Cast(HR.IDRegiaoRede  as varchar(5)),5))
		  END Matricula

		, CASE  WHEN (RR.IDTipoRegiao = 4 OR RR.IDTipoRegiao = 3) AND  HR.IDTipoVaga <> -1 THEN RIGHT(FS.Matricula,6)
		    ELSE COALESCE(RIGHT(FS.Matricula,6), '-' + RIGHT('00000' + Cast(HR.IDRegiaoRedeSuperior  as varchar(5)),5))
		  END  MatriculaSuperior
		, '' MatriculaP
		, RTRIM(LTRIM(F.CPF)) CPF
		, RTRIM(LTRIM(F.Email)) Email
		, F.DataNascimento
		, HR.DataRegistro DataHierarquia
	--	, HR.[IDRegiaoRede]r
	--	, HR.[IDRegiaoRedeSuperior]
	--	, HR.idtipovaga
	    , RR.Nome [RegiaoRede]
		--, HR.
		, RR.IDTipoRegiao
		, HR.IDTipoVaga
		, HR.IDRegiaoRede
		, HR.IDRegiaoRedeSuperior
		--, F.ID
		--, 'A' T
	FROM Dados.HierarquiaRede HR
	LEFT JOIN Dados.vw_Unidade U
	ON U.IDUnidade = HR.IDUnidade
	LEFT JOIN Dados.Funcionario F
	ON HR.IDFuncionario = F.ID
	LEFT JOIN Dados.Sexo S
	ON F.IDSexo = S.ID
	LEFT JOIN Dados.CargoPropay CP
	ON CP.ID = F.IDCargoPropay
	LEFT JOIN Dados.RegiaoRede RR
	ON RR.ID = HR.IDRegiaoRede
	OUTER APPLY (
	             SELECT TOP 1 FS.Matricula
				 FROM Dados.HierarquiaRede HRS
				 INNER JOIN Dados.Funcionario FS
					ON HRS.IDFuncionario = FS.ID
						--and  HR.IDRegiaoRedeSuperior = HRS.IDRegiaoRede
						--		  AND HR.DataHierarquia = HRS.DataHierarquia  	

				 WHERE 1 = CASE WHEN (HR.IDTipoVaga = -1 AND
				 --                    
									  HR.IDRegiaoRedeSuperior = HRS.IDRegiaoRede
								  AND HR.DataHierarquia = HRS.DataHierarquia  	
								     ) THEN 1
								WHEN (   
								      HR.IDTipoVaga <> -1				
								  AND HRS.IDTipoVaga = -1					 
								  AND HR.IDRegiaoRede = HRS.IDRegiaoRede
					 		      --AND HR.IDRegiaoRede = HRS.IDRegiaoRede
								  --AND U.Codigo = -1
								  AND HR.DataHierarquia = HRS.DataHierarquia  
									)
								    THEN 1
								ELSE
									0 
					--			END
							END				
				) FS
	LEFT JOIN Dados.RegiaoRede RRS
	ON RRS.ID = HR.IDRegiaoRedeSuperior
	WHERE HR.DataHierarquia >= (SELECT MAX (DATAHIERARQUIA)
								FROM Dados.HierarquiaRede HR)
	AND HR.IDTipoVaga <> 3 --ORDER BY 1
	--AND RR.ID = 11
	--AND F.matricula <> ('000000')
	--AND RR.IDTipoRegiao = 3
--	AND U.Codigo <> -1
--and idfuncionario = 378062
--and hr.idregiaorede in (48,11, 1229)
--AND NOT (CASE WHEN U.Codigo = -1 THEN NULL ELSE U.Codigo END IS NULL AND RIGHT(F.Matricula,6) IS NULL)
)
--,
--CTE1
--AS
--(
--	SE


--)
, CTE2
AS
(
SELECT *
FROM CTE
--WHERE Nome LIKE 'JUS%'
--WHERE RegiaoRede = 'GV MINAS GERAIS 03' --'GV CENTRO OESTE 03' --
UNION  (
	SELECT DISTINCT TUDO.*
	FROM (
	SELECT  DISTINCT B.RegiaoRede Nome
             ,CASE  
					WHEN B.IDTipoRegiao = 3  /* and HR.IDTipoVaga = -1 IMPLICITO*/ THEN 'GERENTE DE VENDAS'
					WHEN B.IDTipoRegiao = 2 THEN 'GERENTE REGIONAL'
					WHEN B.IDTipoRegiao = 1 THEN 'SUPERINTENDENTE COMERCIAL REDE'
			  END [Cargo]	 /*B.Cargo1,*/ 
			  , NULL Sexo, NULL CodigoUnidade, NULL NomeUnidade, NULL UFMunicipio, NULL NomeMunicipio, NULL DDD, NULL Telefone
			  , '-' + RIGHT('00000' + Cast(B.IDRegiaoRede as varchar(5)),5)  Matricula
			  , COALESCE(NULL/*S.Matricula*/, '-' + RIGHT('00000' + Cast(B.IDRegiaoRedeSuperior  as varchar(5)),5)) MatriculaSuperior
			  ,  '' MatriculaP, NULL CPF, NULL Email, NULL DataNascimento
			  , B.DataHierarquia, B.RegiaoRede
			  , B.IDTipoRegiao, -1 IDTipoVaga
			  , B.IDRegiaoRede
			  , B.IDRegiaoRedeSuperior
			  --	  ,B.ID
			  --, 'B' T
		
			FROM CTE B
			--OUTER APPLY ( SELECT Matricula, MatriculaSuperior
			--			  FROM CTE C
			--			  WHERE C.IDRegiaoRede = B.IDRegiaoRedeSuperior AND C.ID = -1) S
			WHERE B.MatriculaSuperior IS NULL
			AND B.IDTipoRegiao <> 1 ) TUDO WHERE TUDO.Nome NOT IN (SELECT DISTINCT NOME FROM CTE)

			--AND B.Matricula = '-00026'
			)
--OUTER APPLY (SELECT 
--where idregiaorede = 5
) --, CTE_BRUNO as (
SELECT 
  C2A.Nome
, C2A.[Cargo]
--, C2A.Cargo1
, C2A.[Sexo]
, C2A.CodigoUnidade
, C2A.[NomeUnidade]
, C2A.UFMunicipio
, C2A.NomeMunicipio
, C2A.DDD
, C2A.Telefone
, C2A.Matricula
, COALESCE(C2A.MatriculaSuperior, C2B.Matricula) MatriculaSuperior
, C2A.MatriculaP
, C2A.CPF
, C2A.Email
, C2A.DataNascimento
, C2A.DataHierarquia
, C2A.[RegiaoRede]
, c2a.IDTipoVaga
, c2a.IDTipoRegiao
--,T
--, ID
FROM CTE2 C2A
OUTER APPLY (SELECT DISTINCT Matricula 
			 FROM CTE2 C2B
			 WHERE C2B.Nome =  C2A.RegiaoRede
			 AND C2A.MatriculaSuperior IS NULL
			 AND C2B.IDTipoVaga = -1
			 ) C2B
			-- where c2a.idtipovaga = -1
			-- AND Matricula IS NOT NULL
where c2a.Nome is not null
--ORDER BY  RegiaoRede, c2a.IDTipoRegiao, c2a.IDTipoVaga, Cargo, Matricula, [NomeUnidade]