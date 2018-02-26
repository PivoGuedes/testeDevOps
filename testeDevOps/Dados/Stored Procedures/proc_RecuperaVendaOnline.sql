
CREATE PROCEDURE [Dados].[proc_RecuperaVendaOnline]  @Data DATE  --= '2016-05-23'
AS

--DECLARE @Data DATE  = '2017-09-27'

SET @Data = DATEADD(DD, -1, @Data)

--Prestamista, Residencial, Vida PF-PM, Vida PF-PU
SELECT 
	 CAST(CONCAT(YEAR(PA.DataVenda), FORMAT(MONTH(PA.DataVenda), '00')) AS INT) AS ANO_MES_COMPETENCIA
	,PA.DataVenda AS DATA_VENDA_AIC
	,DAY(PA.DataVenda) AS DIA
    ,DATEPART(HOUR, PA.HoraVenda) AS HORA
    ,DATEPART(MINUTE, PA.HoraVenda) AS MINUTO
	,U.Codigo AS AGENCIA
	,PA.IDProposta AS COD_PROPOSTA
	,PRPA.Nome AS PRODUTO
	,CAST(1 AS INT) AS EMITIDO
	,GETDATE() AS DataCargaSSIS
	,ISNULL(CAST(NULL AS INT), 0) AS VENDIDO_PROPOSTA
	,(CASE 
		WHEN TipoSeguro=1 THEN 'Renovacao' 
		WHEN TipoSeguro=0 THEN 'Venda Nova'
		ELSE ''END) AS TipoSeguro 
	,PA.ValorPremio
FROM Dados.PropostaAIC PA
INNER JOIN Dados.Unidade U ON PA.IDUnidade = U.ID
--LEFT JOIN Dados.ParametroProdutoAIC PPA
--ON PPA.CodigoProduto = PA.GuidCodigoProdutoAIC
--LEFT JOIN Dados.ProdutoSIGPF PS
--ON PS.CodigoProduto = PPA.CodigoProdutoSIVPF
LEFT JOIN Dados.ProdutoSIGPF PS ON PA.IDProdutoSIGPF = PS.ID
--LEFT JOIN Dados.Proposta PRP
--ON PRP.ID = PA.IDProposta
OUTER APPLY (SELECT TOP 1 PRPA.Nome
	         FROM Dados.ProdutoPropostaAIC PRPA 
			 WHERE PRPA.IDProdutoSIGPF = PA.IDProdutoSIGPF
					AND PRPA.IDTipoPagamento = PA.IDTipoPagamento
					AND PRPA.IDTipoPessoa = PA.DescricaoTipoPessoa
					AND PRPA.DataInicio <= GETDATE()
			) PRPA
WHERE (EXISTS (SELECT * 
			  FROM Dados.Certificado C
			  WHERE C.IDProposta = PA.IDProposta
			  )
   OR EXISTS (SELECT *
			  FROM Dados.Contrato CNT
			  WHERE CNT.IDProposta = PA.IDProposta
			  )
   OR EXISTS (
              SELECT *
			  FROM Dados.Endosso EN
			  WHERE EN.IDProposta = PA.IDProposta
			 )
   OR EXISTS (
              SELECT *
			  FROM Dados.PropostaPrevidenciaCertificado PPC
			  WHERE PPC.IDProposta = PA.IDProposta
			 ))
AND PA.DataArquivo >= @Data
AND PRPA.Nome IS NOT NULL

UNION ALL

SELECT 
	 CAST(CONCAT(YEAR(PA.DataVenda), FORMAT(MONTH(PA.DataVenda), '00')) AS INT) AS ANO_MES_COMPETENCIA
	,PA.DataVenda AS DATA_VENDA_AIC
	,DAY(PA.DataVenda) AS DIA
    ,DATEPART(HOUR, PA.HoraVenda) AS HORA
    ,DATEPART(MINUTE, PA.HoraVenda) AS MINUTO
	,U.Codigo AS AGENCIA
	,PA.IDProposta AS COD_PROPOSTA
	,PRPA.Nome AS PRODUTO
	,CAST(0 AS INT) AS EMITIDO
	,GETDATE() AS DataCargaSSIS
	,ISNULL(CAST(NULL AS INT), 0) AS VENDIDO_PROPOSTA
	,(CASE 
		WHEN TipoSeguro=1 THEN 'Renovacao' 
		WHEN TipoSeguro=0 THEN 'Venda Nova'
		ELSE ''END) AS TipoSeguro 
	,PA.ValorPremio
