
CREATE PROCEDURE [Dados].[proc_RecuperaEscolaAmpliarDepartamento]
      
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
,ec.[CodigoEstadoCivilPROPAY] AS [CodigoEstadoCivilPROPAY]
,CC.Codigo AS CodigoCentroCusto
,CC.Descricao AS DescricaoCentroCusto
,ROW_NUMBER() OVER(PARTITION BY F.CPF, E.Nome ORDER BY F.dataultimasituacaofuncionario DESC) [ORDEM]
--,ROW_NUMBER() OVER(PARTITION BY F.Nome, F.CPF ORDER BY F.dataultimasituacaofuncionario DESC) [ORDEM]

FROM [Dados].[Funcionario] f
INNER JOIN Dados.Empresa e
ON f.IDEmpresa = e.ID
INNER JOIN Dados.CentroCusto CC
ON f.IDCentroCusto = cc.ID
INNER JOIN Dados.CargoPROPAY cp
ON f.IDCargoPROPAY = cp.ID

--inner join ##testeCArgoPropay cp
--on f.IDCargoPROPAY = cp.ID
--and f.idempresa = e.ID

INNER JOIN dados.Sexo s
ON f.IDSexo = s.ID
INNER JOIN dados.EstadoCivil ec
ON ec.ID = f.idestadocivil

--WHERE EXISTS (SELECT * FROM Dados.EscolaAmpliarCentroCusto EAC WHERE EAC.IDCentroCusto = CC.ID AND ((EAC.DataExclusão IS NOT NULL AND EAC.DataExclusão <= Cast(getdate() as date)) OR EAC.DataExclusão  IS NULL))  
WHERE EXISTS (SELECT * FROM Dados.SituacaoFuncionario AS SF WHERE SF.ID=F.IDUltimaSituacaoFuncionario
		AND SF.Descricao IN (  'ATIVIDADE NORMAL',
								'ATIVIDADE NORMAL PRO LABORE',
								'ESTAGIARIO',
								'ESTAGIARIO EM RECESSO',
								'FERIAS NORMAIS',
								'FERIAS NOR COM AB PECUNIARIO'))

)
SELECT DISTINCT
99 [CORP]
, CODIGOCENTROCUSTO [CODIGODEPARTAMENTO]
, DescricaoCentroCusto [DESCRICAO]
FROM CTE
WHERE ORDEM = 1
--AND CTE.NomeEmpresa = 'PAR Corretora' 
AND CTE.NomeEmpresa in ('PAR Corretora', 'FINANSEG ADMINISTRACAO E CORRETAGEM DE SEGUROS LTDA')
and cte.CodigoCentroCusto IS NOT NULL
and cte.CodigoCentroCusto <> '.'
and cte.CodigoCentroCusto <> ''
--AND NOT (EMAIL IS NULL OR EMAIL = '')

