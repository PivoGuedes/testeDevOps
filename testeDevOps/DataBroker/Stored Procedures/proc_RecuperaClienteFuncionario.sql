/****** Object:  StoredProcedure [DataBroker].[proc_RecuperaClienteFuncionario]    Script Date: 9/1/2016 3:48:55 PM ******/


CREATE PROCEDURE [DataBroker].[proc_RecuperaClienteFuncionario]
    @CPF VARCHAR(14),
    @Matricula VARCHAR(10),
    @IDEmpresa INT
AS
/*
Procedure criada para substituir a procedure de mesmo nome do banco DataBroker, utilizada pelo sistema EVendas, do fornecedor Vicax
Data: 2016-06-14
Autor: André Anselmo

DECLARE @CPF VARCHAR(14)='832.737.941-00'
DECLARE @Matricula VARCHAR(10)='00004579'
DECLARE @IDEmpresa INT=3

*/
SET @Matricula = RIGHT('0000000' + @Matricula, 8)

SELECT 
	F.ID IDPessoFisica
	,CAST(NULL AS varchar(30)) AS IdentificadorGlobal
	,Cast(NULL AS INT) AS IDProfissao
	,F.Nome
	,F.CPF --IDPessoFisica
	,F.DataNascimento
	,F.Endereco
	,F.Bairro
	,F.Municipio AS Cidade
	,F.CEP
	,F.UltimoLotacaoEmail EmailComercial
	,F.Email EmailParticular
	,F.UF
	,EC.Descricao EstadoCivil
	,F.Matricula
	,F.Matricula AS MatriculaFuncionario
	,E.Nome AS Empresa
	,'' AS Profissao
	,'' AS CodigoCBO
	,S.Descricao AS Sexo
	,'' AS Banco
	,'' AS Agencia
	,'' AS ContaCorrente
	,'' AS Operacao
	,'' AS RG
	,'' AS OrgaoExpedidor
	,'' AS UFExpedicao
	,(CAST(F.DDD AS VARCHAR(3)) + CAST(F.Telefone AS VARCHAR(10)))  AS TelResidencial
	,(CAST(F.DDDCelular AS VARCHAR(3)) + CAST(F.Celular AS VARCHAR(10)))  AS TelCelular
	,'' AS TelComercial
	,'' AS TelFax
FROM Dados.Funcionario AS F
INNER JOIN (
                SELECT 3 IDEmpresa, 16 IDEmpresaBroker  ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL
				SELECT 6 IDEmpresa, 16 IDEmpresaBroker  ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 7 IDEmpresa, 16 IDEmpresaBroker  ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 8 IDEmpresa, 16 IDEmpresaBroker  ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 15 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 16 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 17 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 22 /*HABSEG*/ IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 23 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 25 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
				UNION ALL							    
				SELECT 27 IDEmpresa, 16 IDEmpresaBroker ---- {"Id": 16, "Nome": "Grupo PAR"}
	            UNION ALL													 
                SELECT  9 IDEmpresa,  13 IDEmpresaBroker ---- {"Id": 13, "Nome": "FUNCEF"}
				UNION ALL
				SELECT 12 IDEmpresa,  13 IDEmpresaBroker ---- {"Id": 13, "Nome": "FUNCEF"}
				UNION ALL
				SELECT 13 IDEmpresa,  13 IDEmpresaBroker ---- {"Id": 13, "Nome": "FUNCEF"}
				UNION ALL 
				SELECT  5 IDEmpresa, 8 IDEmpresaBroker ---- {"Id": 8, "Nome": "FPC Holding"}										  
				UNION ALL  
				SELECT 1 IDEmpresa, 1 IDEmpresaBroker ---- {"Id": 1, "Nome": "Caixa"}	
				UNION ALL											  
		        SELECT 2 IDEmpresa, 2 IDEmpresaBroker ---- {"Id": 2, "Nome": "Caixa Seguros"}
) EM
on F.IDEmpresa = EM.IDEmpresa
LEFT OUTER JOIN Dados.EstadoCivil AS EC
ON F.IDEstadoCivil=EC.ID
LEFT OUTER JOIN Dados.Empresa AS E
ON E.ID=F.IDEmpresa
LEFT OUTER JOIN Dados.Sexo AS S
ON S.ID=F.IDSexo
--LEFT JOIN Dados.Profissao P
--ON F.P
WHERE F.CPF=@CPF
AND EM.IDEmpresaBroker = @IDEmpresa
AND F.Matricula=@Matricula


