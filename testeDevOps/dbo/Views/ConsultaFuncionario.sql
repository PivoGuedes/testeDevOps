
CREATE VIEW ConsultaFuncionario
as

WITH CTE1
as 
(
SELECT DISTINCT IDUnidade
FROM  Dados.HierarquiaRede HR
WHERE 
HR.DataRegistro = (
        SELECT MAX(DataRegistro)
        FROM  Dados.HierarquiaRede
    ) AND 
HR.IDTipoVaga in (1,2)
) 
, CTE
AS
(
SELECT   F.[ID]
       , F.[Nome]
       , F.[CPF]
       , 'Caixa' as Empresa
       , U.IDUnidade
       , U.Codigo [CodigoUnidade]
       , U.Nome [NomeUnidade]
       , TU.Descricao TipoUnidade
       , F.[Matricula] as MatriculaDV
	   , case when sf.Codigo = 1 then 'Não' else 'Sim' end as Desligado
       , SF.Descricao [SituacaoFuncionario]
       , s.Descricao as Sexo
       ,'C'+substring(RIGHT(f.[Matricula],7),0,7) as Matricula
       , UltimoCargo
       , SR.Codigo CodigoSR
       , SR.Nivel NivelSR
       , SR.Nome NomeSR
       , SUAT.Codigo CodigoSUAT
       , SUAT.Nivel NivelSUAT
       , SUAT.Nome NomeSUAT
FROM [Dados].Funcionario f
left join dados.vw_Unidade U
ON F.IDUltimaUnidade = U.IDUnidade
outer apply [Dados].[fn_RecuperaSR] (U.Codigo) SR
outer apply [Dados].[fn_RecuperaSUAT] (U.Codigo) SUAT
left join Dados.SituacaoFuncionario sf on sf.ID = f.IDUltimaSituacaoFuncionario
left join Dados.Sexo s on s.ID = f.IDSexo
LEFT JOIN DADOS.TIPOUNIDADE TU ON TU.ID = U.IDTIPOUNIDADE
WHERE F.IDEmpresa = 1
AND F.CPF IS NOT NULL 
AND F.IDUltimaSituacaoFuncionario IS NOT NULL
)
SELECT   C.ID IDFuncionario
        , C.CPF
        , C.Nome
       , C.Empresa
	   , RIGHT('0000' + convert(varchar, C.CodigoUnidade),4) as CodigoUnidade
       , C.NomeUnidade
       , C.TipoUnidade
       , RIGHT(C.MatriculaDV,7) AS MatriculaDV
       , C.Desligado
       , C.SituacaoFuncionario
       , C.Sexo
       , C.Matricula
       , C.UltimoCargo
       , COALESCE(C.CodigoSR,C.CodigoSUAT,C.CodigoUnidade) as CodigoNv1
       --, C.NivelSR
       , COALESCE(C.NomeSR,C.NomeSUAT,C.NomeUnidade) as NomeNv1
       , COALESCE(C.CodigoSUAT,C.CodigoSR,C.CodigoUnidade) as CodigoNv2
       --, C.NivelSUAT
       , COALESCE(C.NomeSUAT,C.NomeSR,C.NomeUnidade) as NomeNv2
       , CASE WHEN C1.IDUnidade IS NULL THEN 'NÃO' ELSE 'SIM' END PossuiASVEN
FROM CTE C
LEFT JOIN CTE1 C1
ON C1.IDUnidade = C.IDUnidade

