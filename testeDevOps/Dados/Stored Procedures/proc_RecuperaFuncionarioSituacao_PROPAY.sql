/*
	Autor: Diego Lima
	Data Criação: 14/02/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: Corporativo.Dados.proc_RecuperaFuncionarioSituacao_PROPAY
       Descrição: Essa procedure vai consultar os dados de funcionário, disponíveis na tabela
             PROPAY e retornar o resultado no formato XML. Somente retorna os
             TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaFuncionarioSituacao_PROPAY]
		--@PontoParada VARCHAR(400)
      
AS
WITH CTE 
AS
(
	SELECT  DISTINCT
		f.FUCODEMP AS CodigoEmpresaPropay,
	   --E.EMNOMEMP AS NomeEmpresaPropay,
	    REPLICATE('0', 8 - LEN(CAST(df.matricula as varchar(6)))) + CAST(df.matricula as varchar(6))AS MatriculaTratada,
		df.matricula,
		convert(date,DF.DATA_NASCIMENTO,104) AS DataNascimentoTratada,
		df.data_nascimento AS DataNascimento,
		(CASE
                    WHEN df.sexo = 'F' THEN 2
                    WHEN df.sexo = 'M' THEN 1
                    ELSE NULL
             END) AS SexoCodigo,
		(CASE
                    WHEN df.sexo = 'M' THEN 'Masculino'
                    WHEN df.sexo = 'F' THEN 'Feminino'
                    ELSE NULL
             END) AS Sexo,
		--df.sexo,
		df.nome as Nome,
		cast(CAST(df.pis AS bigint)as varchar(20)) AS PIS,
		--df.pis,
		df.situacao AS Situacao,
		convert(date,df.data_situacao,104) AS DataSituacaoTratada,
		df.data_situacao AS DataSituacao,
		convert(date,df.data_admissao,104) AS DataAdmissaoTratada,
		df.data_admissao AS DataAdmissao,
		df.banco_agencia_ccorrente AS BancoAgenciaCCorrente,
		df.grupo_hierarquico AS GrupoHierarquico,
		df.codigo_cargo AS CodigoCargo,
		df.desc_cargo AS DescricaoCargo,
		df.codigo_centro_custo AS CodigoCentroCusto,
		df.desc_centro_custo AS DescricaoCentroCusto,
		cast(B.salario AS decimal(13,2)) AS SalarioTratado,
		convert(date,getdate(),104) AS DataArquivo,
		RTRIM(LTRIM(F.FUCBO)) CodigoOcupacao,
		'PROPAY' AS NomeArquivo
		--,ROW_NUMBER() OVER(PARTITION BY DF.Nome, F.FUCPF ORDER BY convert(date,df.data_situacao,104) DESC) [ORDEM] -- comentar isso
--		,ROW_NUMBER() OVER(PARTITION BY DF.Nome, DF.MATRICULA ORDER BY convert(date,df.data_situacao,104) DESC) [ORDEM]
,1 [ordem]
FROM PROPAY2.[DBGPCS].[dbo].[FUNCIONA] F
INNER JOIN PROPAY2.[DBGPCS].[dbo].[DADOS_FUNCIONARIO] df
ON f.fumatfunc = df.matricula
AND df.NOME = F.FUNOMFUNC
OUTER APPLY
(SELECT cast(dmc.salario AS decimal(13,2)) [SALARIO]
 FROM PROPAY2.[DBGPCS].[dbo].[DADOS_FUNCIONARIO_CARGO] DMC
 WHERE --dmc.matricula = f.fumatfunc
   --AND DMC.NOME = F.FUNOMFUNC
   dmc.matricula = df.[MATRICULA] 
   AND DMC.NOME = dF.[NOME] 
   AND DMC.DATA_SITUACAO = DF.DATA_SITUACAO
   AND DMC.CODIGO_CARGO = DF.CODIGO_CARGO) B
   --where     Matricula = 801573
--where convert(date,DF.DATA_SITUACAO,104) = @PontoParada 
) 
SELECT *
FROM CTE
WHERE CTE.ORDEM = 1 AND CTE.DataArquivo IS NOT NULL -- Descomentar para pegar a ultima posição.
order by MatriculaTratada

--where convert(date,df.data_situacao,104) is not null 
----and convert(date,df.data_situacao,104) > @PontoParada 

--order by 2--convert(date,DF.DATA_SITUACAO,104) asc

