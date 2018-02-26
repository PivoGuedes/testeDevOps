CREATE PROCEDURE [Dados].[proc_RecuperaEscolaAmpliarCargo]
      
AS

WITH CTE
AS
(
SELECT 
f.*
, s.descricao
,cc.codigo
,e.Nome AS NomeEmpresa
,cp.Codigo AS CodigoCargo
,cp.Descricao AS DescricaoCargo
, ec.[CodigoEstadoCivilPROPAY] AS [CodigoEstadoCivilPROPAY]
, ROW_NUMBER() OVER(PARTITION BY F.CPF, E.Nome ORDER BY F.dataultimasituacaofuncionario DESC) [ORDEM]
--,ROW_NUMBER() OVER(PARTITION BY F.Nome, F.CPF ORDER BY F.dataultimasituacaofuncionario DESC) [ORDEM]

FROM [Dados].[Funcionario] f
inner join Dados.Empresa e
on f.IDEmpresa = e.ID
inner join Dados.CentroCusto CC
on f.IDCentroCusto = cc.ID
inner join Dados.CargoPROPAY cp
on f.IDCargoPROPAY = cp.ID

--inner join ##testeCArgoPropay cp
--on f.IDCargoPROPAY = cp.ID
--and f.idempresa = e.ID

inner join dados.Sexo s
on f.IDSexo = s.ID
inner join dados.EstadoCivil ec
on ec.ID = f.idestadocivil
WHERE EXISTS (SELECT * FROM Dados.SituacaoFuncionario AS SF WHERE SF.ID=F.IDUltimaSituacaoFuncionario
		AND SF.Descricao IN (  'ATIVIDADE NORMAL',
								'ATIVIDADE NORMAL PRO LABORE',
								'ESTAGIARIO',
								'ESTAGIARIO EM RECESSO',
								'FERIAS NORMAIS',
								'FERIAS NOR COM AB PECUNIARIO'))

--WHERE EXISTS (	SELECT *
--				FROM Dados.EscolaAmpliarCentroCusto EAC
--				WHERE EAC.IDCentroCusto = CC.ID AND ((EAC.DataExclusão IS NOT NULL AND EAC.DataExclusão <= Cast(getdate() as date)) OR EAC.DataExclusão  IS NULL))    


)

SELECT DISTINCT 99 [CORP], CTE.CodigoCargo [CODIGOCARGO], CTE.DescricaoCargo [DESCRICAO]
FROM CTE
WHERE CTE.ORDEM = 1
--AND CTE.NomeEmpresa = 'PAR Corretora' --alteração solicitada por GG para acrescentar FINANSEG
AND CTE.NomeEmpresa in ('PAR Corretora', 'FINANSEG ADMINISTRACAO E CORRETAGEM DE SEGUROS LTDA')
and cte.CodigoCargo IS NOT NULL
and cte.CodigoCargo <> '.'
and cte.CodigoCargo <> ''
--AND NOT (CTE.Email IS NULL OR CTE.Email = '')

