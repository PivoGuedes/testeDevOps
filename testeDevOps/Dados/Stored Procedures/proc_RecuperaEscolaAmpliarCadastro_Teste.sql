
CREATE PROCEDURE [Dados].[proc_RecuperaEscolaAmpliarCadastro_Teste]
      
AS

WITH CTE
AS
(
SELECT 
f.CPF
, f.Nome
, f.Email
, f.DataAdmissao
, f.DataNascimento
, s.descricao
, cc.codigo
, e.Nome AS NomeEmpresa
, cp.Codigo AS CodigoCargo
, ec.[CodigoEstadoCivilPROPAY] AS [CodigoEstadoCivilPROPAY]
, ROW_NUMBER() OVER(PARTITION BY F.CPF, E.Nome ORDER BY F.DataAdmissao DESC, ISNULL (F.dataultimasituacaofuncionario,'1900-01-01') DESC) [ORDEM]
--, ROW_NUMBER() OVER(PARTITION BY F.Nome, F.CPF ORDER BY F.DataAdmissao DESC, ISNULL (F.dataultimasituacaofuncionario,'1900-01-01') DESC) [ORDEM]

FROM [Dados].[Funcionario] f
inner join Dados.Empresa e
on f.IDEmpresa = e.ID
inner join Dados.CentroCusto CC
on f.IDCentroCusto = cc.ID
inner join Dados.CargoPROPAY cp
on f.IDCargoPROPAY = cp.ID
--and f.idempresa = e.ID

--inner join ##testeCArgoPropay cp
--on f.IDCargoPROPAY = cp.ID
--and f.idempresa = e.ID

inner join dados.Sexo s
on f.IDSexo = s.ID
inner join dados.EstadoCivil ec
on ec.ID = f.idestadocivil
--WHERE EXISTS (SELECT * FROM Dados.EscolaAmpliarCentroCusto EAC WHERE EAC.IDCentroCusto = CC.ID  AND ((EAC.DataExclusão IS NOT NULL AND EAC.DataExclusão <= Cast(getdate() as date)) OR EAC.DataExclusão IS NULL))
WHERE EXISTS (	SELECT *
				FROM Dados.SituacaoFuncionario AS SF
				WHERE SF.ID=F.IDUltimaSituacaoFuncionario
				AND SF.Descricao IN (	'ATIVIDADE NORMAL',
										'ATIVIDADE NORMAL PRO LABORE',
										'ESTAGIARIO',
										'ESTAGIARIO EM RECESSO',
										'FERIAS NORMAIS',
										'FERIAS NOR COM AB PECUNIARIO'))
AND CC.Codigo IS NOT NULL 
AND CC.Codigo <> '.'
AND CC.Codigo <> ''

)
SELECT 
NOME UserName
--, RIGHT('00000000000' + Cast(Cast(replace(replace(CPF,'.',''),'-','') as bigint) as varchar(11)),11) [Password]
, left(Descricao,1) [Gender]
, SUBSTRING(NOME, 1, CHARINDEX(' ', NOME) -1 ) [DisplayName]
--, 247 [CountryID]
--, 'pt-BR' [CultureName]
--, '1' [TimeZoneID]
, EMAIL [Email]
, [CodigoEstadoCivilPROPAY] [MaritialStatusID]
, convert(varchar(10),DATANASCIMENTO,103) [Birthdate]
--,cast(REPLACE(DATANASCIMENTO,'-','')as varchar(8)) Birthdate,
, 99 [CorpID]
, CODIGO [DepartmentID]
, CodigoCargo [PositionID]
, 'Parceiros' [PreferredPortal]
, /*FUCPF [ManagerID],*/ RIGHT('00000000000' + Cast(Cast(replace(replace(CPF,'.',''),'-','') as bigint) as varchar(11)),11) [UsuarioCPF]
--, CTE.NomeEmpresa [DescricaoEmpresa]
, convert(varchar(10),DATAADMISSAO,103) DataAdmissao
, 'PAR' [Dominio]
--, MAX(convert(varchar(10),DATAADMISSAO,103)) DATAADMISSAO
--cast(REPLACE(DATAADMISSAO,'-','')as varchar(8)) as DATAADMISSAO

FROM CTE
WHERE ORDEM = 1 
AND CTE.NomeEmpresa = 'PAR Corretora' 
--AND NOT (CTE.EMAIL IS NULL OR CTE.EMAIL = '')