FROM Dados.PropostaAIC PA
INNER JOIN Dados.Unidade U ON PA.IDUnidade = U.ID
--LEFT JOIN Dados.ParametroProdutoAIC PPA
--ON PPA.CodigoProduto = PA.GuidCodigoProdutoAIC
--LEFT JOIN Dados.ProdutoSIGPF PS
--ON PS.CodigoProduto = PPA.CodigoProdutoSIVPF
LEFT JOIN Dados.ProdutoSIGPF PS ON PA.IDProdutoSIGPF = PS.ID
--LEFT JOIN Dados.Proposta PRP
--ON PRP.ID = PA.IDProposta
OUTER APPLY (SELECT TOP 1 PRPA.Nome
	         FROM Dados.ProdutoPropostaAIC PRPA 
			 WHERE PRPA.IDProdutoSIGPF = PA.IDProdutoSIGPF
					AND PRPA.IDTipoPagamento = PA.IDTipoPagamento
					AND PRPA.IDTipoPessoa = PA.DescricaoTipoPessoa
					AND PRPA.DataInicio <= GETDATE()
			) PRPA
WHERE (NOT EXISTS (SELECT * 
			  FROM Dados.Certificado C
			  WHERE C.IDProposta = PA.IDProposta
			  )
   AND NOT EXISTS (SELECT *
			  FROM Dados.Contrato CNT
			  WHERE CNT.IDProposta = PA.IDProposta
			  )
   AND NOT EXISTS (
              SELECT *
			  FROM Dados.Endosso EN
			  WHERE EN.IDProposta = PA.IDProposta
			 )
   AND NOT EXISTS (
              SELECT *
			  FROM Dados.PropostaPrevidenciaCertificado PPC
			  WHERE PPC.IDProposta = PA.IDProposta
			 ))
AND PA.DataArquivo >= @Data
AND PRPA.Nome IS NOT NULL

UNION ALL

SELECT 
	 CAST(CONCAT(YEAR(SA.DataArquivo), FORMAT(MONTH(SA.DataArquivo), '00')) AS INT) AS ANO_MES_COMPETENCIA
	,SA.DataArquivo AS DATA_VENDA_AIC
	,DAY(SA.DataArquivo) AS DIA
    ,11 AS HORA
    ,0 AS MINUTO
	,U.Codigo AS AGENCIA
	,SA.IDProposta AS COD_PROPOSTA
	,'Auto' AS PRODUTO
	,CAST(0 AS INT) AS EMITIDO
	,GETDATE() AS DataCargaSSIS
	,ISNULL(CAST(0 AS INT), 0) AS VENDIDO_PROPOSTA
	,'' AS TipoSeguro 
	,sa.ValorPremio
FROM Dados.SimuladorAuto SA
INNER JOIN Dados.Proposta PRP ON SA.IDProposta = PRP.ID
INNER JOIN Dados.Unidade U ON U.ID = SA.IDAgenciaVenda
WHERE (SA.IDSituacaoCalculo = 4
AND NOT EXISTS (SELECT *
				FROM Dados.Endosso EN
				WHERE EN.IDProposta = SA.IDProposta)
AND SA.DataArquivo >= '2016-01-01')
AND SA.DataArquivo >= @Data

UNION ALL

SELECT 
	 CAST(CONCAT(YEAR(SA.DataArquivo), FORMAT(MONTH(SA.DataArquivo), '00')) AS INT) AS ANO_MES_COMPETENCIA
	,SA.DataArquivo AS DATA_VENDA_AIC
	,DAY(SA.DataArquivo) AS DIA
    ,11 AS HORA
    ,0 AS MINUTO
	,U.Codigo AS AGENCIA
	,SA.IDProposta AS COD_PROPOSTA
	,'Auto' AS PRODUTO
	,CAST(1 AS INT) AS EMITIDO
	,GETDATE() AS DataCargaSSIS
	,ISNULL(CAST(0 AS INT), 0) AS VENDIDO_PROPOSTA
	,'' AS TipoSeguro 
	,sa.ValorPremio
FROM Dados.SimuladorAuto SA
INNER JOIN Dados.Proposta PRP ON SA.IDProposta = PRP.ID
INNER JOIN Dados.Unidade U ON U.ID = SA.IDAgenciaVenda
WHERE (SA.IDSituacaoCalculo = 4
AND EXISTS (SELECT *
            FROM Dados.Endosso EN
			WHERE EN.IDProposta = SA.IDProposta)
AND SA.DataArquivo >= '2016-01-01')
AND SA.DataArquivo >= @Data

OPTION(OPTIMIZE FOR (@Data UNKNOWN))

--EXEC Dados.proc_RecuperaVendaOnline  @Data = '2016-05-27'
