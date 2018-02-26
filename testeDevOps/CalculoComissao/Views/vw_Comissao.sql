






CREATE VIEW [CalculoComissao].[vw_Comissao]
AS
SELECT CM.[ID]
      ,CM.[PercentualCorretagem]
      ,CM.[ValorCorretagem]
      ,CM.[ValorBase]
      ,CM.[ValorComissaoPAR]
      ,CM.[ValorRepasse]
      ,CM.[DataCompetencia]
      ,CM.[DataRecibo]
      ,CM.[NumeroRecibo]
      ,CM.[NumeroEndosso]
      ,CM.[NumeroParcela]
      ,CM.[DataCalculo]
      ,CM.[DataQuitacaoParcela]
      ,CM.[TipoCorretagem]
      ,CM.[CodigoSubgrupoRamoVida]
      --,CM.[IDCanalVendaPAR]
      --,CM.[NumeroProposta]
	  ,COALESCE(PRPCAPITALGLOBAL.NumeroProposta, PRP.NumeroProposta) NumeroProposta
	  ,CNT.NumeroContrato
      ,PRD.CodigoComercializado [CodigoProduto]
      ,CM.[Repasse]
      --,CM.[Arquivo]
      --,CM.[DataArquivo]
      --,CM.[IDEmpresa]
	  ,E.ID [IDEmpresa]
	  ,E.Nome [Empresa]
	  ,CM.IDOperacao
FROM Dados.Comissao CM
INNER JOIN Dados.Produto PRD
ON CM.IDProduto = PRD.ID
INNER JOIN Dados.Empresa E
ON E.ID = CM.IDEmpresa
CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP
LEFT JOIN Dados.Proposta PRP
ON PRP.ID = CM.IDProposta
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = CM.IDContrato
OUTER APPLY (SELECT NumeroProposta
             FROM Dados.Certificado CRT
			 INNER JOIN Dados.Proposta PRPM
			 ON PRPM.ID = CRT.IDProposta
			 WHERE CRT.NumeroCertificado = PRP.NumeroProposta
			 AND PRP.ID <> CRT.IDProposta
			) PRPCAPITALGLOBAL
 
--CROSS APPLY (
--             SELECT TOP 1 PH.IDProdutoSegmento 
--             FROM Dados.ProdutoHistorico PH
--             WHERE PRD.ID = PH.IDProduto 
--			 ORDER BY PRD.IDProdutoSIGPF, PH.DataInicio DESC
--            ) PH
WHERE IDEmpresa = 3 
  AND RP.Codigo = '06' -- VIDA
  AND  PRD.CodigoComercializado NOT IN ('8114', '8115', '8116', '8117', '8118', '8125')
  AND ISNULL(CM.LancamentoProvisao,0) = 0
  AND ISNULL(CM.LancamentoManual,0) = 0
--and CM.DataRecibo >= '2016-01-01' and CM.DataRecibo <= '2016-08-01'
--AND CM.DataRecibo >= '2016-01-01'

  
--SELECT * FROM DADOS.Empresa
--SELECT *
--FROM Dados.Ramo






