

/*
	Autor: Egler Vieira
	Data Criação: 27/07/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[proc_RecuperaHierarquia_Rede_PGC]
	Descrição: Proc que retorna a última posição da hierarquia da rede
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_RecuperaHierarquia_Rede_PGC]
AS

------------------------------------------------------------------
--HARDCODED ADICIONADO PARA INCLUIR ALGUNS FUNCIONÁRIOS QUE NÃO FAZEM PARTE DA REDE
------------------------------------------------------------------


SELECT *
FROM Dados.fn_RecuperaFuncionariosRede() FR
UNION ALL
SELECT   F.Nome
, C.Descricao [Cargo]
--, C2A.Cargo1
, S.Descricao [Sexo]
, NULL CodigoUnidade
, NULL [NomeUnidade]
, F.UF UFMunicipio
, F.Municipio NomeMunicipio
, F.DDD
, NULL Telefone
, RIGHT(F.Matricula,6) Matricula
, NULL MatriculaSuperior
, NULL MatriculaP
, F.CPF
, F.Email
, F.DataNascimento
, Cast(getdate() -1 as date)DataHierarquia
, NULL [RegiaoRede]
, NULL IDTipoVaga
, NULL IDTipoRegiao
FROM Dados.Funcionario f
INNER JOIN Dados.CargoPROPAY C
ON F.IDCargoPROPAY = C.ID--CargoPROPAY
INNER JOIN Dados.Sexo S
ON F.IDSexo = S.ID
WHERE F.IDEmpresa = 3
AND CPF IN( '432.422.270-34',
			'943.936.137-91',
			'109.968.287-88',
			'041.527.126-60',
			'193.908.148-39',
			'885.653.941-15',
			'025.155.903-30',
			'006.439.871-42',
			'015.262.761-86',
			'004.435.891-19',
			'148.171.728-60',
			'066.935.276-47',
			'337.978.648-92')

			--'432.422.270-34',
			--'193.908.148-39',
			--'148.171.728-60',
			--'943.936.137-91',
			--'066.935.276-47',
			--'041.527.126-60',
			--'109.968.287-88',
			--'025.155.903-30',
			--'015.262.761-86',
			--'006.439.871-42',
			--'885.653.941-15',
			--'004.435.891-19')
----------------------------------------------------------------------
ORDER BY  FR.RegiaoRede, FR.IDTipoRegiao, FR.IDTipoVaga, FR.Cargo, FR.Matricula, FR.[NomeUnidade]


--)

--SELECT NOME, CARGO, MATRICULA, /*MATRICULASUPERIOR,*/ COUNT(*) AS QTD
--FROM CTE_BRUNO
--WHERE NOME = 'GV CENTRO OESTE 03'
--GROUP BY NOME, CARGO, MATRICULA--, MATRICULASUPERIOR
--HAVING COUNT(*) > 1
--ORDER BY 1


--GV CENTRO OESTE 03
--GV CENTRO OESTE 04
--GV RIO GRANDE DO SUL - SANTA CATARINA 03
--GV RIO GRANDE DO SUL - SANTA CATARINA 01
--GV SAO PAULO 03
--GV SAO PAULO 06

