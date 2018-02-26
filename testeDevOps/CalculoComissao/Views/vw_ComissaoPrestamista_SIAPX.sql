

CREATE VIEW [CalculoComissao].[vw_ComissaoPrestamista_SIAPX]
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
	  ,RIGHT(PRP.NumeroProposta,14) AS NumeroProposta
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
  AND C.IDContrato in (
                       SELECT ID
					   FROM Dados.Contrato C
					   WHERE C.NumeroContrato IN ('107700000022','107700000023','107700000038') 
					  )
	AND  C.LancamentoProvisao = 0
  --AND C.DataRecibo > '20141020'







