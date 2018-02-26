

/*
	Autor: Egler Vieira
	Data Criação: 18/06/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Marketing].[vw_DadosClienteProposta]
	Descrição: View que retorna os dados de contatos do cliente.
	           A view não se propõe a realizar o retorno dos dados de cliente único,
	           isto é, não retornará necessariamente um único registro por CPF.
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/

CREATE VIEW [Marketing].[vw_DadosClienteProposta]
AS
SELECT
  PRP.NumeroProposta 
, PC.CPFCNPJ
, PC.Nome
, PC.TipoPessoa
, S.Descricao AS Sexo
, PC.DataNascimento
, EC.Descricao AS EstadoCivil
, PC.Profissao
, PC.DDDComercial
, PC.TelefoneComercial
, PC.DDDResidencial
, PC.TelefoneResidencial
, PC.DDDFax
, PC.TelefoneFax
, PC.Email
, PE.Endereco
, PE.CEP
, PE.Bairro
, PE.Cidade
, PE.UF


FROM Dados.Proposta PRP
INNER JOIN  Dados.PropostaCliente PC
ON PRP.ID = PC.IDProposta
LEFT JOIN Dados.PropostaEndereco PE
ON PE.IDProposta = PRP.ID
LEFT JOIN Dados.Sexo S
ON S.ID = PC.IDSexo
LEFT JOIN Dados.EstadoCivil EC
ON EC.ID = PC.IDEstadoCivil

