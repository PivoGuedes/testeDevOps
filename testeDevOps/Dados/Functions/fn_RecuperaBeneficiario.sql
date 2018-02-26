
/*
	Autor: Gustavo Moreira
	Data Criação: 10/07/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaBeneficiario
	Descrição: Consulta que recupera propostas com beneficiários.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Dados.fn_RecuperaBeneficiario(@DataInicio AS DATE, @DataFim AS DATE)

RETURNS TABLE
AS
RETURN

--declare @datainicio date = '20130701'
--declare @datafim date = '20130705'

SELECT    CRT.NumeroCertificado [NUMERO CERTIFICADO]
		, PSG.CodigoProduto [COD PRODUTO SIGPF]
		, PSG.Descricao [DESC PRODUTO]
		, PRPC.Nome [NOME CLIENTE]
		, PRPC.CPFCNPJ [CPFCNPJ]
		, PRP.DataProposta [DATA DA PROPOSTA]
		, CB.DataInclusao [DATA INCLUSAO BENEFICIARIO]
		, CB.DataExclusao [DATA EXCLUSAO BENEFICIARIO]
		, CB.Nome [NOME BENEFICIARIO]
		, CB.Numero [NUMERO DO BENEFICIARIO]
		, CB.Parentesco [PARENTESCO BENEFICIARIO]
		, CB.PercentualBeneficio [PERCENTUAL BENEFICIARIO]
		
FROM Dados.Certificado CRT
LEFT JOIN Dados.CertificadoBeneficiario CB
ON CB.IDCertificado = CRT.ID
INNER JOIN Dados.Proposta PRP
ON PRP.ID = CRT.IDProposta
INNER JOIN Dados.PropostaCliente PRPC
ON PRPC.IDProposta = PRP.ID
INNER JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF

WHERE  PRP.DataProposta BETWEEN @datainicio and @datafim
AND CB.Numero IS NOT NULL
