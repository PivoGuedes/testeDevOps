
/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaFechamentoComissao
	Descrição: Procedimento que realiza a consolidação (uma prévia sintética) para fechamento dos dados de
	           comissionamento.
		
		############
		SEMPRE QUE FOR ALTERADA DEVERÁ REFLETIR AS REGRAS NA FUNÇÃO PREVIAPROTHEUS
		############
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaFechamentoComissao](@PontoDeParadaIni DATE, @PontoDeParadaFim DATE)
RETURNS TABLE
AS
RETURN
/*DECLARE @PontoDeParadaIni DATE = '2012-12-01'
DECLARE @PontoDeParadaFim DATE = '2012-12-31'*/

/*CONSULTA CONSOLIDADORA DO FATURAMENTO POR DATA DE RECIBO*/

 SELECT 
         C.IDOperacao,		      
		 C.DataRecibo,
		 C.NumeroRecibo,
		 C.DataCompetencia,
		 --C.IDPROPOSTA,
         SUM(C.ValorBase) [ValorPremioLiquido],
         SUM(C.ValorComissaoPAR) [ValorComissao],
         SUM(C.ValorRepasse) [ValorRepasse]
		 
  FROM [Dados].[Comissao] C
  INNER JOIN Dados.Produtor PRT 
  ON  C.IDProdutor = PRT.ID
  INNER JOIN Dados.Produto PRD
  ON  PRD.ID = C.IDProduto
  WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
 -- LINHA COMENTADA POR RAZÃO DE ADIÇÃO DE CAMPOS NA TABELA DE COMISSÃO, ONDE OBTEMOS O CALCULO PROPORCIONAL. AND C.CodigoComercializado NOT IN ('7705', '7707')   --RETIRA O PRESTAMISTA QUE É TRATADO NO UNION ABAIXO (1º UNION)
  AND PRD.CodigoComercializado NOT IN ('8105', '3701')  -- RETIRADO PARA SER TRATADO NO UNION DO SAF ABAIXO (2º UNION)
  AND PRD.CodigoComercializado NOT IN ('4005', '4007', '4500', '6700', '6701') --RETIRADO RISCOS ESPECIAIS 
  --AND PRD.CodigoComercializado NOT IN ('7713') --RETIRADO CAIXA CRESCER-- COMENTADO POR PEDRO NO DIA 13/06/2016 A PEDIDO DE STEFANIA FERNANDES DA CONTROLADORIA.(SOLICITADO POR E-MAIL)
  AND PRD.CodigoComercializado NOT IN ('0') -- RETIRADO AJUSTE MANUAL
  AND C.IDEmpresa = 3
 GROUP BY 
        c.IDOperacao,		      
		c.DataRecibo,
		c.NumeroRecibo,
		c.DataCompetencia
		--,C.IDPROPOSTA
/*
/****************************************************************************************************/		   
/*AJUSTE DO PRESTAMISTA 5.5% DE COMISSÃO DA CORRETORA*/
/****************************************************************************************************/		   		
UNION ALL

SELECT A.IDProduto,
       A.IDRamo,
       A.IDCanalVendaPAR ,
       A.IDUnidadeVenda,
       A.IDFilialFaturamento, 
       --A.IDFilialPARCorretora,
       
       
       /*
       Cast(CASE WHEN A.NumeroParcela = 1 THEN 1
       ELSE 0
       END as bit) [VendaNova],
       */
       
       A.VendaNova,
       CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END ELSE NULL END [COM/SEMASVEN],
       0 [Repasse],
       A.DataRecibo,  
       (SELECT MIN(C1.DataCalculo) [DataRefInicial] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefInicial],
       (SELECT MAX(C1.DataCalculo) [DataRefFinal] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefFinal],
       Cast(YEAR(MIN(A.DataRecibo)) as  varchar(4)) + Cast(MONTH(MIN(A.DataRecibo)) as varchar(2)) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/
       Cast(SUM(A.[ValorPremioLiquido]) AS DECIMAL((32,4)) [ValorPremioLiquido],
       Cast(SUM(A.[ValorComissao]) AS DECIMAL((32,4)) [ValorComissao],
       count(A.IDProposta) [QuantidadeContratos]
FROM
(
  SELECT 
         C.IDProduto,
         C.IDRamo,
         IDCanalVendaPAR,
		     C.IDFilialFaturamento, 
         C.IDUnidadeVenda,
         --C.IDFilialPARCorretora,
         C.ASVEN,
         C.NumeroParcela,
         C.DataRecibo,
         C.ValorBase [ValorPremioLiquido],
         (C.ValorCorretagem * 5.50000) / 6.88000 [ValorComissao],
         C.IDProposta, 
         C.[VendaNova]
  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos] C

WHERE C.DataRecibo BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
  AND C.CodigoComercializado IN ('7705', '7707') -- TRATAMENTO DO PRESTAMISTA
  )  A
  INNER JOIN Dados.CanalVendaPAR CVP
  ON CVP.ID = A.IDCanalVendaPAR
GROUP BY A.IDProduto,
         A.IDRamo,
         A.IDCanalVendaPAR,
         A.IDUnidadeVenda,
         A.IDFilialFaturamento,
         --A.IDFilialPARCorretora,
         A.[VendaNova],
         A.ASVEN,
        CASE WHEN CVP.VendaAgencia = 1 THEN 
                                CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) 
                                     ELSE CAST(0 AS BIT) 
                                 END 
              ELSE NULL 
        END,		      
		A.DataRecibo	*/	
		
UNION ALL

/****************************************************************************************************/		   
/*AJUSTE DO SAF*/
/****************************************************************************************************/		   				

SELECT 
         C.IDOperacao,		      
		 C.DataRecibo,
		 C.NumeroRecibo,
		 C.DataCompetencia,
		 --C.IDPROPOSTA,
         SUM(C.ValorBase) [ValorPremioLiquido],
         SUM(C.ValorComissaoPAR) [ValorComissao],
         SUM(C.ValorRepasse) [ValorRepasse]
  FROM [Dados].[Comissao] C
  INNER JOIN Dados.Produtor PRT 
  ON  C.IDProdutor = PRT.ID
  INNER JOIN Dados.Produto PRD
  ON  PRD.ID = C.IDProduto
WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
  AND PRD.CodigoComercializado IN ('8105', '3701')  -- TRATAMENTO DO SAF ABAIXO
  AND (PRT.Codigo = '17256' OR C.IDOperacao = 7)   -- Produtor FPC OU AJUSTE MANUAL
  AND C.IDEmpresa = 3
GROUP BY 
        c.IDOperacao,		      
		c.DataRecibo,
		c.NumeroRecibo,
		c.DataCompetencia
		--,C.IDPROPOSTA
/****************************************************************************************************/		

--SELECT * FROM Dados.fn_RecuperaFechamentoComissao ('2014-02-26','2014-02-26') A WHERE NumeroRecibo = '20140008'	 ORDER BY NumeroRecibo
