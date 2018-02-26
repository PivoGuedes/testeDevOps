
CREATE VIEW [CalculoComissao].[vw_Pagamento]
AS
SELECT  PGTO.ID
      , PRP.NumeroProposta
      , CNT.NumeroContrato
      , PRD.CodigoComercializado [CodigoProduto]
      /*, PRD.Descricao,*/ 
         ,--SUM(
              CASE WHEN IDTipoMovimento = 2 THEN   ABS(PGTO.ValorPremioLiquido) * -1 
                WHEN IDTipoMovimento IN (1,3) THEN   ABS(PGTO.ValorPremioLiquido) 
           ELSE 0
           END [ValorBase]
             --   ) 
      ,PGTO.NumeroEndosso											
	  ,CASE 
		  WHEN PRD.CodigoComercializado IN ('8119','8120','8121','8122','8123','8124','8125','3705','8114','8115','8116','8117','8118','3710','8191','3701', '3709', '8104', '8112', '8201') THEN '1'
		  ELSE PGTO.NumeroParcela 
	   END AS NumeroParcela
	     --, PGTO.NumeroParcela
         , PGTO.NumeroTitulo
         , PGTO.DataEndosso
         , PGTO.DataEfetivacao
		 ,teste.IDteste
     --into #VIDASN3    
FROM Dados.Pagamento PGTO     
INNER JOIN Dados.Proposta PRP
ON PRP.ID = PGTO.IDProposta
LEFT JOIN Dados.Contrato CNT
ON PRP.IDContrato = CNT.ID
LEFT JOIN Dados.Produto PRD
ON PRP.IDProduto = PRD.ID
OUTER APPLY (SELECT PRP2.Id as IDteste FROM Dados.Proposta PRP2 WHERE PRP2.NumeroProposta like 'SN'+PRP.NumeroProposta) teste
WHERE --PGTO.DataEndosso BETWEEN '2014-01-01' AND '2014-01-31' --EN.IDContrato = 6848629
--AND ((EN.IDPROPOSTA IS NOT NULL AND PRD.CodigoComercializado in ('9311', '9320'))
--     OR PRD.CodigoComercializado <> '9311')
--AND EN.IDTipoEndosso <> 0
--AND PRD.CodigoComercializado = '8121'
--AND
PGTO.Arquivo LIKE 'SSD.%'
AND NOT EXISTS (SELECT * 
                FROM Dados.PropostaAcordo PA
                           WHERE PA.IDProposta = PRP.ID
                           AND  EXISTS (SELECT *
                                           FROM Dados.Produtor PR
                                           WHERE PR.CPFCNPJ = '12.656.482/0001-11'
                                                      AND PR.ID = PA.IDProdutor
                                          )
                       )
AND PGTO.ValorPremioLiquido <> 0.0000000000
AND CASE WHEN teste.IDteste is  null and PRP.NumeroProposta not like 'SN%' then 0
when PRP.NumeroProposta like 'SN%' and IDteste IS null  then 0 
when PRP.NumeroProposta not like 'SN%' and IDteste IS not null  then 0 else 1 end = 0
--and  NumeroProposta in ('000082612977867','SN000082612977867')
AND PRD.CodigoComercializado <> '-1'



