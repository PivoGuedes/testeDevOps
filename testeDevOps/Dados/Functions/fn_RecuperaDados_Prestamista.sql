/*
Autor: André Anselmo
Status: Em desenvolvimento 
Data: 2016-04-15
Objetivo: Fornecer acesso aos dados do produto prestamista - 77 para aplicação desenvolvida pelo Mário Scherer, a pedido do backoffice
*/

CREATE FUNCTION [Dados].[fn_RecuperaDados_Prestamista](@CPF AS VARCHAR(20))
RETURNS TABLE
AS
RETURN

SELECT 
	PC.CPFCNPJ
	, PC.Nome 
	, (PC.DDDComercial + ' - ' + PC.TelefoneComercial) AS TelefoneComercial
	, (PC.DDDResidencial + ' - ' + PC.TelefoneResidencial) AS TelefoneResidencial
	, PC.Email
	, PENP.Endereco
	, PENP.Bairro
	, PENP.Cidade
	, PENP.UF
	, PENP.CEP
	, P.NumeroProposta
	, C.NumeroContrato
	, P.DataInicioVigencia
	, P.DataFimVigencia
	, SP.Sigla AS Situacao
	, U.Codigo AS AgenciaVenda
	, P.ValorPremioBrutoEmissao AS PremioBruto
	, PROD.CodigoComercializado AS CodigoProduto
	, PROD.Descricao AS  DescricaoProduto
FROM	
	Dados.Proposta AS P
LEFT OUTER JOIN Dados.PropostaCliente AS PC
ON P.ID=PC.IDProposta
LEFT OUTER JOIN Dados.Contrato AS C 
ON C.ID=P.IDContrato
LEFT OUTER JOIN Dados.SituacaoProposta AS SP
ON SP.ID=P.IDSituacaoProposta
LEFT OUTER JOIN Dados.Unidade AS U
ON P.IDAgenciaVenda=U.ID
INNER JOIN Dados.Produto AS PROD
ON P.IDProduto=PROD.ID
INNER JOIN Dados.Certificado AS Certif
ON Certif.IDProposta=P.ID
OUTER APPLY (SELECT TOP 1 Endereco, Bairro, Cidade, UF, CEP FROM Dados.PropostaEndereco AS PEN WHERE LastValue=1 AND PEN.IDProposta=P.ID ORDER BY IDTipoEndereco ) AS PENP
WHERE 
	PROD.IDProdutoSIGPF IN (42,86)
	AND PC.CPFCNPJ=@CPF

