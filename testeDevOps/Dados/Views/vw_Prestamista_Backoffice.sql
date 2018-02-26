

CREATE VIEW Dados.vw_Prestamista_Backoffice
AS
/*
Autor: André Anselmo
Status: Em desenvolvimento 
Data: 2016-04-15
Objetivo: Fornecer acesso aos dados do produto prestamista - 77 para aplicação desenvolvida pelo Mário Scherer, a pedido do backoffice
*/
SELECT 
	PC.CPFCNPJ
	, PC.Nome 
	, (PC.DDDComercial + ' - ' + PC.TelefoneComercial) AS TelefoneComercial
	, (PC.DDDResidencial + ' - ' + PC.TelefoneResidencial) AS TelefoneResidencial
	, PC.Email
	, PE.Endereco
	, PE.Bairro
	, PE.Cidade
	, PE.UF
	, PE.CEP
	, P.NumeroProposta
	, C.NumeroContrato
	, P.DataInicioVigencia
	, P.DataFimVigencia
	, SP.Sigla AS Situacao
	, U.Codigo AS AgenciaVenda
	, P.ValorPremioBrutoEmissao AS PremioBruto
	, NULL AS ImportanciaSegurada
	, NULL Beneficiarios
FROM	
	Dados.Proposta AS P
LEFT OUTER JOIN Dados.PropostaCliente AS PC
ON P.ID=PC.IDProposta
LEFT OUTER JOIN Dados.PropostaEndereco AS PE
ON P.ID=PE.IDProposta AND PE.LastValue=1
LEFT OUTER JOIN Dados.Contrato AS C 
ON C.ID=P.IDContrato
LEFT OUTER JOIN Dados.SituacaoProposta AS SP
ON SP.ID=P.IDSituacaoProposta
LEFT OUTER JOIN Dados.Unidade AS U
ON P.IDAgenciaVenda=U.ID
WHERE 
	P.IDProdutoSIGPF=36



