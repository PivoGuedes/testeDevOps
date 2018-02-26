/*
	Autor: Gustavo Moreira
	Data Criação: 07/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaSinistro
	Descrição: Procedimento que realiza a recuperação dos SINISTROS.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaSinistro] (@DataApuracao AS DATE)
RETURNS TABLE
AS
RETURN
--DECLARE @DataApuracao AS DATE = '20130701'

SELECT 
		S.DataAviso [DATA AVISO SINISTRO],
		S.DataSinistro [DATA SINISTRO],
		S.NumeroSinistro [NUMERO SINISTRO], 
		S.NumeroProtocolo [NUMERO PROTOCOLO],
		CT.NumeroContrato [NUMERO CONTRATO],
		CER.NumeroCertificado [NUMERO CERTIFICADO],
		CER.NomeCliente [NOMECLIENTE],
		CER.CPF [CPFCNPJ],
		RA.Codigo [CODIGO RAMO],
		RA.Nome [NOME RAMO],
		RA.TipoRamo [TIPO RAMO],
		--SS.Descricao [SITUACAO SINISTRO], /* Tabela sem descrição */
		SC.Descricao [DESCRICAO SINISTRO]

FROM Dados.Sinistro S
/*Tabelas de informação*/
--LEFT JOIN Dados.SituacaoSinistro SS
--ON SS.ID = S.IDSituacaoSinistro 
LEFT JOIN Dados.SinistroCausa SC
ON SC.ID = S.IDSinistroCausa
LEFT JOIN Dados.Ramo RA
ON RA.ID = S.IDRamo
/* Tabelas para recuperar informações adicionais */
LEFT JOIN Dados.Contrato CT
ON S.IDContrato = CT.ID 
INNER JOIN Dados.Certificado CER
ON CER.ID = S.IDCertificado
where S.DataSinistro >= @DataApuracao


UNION

SELECT 
		S.DataAviso [DATA AVISO SINISTRO],
		S.DataSinistro [DATA SINISTRO],
		S.NumeroSinistro [NUMERO SINISTRO], 
		S.NumeroProtocolo [NUMERO PROTOCOLO],
		CT.NumeroContrato [NUMERO CONTRATO],
		NULL [NUMERO CERTIFICADO],
		PC.Nome [NOMECLIENTE],
		PC.CPFCNPJ [CPFCNPJ],
		RA.Codigo [CODIGO RAMO],
		RA.Nome [NOME RAMO],
		RA.TipoRamo [TIPO RAMO],
		--SS.Descricao [SITUACAO SINISTRO], /* Tabela sem descrição */
		SC.Descricao [DESCRICAO SINISTRO]
FROM Dados.Sinistro S
/*Tabelas de informação*/
--LEFT JOIN Dados.SituacaoSinistro SS
--ON SS.ID = S.IDSituacaoSinistro 
LEFT JOIN Dados.SinistroCausa SC
ON SC.ID = S.IDSinistroCausa
LEFT JOIN Dados.Ramo RA
ON RA.ID = S.IDRamo
/* Tabelas para recuperar informações adicionais */
INNER JOIN Dados.Contrato CT
ON S.IDContrato = CT.ID
LEFT JOIN Dados.PropostaCliente PC
ON PC.IDProposta = CT.IDProposta
where S.DataSinistro >= @DataApuracao
