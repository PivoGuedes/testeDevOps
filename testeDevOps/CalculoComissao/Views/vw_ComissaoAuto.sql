
CREATE VIEW [CalculoComissao].[vw_ComissaoAuto]
AS
SELECT ROW_NUMBER() OVER (ORDER BY NumeroContrato,prp.NumeroProposta,NumeroEndosso,NumeroParcela,CM.DataArquivo) ID--CM.[ID]
      ,SUM(CM.[PercentualCorretagem] ) AS [PercentualCorretagem]
      ,SUM(CM.[ValorCorretagem]) AS [ValorCorretagem]
      ,SUM(CM.[ValorBase]) AS [ValorBase]
      ,SUM(CM.[ValorComissaoPAR]) AS [ValorComissaoPAR]
      ,SUM(CM.[ValorRepasse]) AS [ValorRepasse]
      ,CM.[DataCompetencia]
      ,CM.[DataArquivo] AS [DataRecibo]
      ,CM.[NumeroRecibo]
      ,CM.[NumeroEndosso]
      ,CM.[NumeroParcela]
      ,CM.[DataCalculo]
      ,CM.[DataQuitacaoParcela]
      ,CM.[TipoCorretagem]
      ,NULL AS [CodigoSubgrupoRamoVida]
      --,CM.[IDCanalVendaPAR]
      --,CM.[NumeroProposta]
	  ,PRP.NumeroProposta
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
--OUTER APPLY (SELECT NumeroProposta
--             FROM Dados.Certificado CRT
--			 INNER JOIN Dados.Proposta PRPM
--			 ON PRPM.ID = CRT.IDProposta
--			 WHERE CRT.NumeroCertificado = PRP.NumeroProposta
--			 AND PRP.ID <> CRT.IDProposta
--			) PRPCAPITALGLOBAL
 
--CROSS APPLY (
--             SELECT TOP 1 PH.IDProdutoSegmento 
--             FROM Dados.ProdutoHistorico PH
--             WHERE PRD.ID = PH.IDProduto 
--			 ORDER BY PRD.IDProdutoSIGPF, PH.DataInicio DESC
--            ) PH
WHERE IDEmpresa = 3 
  AND RP.Codigo = '01' -- AUTO
  --and CodigoComercializado = '3177'
  
  AND CM.DataArquivo >= '2015-01-01'
  AND  ISNULL(CM.LancamentoProvisao,0) = 0
GROUP BY CM.[DataCompetencia]
      ,CM.[DataArquivo]
      ,CM.[NumeroRecibo]
      ,CM.[NumeroEndosso]
      ,CM.[NumeroParcela]
      ,CM.[DataCalculo]
      ,CM.[DataQuitacaoParcela]
      ,CM.[TipoCorretagem]
      --,CM.[CodigoSubgrupoRamoVida]
      --,CM.[IDCanalVendaPAR]
      --,CM.[NumeroProposta]
	  ,PRP.NumeroProposta
	  ,CNT.NumeroContrato
      ,PRD.CodigoComercializado
      ,CM.[Repasse]
      --,CM.[Arquivo]
      --,CM.[DataArquivo]
      --,CM.[IDEmpresa]
	  ,E.ID 
	  ,E.Nome 
	  ,CM.IDOperacao

  
--SELECT * FROM DADOS.Empresa


--SELECT *
--FROM Dados.Produto prd
--CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP
--where CodigoComercializado in ('3177','3178')
--sp_who2 64





