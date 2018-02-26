



CREATE VIEW [CalculoComissao].[vw_ComissaoPrestamista_AIC]
AS
SELECT C.[ID]
      ,C.[PercentualCorretagem]
      ,C.[ValorCorretagem]
      ,C.[ValorBase]
      ,C.[ValorComissaoPAR]
      ,C.[ValorRepasse]
      ,C.[DataCompetencia]
      ,C.[DataRecibo]
      ,C.[NumeroRecibo]
      ,C.[NumeroEndosso]
      ,C.[NumeroParcela]
      ,C.[DataCalculo]
      ,C.[DataQuitacaoParcela]
      ,C.[TipoCorretagem]
      ,C.[CodigoSubgrupoRamoVida]
      --,CM.[IDCanalVendaPAR]
      --,CM.[NumeroProposta]
	  ,PRP.NumeroProposta
	  ,CNT.NumeroContrato
      ,P.CodigoComercializado [CodigoProduto]
      ,C.[Repasse]
	  ,C.IDProdutor
      --,CM.[Arquivo]
      --,CM.[DataArquivo]
      --,CM.[IDEmpresa]
	  ,E.ID [IDEmpresa]
	  ,E.Nome [Empresa]
FROM Dados.Comissao C
INNER JOIN Dados.Produto P
ON C.IDProduto = P.ID
INNER JOIN Dados.RamoPAR RP
ON P.IDRamoPAR = RP.ID
INNER JOIN Dados.Empresa E
ON E.ID = C.IDEmpresa
LEFT JOIN Dados.Proposta PRP
ON PRP.ID = C.IDProposta
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = C.IDContrato
WHERE RP.ID IN (34, 47, 4)
  AND C.IDEmpresa = 3 
  AND C.IDContrato NOT in (
                       SELECT ID
					   FROM Dados.Contrato C
					   WHERE C.NumeroContrato IN ('107700000022','107700000023','107700000038') 
					  )
  AND (CASE WHEN P.CodigoComercializado = '9313' AND C.DataArquivo < '2014-06-09' THEN 0
          ELSE 1
	 END) = 1
  AND C.DataArquivo >= '2014-01-01' 
  AND P.CodigoComercializado <> '9306'
  AND P.CodigoComercializado <> '3708'
  AND ISNULL(C.LancamentoProvisao,0) = 0


