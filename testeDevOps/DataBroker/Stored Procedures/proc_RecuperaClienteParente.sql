



CREATE PROCEDURE [DataBroker].[proc_RecuperaClienteParente]
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
SET @CPF = CleansingKit.dbo.fn_FormataCPF(@CPF) exec as login='usrAndre';


*/


SET @CPF = REPLACE(REPLACE(@CPF, '.', ''), '-', '');
	
IF (LEN(@CPF) < 11)
BEGIN 
	RAISERROR('O parâmetro @CPF é inválido',16,1)		
	RETURN -1	
END

SET @CPF = CleansingKit.dbo.fn_FormataCPF(@CPF);

WITH CTE_Cliente
AS
(
SELECT  
       PF.ID IDPessoFisica,
       PF.IdentificadorGlobal,
	   NULL AS IDProfissao, 
	   F.Nome,
	   F.CPF,
	   F.Matricula,
	   F.DataNascimento,
	   F.Endereco,
	   F.Bairro,
	   F.Municipio AS Cidade,
	   F.CEP,
	   F.UF,
	   F.Email AS EmailComercial,
	   NULL AS EmailParticular,
	   EC.Descricao AS EstadoCivil,
	   F.Matricula AS MatriculaFuncionario,
	   E.Nome AS Empresa,
	   NULL AS Profissao,
	   NULL AS CodigoCBO,
	   S.Descricao AS Sexo,
	   NULL AS RG, 
	   NULL AS OrgaoExpedidor,
	   NULL AS UFExpedicao, 
	   F.Telefone AS TelResidencial, 
       NULL AS TelCelular,  
       NULL AS TelComercial,
       NULL AS TelFax,
       NULL AS Banco,
       NULL AS Agencia,
       NULL AS ContaCorrente,
       NULL AS Operacao,
       NULL AS IDPessoaFisicaFuncionario
FROM Dados.Funcionario AS F
LEFT OUTER JOIN DataBroker.PessoaFisica AS PF
ON F.CPF=PF.CPF
LEFT OUTER JOIN DataBroker.RelacionamentoPessoaFisica RPF 
ON RPF.IDPessoaFisicaOrigem = PF.ID
LEFT OUTER JOIN DataBroker.PessoaFisica AS PF1
ON PF1.ID=RPF.IDPessoaFisicaDestino
LEFT JOIN Dados.Empresa AS E
ON E.ID = F.IDEmpresa
LEFT JOIN Dados.EstadoCivil EC
ON EC.ID = F.IDEstadoCivil
LEFT JOIN Dados.Sexo S
ON S.ID = F.IDSexo
WHERE F.CPF = @CPF AND F.Matricula = @Matricula AND F.IDEmpresa = @IDEmpresa
)
SELECT *
FROM CTE_Cliente



