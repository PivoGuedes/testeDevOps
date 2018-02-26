/*
	Autor: Diego Lima
	Data Criação: 12/02/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: Corporativo.Dados.proc_RecuperaFuncionario_PROPAY
       Descrição: Essa procedure vai consultar os dados de funcionário, disponíveis na tabela
             PROPAY e retornar o resultado no formato XML. Somente retorna os
             TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaFuncionario_PROPAY]
      
AS
       --Dados de Controle
      
SELECT							
				E.EMCODEMP AS CodigoEmpresaPropay,
				E.EMNOMEMP AS NomeEmpresaPropay,
				E.EMNOMFANT AS NomeFantasiaEmpresaPropay,
				
				f.FUNOMFUNC AS NomeFuncionario, 
				CleansingKit.dbo.fn_FormataCPF(CAST(cast(f.fucpf AS Bigint) AS VARCHAR(20))) AS CPFTratado ,
				f.fucpf AS CPF,
			
				F.FUEMAIL AS Email,
				 REPLICATE('0', 8 - LEN(CAST(f.fumatfunc as varchar(6)))) + CAST(f.fumatfunc as varchar(6))AS MatriculaTratada,
				f.fumatfunc AS Matricula,
				cast(CAST(f.FUPISPASEP AS bigint)as varchar(20)) AS PIS,
				F.FUTELEFONE AS Telefone,

				F.FUCENTRCUS AS CodigoCentroCusto,
				F.FUCODCARGO AS CodigoCargo,
				SUBSTRING(CAST(F.FUDTADMIS AS VARCHAR(8)), 1, 4)+'-'+ SUBSTRING(CAST(F.FUDTADMIS AS VARCHAR(8)), 5, 2)+'-'+SUBSTRING(CAST(F.FUDTADMIS AS VARCHAR(8)), 7, 2) AS DataAdmissaoTratada,
				F.FUDTADMIS AS DataAdmissao,

				(CASE
                    WHEN F.FUSEXFUNC = 'F' THEN 2
                    WHEN F.FUSEXFUNC = 'M' THEN 1
                    ELSE NULL
             END) AS SexoCodigo,
		(CASE
                    WHEN F.FUSEXFUNC = 'M' THEN 'Masculino'
                    WHEN F.FUSEXFUNC = 'F' THEN 'Feminino'
                    ELSE NULL
             END) AS Sexo,
				SUBSTRING(CAST(F.FUDTNASC AS VARCHAR(8)), 1, 4)+'-'+ SUBSTRING(CAST(F.FUDTNASC AS VARCHAR(8)), 5, 2)+'-'+SUBSTRING(CAST(F.FUDTNASC AS VARCHAR(8)), 7, 2) AS DataNascimentoTratada,
				F.FUDTNASC AS DataNascimento,
				--F.FUVINCULO AS Vinculo,

				f.FUESTCIVIL AS EstadoCivilCodigo,
				(CASE
                    WHEN F.FUESTCIVIL = '1' THEN 'Solteiro'
                    WHEN F.FUESTCIVIL = '2' THEN 'Casado'
					WHEN F.FUESTCIVIL = '3' THEN 'Separado Judicialmente'
					WHEN F.FUESTCIVIL = '4' THEN 'Divorciado'
					WHEN F.FUESTCIVIL = '5' THEN 'Viúvo'
					WHEN F.FUESTCIVIL = '6' THEN 'Outros'
					WHEN F.FUESTCIVIL = '7' THEN 'Ignorado'
                    ELSE NULL
             END) AS EstadoCivil,

			 f.fuendereco AS Endereco,
			 f.fuComplemento AS ComplementoEndereco,
			 f.fubairro AS Bairro,
			 f.fuDDD as DDD,
			 f.fucep as CEP,
			 F.fucelular AS Celular,
			 null AS Municipio,
			 null AS UF,
			 F.FUCODGRPHIE Hierarquia,

				cast(getdate()as date) AS DataArquivo,
				'PROPAY' AS NomeArquivo

FROM  PROPAY2.[DBGPCS].[dbo].[FUNCIONA] F

INNER JOIN PROPAY2.[DBGPCS].[dbo].[EMPRESAS] E
ON F.FUCODEMP = E.EMCODEMP

order by f.fumatfunc

