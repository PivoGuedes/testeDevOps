




CREATE VIEW [CalculoComissao].[vw_ComissaoHabitacional]
as
SELECT 
       C.[ID]
      ,[PercentualCorretagem]
      ,[ValorCorretagem]
      ,[ValorBase]
      ,[ValorComissaoPAR]
      ,[ValorRepasse]
      ,[DataCompetencia]
      ,[DataRecibo]
      ,[NumeroRecibo]
      ,[NumeroEndosso]
      ,[NumeroParcela]
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
      ,[TipoCorretagem]
      ,[CodigoSubgrupoRamoVida]
	  ,PRP.[NumeroProposta]
	  ,[NumeroContrato]
      ,PRD.[CodigoComercializado] CodigoProduto
      ,[Repasse]
	  ,[IDEmpresa]
	  ,E.Nome [Empresa]
	  ,CASE WHEN C.Arquivo <> 'COMI EXTRA REDE' THEN 'COMISSAO COMUM' ELSE 'COMI EXTRA REDE' END [Tipo]
FROM Dados.Comissao C
INNER JOIN Dados.Produto PRD
ON C.IDProduto = PRD.ID
INNER JOIN Dados.Empresa E
ON E.ID = C.IDEmpresa
LEFT JOIN Dados.Proposta PRP
ON PRP.ID = C.IDProposta
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = C.IDContrato
WHERE (   PRD.IDProdutoSIGPF IN (81, 68) 
       or PRD.IDRamoPAR IN (46)  
      )

AND ISNULL(C.LancamentoProvisao,0) = 0
--and C.DataRecibo >= '2016-01-01' and C.DataRecibo <= '2016-08-01'
--AND C.Arquivo <> 'COMI EXTRA REDE'
--AND PRP.NUMEROPROPOSTA = 'HB008444407360477'







