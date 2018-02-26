CREATE VIEW Dados.vw_Emissoes_Prestamista_AIC_Teste
as

SELECT prp.NumeroProposta, prp.DataProposta, PRP.[DataAutenticacaoSICOB], C.DataArquivo, C.DataCancelamento, C.DataInicioVigencia, --C.Data ,
 CNT.NumeroContrato, PRD.CodigoComercializado, pp.Codigo [CodigoPeriodicidadePagamento], pp.Descricao [PeriodicidadePagamento], PRP.ValorPremioLiquidoEmissao
FROM Dados.Proposta PRP
INNER JOIN Dados.Contrato CNT
ON CNT.ID = PRP.IDContrato
LEFT JOIN Dados.Produto PRD
ON PRD.ID = PRP.IDProduto
LEFT JOIN Dados.PeriodoPagamento PP
ON PRP.IDPeriodicidadePagamento = PP.ID
LEFT JOIN Dados.Certificado C
ON C.IDProposta = PRP.ID
WHERE   CNT.NumeroContrato = '107700000011'
AND PRP.DataProposta >= '2015-01-01'
--and prp.NumeroProposta = '080014770017572'
--ORDER BY prp.DataProposta
