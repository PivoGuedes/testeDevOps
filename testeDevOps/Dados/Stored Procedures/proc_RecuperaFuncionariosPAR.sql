

/*
	Autor: Diego Lima
	Data Criação: 06/05/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: CORPORATIVO.Dados.proc_RecuperaFuncionariosPAR
       Descrição: Essa procedure vai consultar os dados de funcionário cadastro, disponíveis na tabela
             funcionario e retornar o resultado no formato XML. Somente retorna os
             TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_RecuperaFuncionariosPAR]
      
AS

WITH CTE
AS
(


select distinct --e.Nome AS Empresa, 
				--e.CodigoEmpresaPROPAY,
				CASE
									WHEN e.CodigoEmpresaPROPAY = 1 THEN 'FPC PAR CORRETORA DE SEGUROS S/A'
									WHEN e.CodigoEmpresaPROPAY = 2 THEN 'FPC PAR SAUDE CORRETORA DE SEGUROS S/A'
									WHEN e.CodigoEmpresaPROPAY = 3 THEN 'PAR RISCOS ESPECIAIS CORRETORA DE SEGUROS LTDA.'
									WHEN e.CodigoEmpresaPROPAY = 4 THEN 'PAR SAUDE CORPORATE CORRETORA DE SEGUROS LTDA'
									WHEN e.CodigoEmpresaPROPAY = 100 THEN 'ADMINISTRADOR PORTAL'
									WHEN e.CodigoEmpresaPROPAY = 501 THEN 'FPC PAR CORRETORA DE SEGUROS _ AUTONOMOS'
									WHEN e.CodigoEmpresaPROPAY = 504 THEN 'PAR SAUDE CORPORATE CORRETORA DE SEGUROS_AUTONOMOS'
									ELSE NULL
							 END AS NomeEmpresa,
		cc.Descricao AS Lotacao, 
		cp.Descricao AS Cargo,
		f.matricula,
		sf.Descricao AS Situacao,
		f.CPF,
		f.nome,
		s.Descricao AS Genero,
		f.DataNascimento,
		ec.Descricao AS EstadoCivil,
		f.email,
		LEFT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.DDD, ' ', ''),'-',''),')',''),'(',''))) as bigint),2) DDD1Tratado,
		--REPLICATE('0', 2 - LEN(f.DDD)) + f.DDD DDD1Tratado,
		f.DDD AS DDD1,
		RIGHT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(',''))) as bigint), 
		CASE 
		WHEN LEN(Cast(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(','') as bigint)) > 2 THEN LEN(Cast(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(','') as bigint)) 
		ELSE 0 END) Telefone1Tratado,

		--REPLICATE('0', 8 - LEN(f.Telefone)) + f.Telefone Telefone1Tratadoteste,
		f.Telefone AS Telefone1,
		f.Celular AS Telefone2,
		f.DDDCelular AS DDD2,
		
        LEFT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(',''))) as bigint),2) DDD , 
		RIGHT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(',''))) as bigint), CASE WHEN LEN(Cast(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(','') as bigint)) > 2 THEN LEN(Cast(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(','') as bigint)) -2 ELSE 0 END) Telefone,

		f.Endereco,
		f.ComplementoEndereco AS 'Compl.Ender.',
		REPLICATE('0', 8 - LEN(rtrim(ltrim(f.cep)))) + rtrim(ltrim(f.cep)) CEPTratado,
		f.cep AS CEP,
		f.Municipio,
		f.UF,
		f.Bairro

FROM [Dados].[Funcionario] f

inner join dados.Empresa e
on (f.idempresa = e.ID)

inner join dados.CentroCusto cc
on f.IDCentroCusto = cc.ID

inner join dados.cargopropay cp
on f.IDCargoPROPAY = cp.ID

inner join dados.SituacaoFuncionario sf
on f.IDUltimaSituacaoFuncionario = sf.ID

inner join dados.Sexo s
on f.IDSexo = s.ID

inner join dados.EstadoCivil ec
on f.IDEstadoCivil = ec.ID

 where f.IDEmpresa in(3,7,15,16) and
  f.nome is not null 
 and  sf.Descricao IN ('AFASTADO','ATIVIDADE NORMAL','FÉRIAS') OR sf.Descricao LIKE 'AFAST%'
  OR sf.Descricao LIKE 'FERIAS%' OR sf.Descricao LIKE 'ESTAG%'

--  and len(matricula) = 7
--  and f.nome like 'LIONIZIA NUNES XAVIER%'
)
SELECT NomeEmpresa as EMPRESA
	   ,LOTAÇÃO
	   ,CARGO
	   ,MATRÍCULA
	   ,SITUAÇÃO
	   ,CPF
	   ,NOME
	   ,GÊNERO
	   ,DataNascimento [DATA DE NASCIMENTO]
	   ,EstadoCivil [ESTADO CIVIL]
	   ,Email [E-MAIL]
	  -- ,DDD1Tratado [DDD 1teste]
	   ,CASE 
	   WHEN LEN(DDD1Tratado) = 1 THEN NULL 
	   when LEN(Telefone1Tratado) < 8 then null
	   when Telefone1Tratado = TELEFONE then null
	   ELSE DDD1Tratado END [DDD 1],
	   	  -- Telefone1Tratado [Telefone 1teste],
	   CASE 
	   WHEN LEN(Telefone1Tratado) > 9 THEN NULL 
	   when Telefone1Tratado = TELEFONE then null
	   WHEN LEN(Telefone1Tratado) = 9 and LEN(DDD1Tratado) = 2 then left(Telefone1Tratado,5)+'-'+right (Telefone1Tratado,4)
	   WHEN LEN(Telefone1Tratado) = 8 and LEN(DDD1Tratado) = 2 then left(Telefone1Tratado,4)+'-'+right (Telefone1Tratado,4)
	   ELSE null END [TELEFONE 1],
	   
	   --CASE 
	   --WHEN LEN(Telefone1Tratado) > 9 THEN NULL 
	   --WHEN LEN(Telefone1Tratado) = 9 and LEN(DDD1Tratado) = 2 then left(Telefone1Tratado,5)+'-'+right (Telefone1Tratado,4)
	   --WHEN LEN(Telefone1Tratado) = 8 and LEN(DDD1Tratado) = 2 then left(Telefone1Tratado,4)+'-'+right (Telefone1Tratado,4)
	   --ELSE null END [TELEFONE 11],

	   CASE 
	   WHEN LEN(TELEFONE) > 9 THEN NULL
	   when LEN(TELEFONE) < 8 THEN NULL
	   WHEN LEN(TELEFONE) = 1 THEN NULL
	   WHEN len(TELEFONE) = 0 THEN NULL
	   ELSE DDD END [DDD 2]
	  
	   ,CASE 
	   WHEN LEN(TELEFONE) > 9 THEN NULL 
	   WHEN LEN(TELEFONE) = 9 then left(TELEFONE,5)+'-'+right (TELEFONE,4)
	   WHEN LEN(TELEFONE) = 8 then left(TELEFONE,4)+'-'+right (TELEFONE,4)
	   ELSE null END [TELEFONE 2]

	    --,CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE left(TELEFONE,4)+'-'+right (TELEFONE,4) END [TELEFONE 2Tratado]
	   ,ENDERECO
	   ,[COMPL.ENDER.]
	   --,CEPTratado CEP
	   ,CASE WHEN LEN(CEPTratado) > 9 THEN NULL ELSE left(CEPTratado,5)+'-'+right (CEPTratado,3) END [CEP]
	   ,MUNICIPIO
	   ,UF
	   ,BAIRRO
	  -- ,LEN(TELEFONE),Telefone2, CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE DDD END DDD,  CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE TELEFONE END TELEFONE
FROM CTE
order by  NomeEmpresa

--WITH CTE
--AS
--(


--select distinct --e.Nome AS Empresa, 
--				--e.CodigoEmpresaPROPAY,
--				CASE
--									WHEN e.CodigoEmpresaPROPAY = 1 THEN 'FPC PAR CORRETORA DE SEGUROS S/A'
--									WHEN e.CodigoEmpresaPROPAY = 2 THEN 'FPC PAR SAUDE CORRETORA DE SEGUROS S/A'
--									WHEN e.CodigoEmpresaPROPAY = 3 THEN 'PAR RISCOS ESPECIAIS CORRETORA DE SEGUROS LTDA.'
--									WHEN e.CodigoEmpresaPROPAY = 4 THEN 'PAR SAUDE CORPORATE CORRETORA DE SEGUROS LTDA'
--									WHEN e.CodigoEmpresaPROPAY = 100 THEN 'ADMINISTRADOR PORTAL'
--									WHEN e.CodigoEmpresaPROPAY = 501 THEN 'FPC PAR CORRETORA DE SEGUROS _ AUTONOMOS'
--									WHEN e.CodigoEmpresaPROPAY = 504 THEN 'PAR SAUDE CORPORATE CORRETORA DE SEGUROS_AUTONOMOS'
--									ELSE NULL
--							 END AS NomeEmpresa,
--		cc.Descricao AS Lotacao, 
--		cp.Descricao AS Cargo,
--		f.matricula,
--		sf.Descricao AS Situacao,
--		f.CPF,
--		f.nome,
--		s.Descricao AS Genero,
--		f.DataNascimento,
--		ec.Descricao AS EstadoCivil,
--		f.email,
--		LEFT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.DDD, ' ', ''),'-',''),')',''),'(',''))) as bigint),2) DDD1Tratado,
--		--REPLICATE('0', 2 - LEN(f.DDD)) + f.DDD DDD1Tratado,
--		f.DDD AS DDD1,
--		RIGHT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(',''))) as bigint), CASE WHEN LEN(Cast(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(','') as bigint)) > 2 THEN LEN(Cast(Replace(Replace(Replace(Replace(f.Telefone, ' ', ''),'-',''),')',''),'(','') as bigint)) ELSE 0 END) Telefone1Tratado,

--		--REPLICATE('0', 8 - LEN(f.Telefone)) + f.Telefone Telefone1Tratadoteste,
--		f.Telefone AS Telefone1,
--		f.Celular AS Telefone2,
--		f.DDDCelular AS DDD2,
		
--        LEFT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(',''))) as bigint),2) DDD , 
--		RIGHT(Cast(LTRIM(RTRIM(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(',''))) as bigint), CASE WHEN LEN(Cast(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(','') as bigint)) > 2 THEN LEN(Cast(Replace(Replace(Replace(Replace(f.Celular, ' ', ''),'-',''),')',''),'(','') as bigint)) -2 ELSE 0 END) Telefone,

--		f.Endereco,
--		f.ComplementoEndereco AS 'Compl.Ender.',
--		REPLICATE('0', 8 - LEN(rtrim(ltrim(f.cep)))) + rtrim(ltrim(f.cep)) CEPTratado,
--		f.cep AS CEP,
--		f.Municipio,
--		f.UF,
--		f.Bairro

--FROM [Dados].[Funcionario] f

--inner join dados.Empresa e
--on (f.idempresa = e.ID)

--inner join dados.CentroCusto cc
--on f.IDCentroCusto = cc.ID

--inner join dados.cargopropay cp
--on f.IDCargoPROPAY = cp.ID

--inner join dados.SituacaoFuncionario sf
--on f.IDUltimaSituacaoFuncionario = sf.ID

--inner join dados.Sexo s
--on f.IDSexo = s.ID

--inner join dados.EstadoCivil ec
--on f.IDEstadoCivil = ec.ID

-- where f.IDEmpresa in(3,7,15,16) and
--  f.nome is not null 
-- and  sf.Descricao IN ('AFASTADO','ATIVIDADE NORMAL','FÉRIAS') OR sf.Descricao LIKE 'AFAST%'
--  OR sf.Descricao LIKE 'FERIAS%' OR sf.Descricao LIKE 'ESTAG%'

----  and len(matricula) = 7
----  and f.nome like 'LIONIZIA NUNES XAVIER%'
--)
--SELECT NomeEmpresa as EMPRESA
--	   ,LOTAÇÃO
--	   ,CARGO
--	   ,MATRÍCULA
--	   ,SITUAÇÃO
--	   ,CPF
--	   ,NOME
--	   ,GÊNERO
--	   ,DataNascimento [DATA DE NASCIMENTO]
--	   ,EstadoCivil [ESTADO CIVIL]
--	   ,Email [E-MAIL]
--	  -- ,DDD1Tratado [DDD 1teste]
--	   ,CASE 
--	   WHEN LEN(DDD1Tratado) = 1 THEN NULL 
--	   ELSE DDD1Tratado END [DDD 1],

--	  -- Telefone1Tratado [Telefone 1teste],
--	   CASE 
--	   WHEN LEN(Telefone1Tratado) > 9 THEN NULL 
--	   WHEN LEN(Telefone1Tratado) = 9 then left(Telefone1Tratado,5)+'-'+right (Telefone1Tratado,4)
--	   WHEN LEN(Telefone1Tratado) = 8 then left(Telefone1Tratado,4)+'-'+right (Telefone1Tratado,4)
--	   ELSE null END [TELEFONE 1],
	   
--	   CASE 
--	   WHEN LEN(TELEFONE) > 9 THEN NULL 
--	   WHEN LEN(TELEFONE) = 1 THEN NULL
--	   WHEN (TELEFONE) = 0 THEN NULL
--	   ELSE DDD END [DDD 2]
	  
--	   ,CASE 
--	   WHEN LEN(TELEFONE) > 9 THEN NULL 
--	   WHEN LEN(TELEFONE) = 9 then left(TELEFONE,5)+'-'+right (TELEFONE,4)
--	   WHEN LEN(TELEFONE) = 8 then left(TELEFONE,4)+'-'+right (TELEFONE,4)
--	   ELSE null END [TELEFONE 2]

--	    --,CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE left(TELEFONE,4)+'-'+right (TELEFONE,4) END [TELEFONE 2Tratado]
--	   ,ENDERECO
--	   ,[COMPL.ENDER.]
--	   --,CEPTratado CEP
--	   ,CASE WHEN LEN(CEPTratado) > 9 THEN NULL ELSE left(CEPTratado,5)+'-'+right (CEPTratado,3) END [CEP]
--	   ,MUNICIPIO
--	   ,UF
--	   ,BAIRRO
--	  -- ,LEN(TELEFONE),Telefone2, CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE DDD END DDD,  CASE WHEN LEN(TELEFONE) > 9 THEN NULL ELSE TELEFONE END TELEFONE
--FROM CTE
--order by  NomeEmpresa


