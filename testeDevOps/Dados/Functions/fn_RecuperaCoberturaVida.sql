/*
	Autor: Gustavo Moreira
	Data Criação: 09/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaCoberturaVida
	Descrição: Consulta que recupera cobertura dos certificados para os certificados que possuem codigo de produto.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaCoberturaVida](@DataInicio AS DATE, @DataFim AS DATE)

RETURNS TABLE
AS
RETURN

WITH RETORNACOBERTURA AS
  (SELECT 
		  CCH.ID,
		  CTO.NumeroContrato,
		  CE.NumeroCertificado,
          ISNULL(PRP.DataInicioVigencia, CCH.DataInicioVigencia) [DataInicioVigencia],
          ISNULL(CH.DataFimVigencia, CCH.DataFimVigencia) [DataFimVigencia],
          PSIG.CodigoProduto [CodigoSIGPF],
          PSIG.Descricao [NomeProdutoSIGPF],
          CE.NomeCliente,
          CE.CPF,
          CCH.ImportanciaSegurada,
          CCH.LimiteIndenizacao,
          CCH.ValorPremioLiquido,
          PRP.ValorPremioTotal,
          COB.Codigo [CodigoCobertura],
          COB.Nome [NomeCobertura],
          RANKID,
          CE.IDProposta
   FROM  Dados.Certificado CE
   CROSS APPLY (SELECT TOP 1 DataFimVigencia, DataCancelamento 
                FROM Dados.CertificadoHistorico CH
                WHERE CH.IDCertificado = CE.ID
                ORDER BY CH.IDCertificado, CH.DataArquivo DESC, DataFimVigencia DESC) CH
   CROSS APPLY (SELECT CCH.ID,
                       CCH.ImportanciaSegurada,
                                CCH.LimiteIndenizacao,
                                CCH.ValorPremioLiquido,
                                CCH.DataInicioVigencia,
                                CCH.DataFimVigencia,
                                CCH.IDCobertura,
                      ROW_NUMBER () OVER (PARTITION BY CCH.IDCERTIFICADO, CCH.IDCOBERTURA
                                                     ORDER BY CCH.IDCERTIFICADO, CCH.IDCOBERTURA, CCH.DataInicioVigencia DESC, cch.dataarquivo desc) AS RANKID
                        FROM Dados.CertificadoCoberturaHistorico CCH
                WHERE CE.ID = CCH.IDCertificado             
                ) CCH
                   
   LEFT JOIN DADOS.CONTRATO CTO
   ON CTO.ID = CE.IDCONTRATO                
   left JOIN Dados.Proposta PRP
   ON PRP.ID = CE.IDPROPOSTA
   INNER JOIN Dados.Cobertura COB
   ON COB.ID = CCH.IDCobertura
   left JOIN Dados.ProdutoSIGPF PSIG
   ON PSIG.ID = PRP.IDProdutoSIGPF 
   WHERE (CCH.[DataInicioVigencia] BETWEEN @DataInicio AND @DataFim
      OR PRP.DataInicioVigencia BETWEEN @DataInicio AND @DataFim)
      AND
        (CH.DataFimVigencia >= GETDATE ()
      or CCH.DataFimVigencia >= GETDATE ())
      AND (CH.DataCancelamento IS NULL OR CH.DataCancelamento = '9999-12-31' OR CH.DataCancelamento = '0001-01-01')

       )

SELECT              C.NumeroContrato
				  ,	C.NumeroCertificado
                  , C.DataInicioVigencia
                  , C.DataFimVigencia
                  , C.CodigoSIGPF
                  , C.NomeProdutoSIGPF
                  , C.NomeCliente
                  , C.CPF
                  , C.ImportanciaSegurada
                  , C.LimiteIndenizacao
                  , C.ValorPremioLiquido
                  , C.ValorPremioTotal
                  , C.CodigoCobertura
                  , C.NomeCobertura
                  , C.IDProposta
FROM RETORNACOBERTURA C
WHERE C.RANKID = 1