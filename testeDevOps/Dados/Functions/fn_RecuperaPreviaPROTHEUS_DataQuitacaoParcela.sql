
/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	Última alteração :  Gustavo -> Inclusão do campo DataQuitacaoParcela
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaPreviaPROTHEUS_DataQuitacaoParcela
	Descrição: Procedimento que realiza a consolidação (uma prévia) dos dados de
	           comissionamento. A prévia representa uma imagem do que está(ou estará)
	           no banco de faturamento para integração com o PROTHEUS.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaPreviaPROTHEUS_DataQuitacaoParcela](@PontoDeParadaIni DATE, @PontoDeParadaFim DATE, @IDEmpresa SMALLINT = 3 /*PARCORRETORA*/)
RETURNS TABLE
AS
RETURN
--DECLARE @PontoDeParadaIni DATE = '2013-11-01'
--DECLARE @PontoDeParadaFim DATE = '2013-12-31'

/*CONSULTA CONSOLIDADORA DO FATURAMENTO POR DATA DE RECIBO*/
SELECT A.IDProduto,
       A.CodigoComercializado,
       A.Produto,
       A.IDRamo,
       A.IDCanalVendaPAR ,
       A.IDUnidadeVenda,
       A.NomeUnidade,
       A.IDFilialFaturamento, 
       A.IDUnidadeEscritorioNegocio,
       A.IDFilialPARCorretora,
       A.IDRamoPAR,       
       
       /*
       Cast(CASE WHEN A.NumeroParcela = 1 THEN 1
       ELSE 0
       END as bit) [VendaNova],
       */
       A.IDOperacao,
       A.VendaNova,
       CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END ELSE NULL END [COM/SEMASVEN],
       A.MetaASVEN,
       A.MetaAVCaixa,
       A.RunOff,       
       0 [Repasse],
       A.DataRecibo,
       A.NumeroRecibo,
       A.DataQuitacaoParcela,
       --(SELECT MIN(C1.DataCalculo) [DataRefInicial] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefInicial],
       --(SELECT MAX(C1.DataCalculo) [DataRefFinal] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefFinal],
       MIN(A.DataCalculo) [DataRefInicial],
       MAX(A.DataCalculo) [DataRefFinal],
       --Cast(YEAR(MIN(A.DataRecibo)) as  varchar(4)) + Cast(MONTH(MIN(A.DataRecibo)) as varchar(2)) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/
       A.DataCompetencia,
       --Cast(YEAR(A.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(A.DataCompetencia) AS VARCHAR(2)),2) [Competencia], /*LINHA SUBSTITUTA DA LINHA ANTERIOR QUE TRATAVA COMPETÊNCIA - 2013/03/11*/       
       Cast(SUM(A.[ValorPremioLiquido]) AS DECIMAL(32,2)) [ValorPremioLiquido],
       Cast(SUM(A.[ValorComissao]) AS DECIMAL(32,2)) [ValorComissao],
       Cast(SUM(A.[ValorRepasse]) AS DECIMAL(32,2)) [ValorRepasse],
       count(A.IDProposta) [QuantidadeContratos]
FROM
(
  SELECT 
         C.IDProduto,
         C.CodigoComercializado,
         C.Produto,
         C.IDRamo,
         IDCanalVendaPAR,
         C.DataCalculo,
		     C.IDFilialFaturamento, 
         C.IDUnidadeVenda,
         C.NomeUnidade,
         C.IDUnidadeEscritorioNegocio,
         C.IDFilialPARCorretora,
         C.IDRamoPAR,
         C.ASVEN,
         C.MetaASVEN,
         C.MetaAVCaixa,
         C.RunOff,
         C.NumeroParcela,
         C.DataRecibo,
         C.NumeroRecibo,
         C.DataCompetencia,
		 C.DataQuitacaoParcela,
         C.ValorBase [ValorPremioLiquido],
         C.ValorComissaoPAR [ValorComissao],
         C.ValorRepasse [ValorRepasse],
         C.IDProposta, 
         C.[VendaNova],
         C.IDOperacao
  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos_DataQuitacaoParcela] C

  WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
 -- LINHA COMENTADA POR RAZÃO DE ADIÇÃO DE CAMPOS NA TABELA DE COMISSÃO, ONDE OBTEMOS O CALCULO PROPORCIONAL. AND C.CodigoComercializado NOT IN ('7705', '7707')   --RETIRA O PRESTAMISTA QUE É TRATADO NO UNION ABAIXO (1º UNION)
  AND C.CodigoComercializado NOT IN ('8105', '3701')  -- RETIRADO PARA SER TRATADO NO UNION DO SAF ABAIXO (2º UNION)
  AND C.CodigoComercializado NOT IN ('4500', '6700', '6701') --RETIRADO RISCOS ESPECIAIS 
  AND C.CodigoComercializado NOT IN ('7713') --RETIRADO CAIXA CRESCER
  AND C.CodigoComercializado NOT IN ('0') -- RETIRADO AJUSTE MANUAL
  AND C.IDEmpresa = @IDEmpresa
  )  A
  INNER JOIN Dados.CanalVendaPAR CVP
  ON CVP.ID = A.IDCanalVendaPAR
GROUP BY A.IDProduto,
         A.CodigoComercializado,
         A.Produto,
         A.IDRamo,
         A.IDCanalVendaPAR,
         A.IDUnidadeVenda,
         A.NomeUnidade,
         A.IDFilialFaturamento,
         A.IDUnidadeEscritorioNegocio,
         A.IDFilialPARCorretora,
         A.IDOperacao,
         A.IDRamoPAR,
         A.[VendaNova],
         A.ASVEN,
         A.MetaASVEN,
         A.MetaAVCaixa,
         A.RunOff,         
        CASE WHEN CVP.VendaAgencia = 1 THEN 
                                CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) 
                                     ELSE CAST(0 AS BIT) 
                                 END 
              ELSE NULL 
        END,		      
		A.DataRecibo,
		A.NumeroRecibo,
		A.DataQuitacaoParcela,
		A.DataCompetencia
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
       Cast(SUM(A.[ValorPremioLiquido]) AS DECIMAL(32,2)) [ValorPremioLiquido],
       Cast(SUM(A.[ValorComissao]) AS DECIMAL(32,2)) [ValorComissao],
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
SELECT A.IDProduto,
       A.CodigoComercializado,
       A.Produto,
       A.IDRamo,
       A.IDCanalVendaPAR ,
       A.IDUnidadeVenda,
       A.NomeUnidade,
       A.IDFilialFaturamento, 
       A.IDUnidadeEscritorioNegocio,
       A.IDFilialPARCorretora,
       A.IDRamoPAR,       
       
       /*
       Cast(CASE WHEN A.NumeroParcela = 1 THEN 1
       ELSE 0
       END as bit) [VendaNova],
       */
       A.IDOperacao,
       A.VendaNova,
       CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END ELSE NULL END [COM/SEMASVEN],
       A.MetaASVEN,
       A.MetaAVCaixa,
       A.RunOff,
       0 [Repasse],
       A.DataRecibo,
       A.NumeroRecibo,
	   A.DataQuitacaoParcela,
       --(SELECT MIN(C1.DataCalculo) [DataRefInicial] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefInicial],
       --(SELECT MAX(C1.DataCalculo) [DataRefFinal] FROM Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefFinal],
       MIN(A.DataCalculo) [DataRefInicial],
       MAX(A.DataCalculo) [DataRefFinal],
       --Cast(YEAR(MIN(A.DataRecibo)) as  varchar(4)) + Cast(MONTH(MIN(A.DataRecibo)) as varchar(2)) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/
       A.DataCompetencia,
       --Cast(YEAR(A.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(A.DataCompetencia) AS VARCHAR(2)),2) [Competencia], /*LINHA SUBSTITUTA DA LINHA ANTERIOR QUE TRATAVA COMPETÊNCIA - 2013/03/11*/       
       Cast(SUM(A.[ValorPremioLiquido]) AS DECIMAL(32,2)) [ValorPremioLiquido],
       Cast(SUM(A.[ValorComissao]) AS DECIMAL(32,2)) [ValorComissao],
       Cast(SUM(A.[ValorRepasse]) AS DECIMAL(32,2)) [ValorRepasse],
       count(A.IDProposta) [QuantidadeContratos]
FROM
(
  SELECT 
         C.IDProduto,
         C.CodigoComercializado,
         C.Produto,
         C.IDRamo,
         IDCanalVendaPAR,
         C.DataCalculo,
		 C.IDFilialFaturamento, 
         C.IDUnidadeVenda,
         C.NomeUnidade,
         C.IDUnidadeEscritorioNegocio,
         C.IDFilialPARCorretora,
         C.IDRamoPAR,
         C.ASVEN,
         C.MetaASVEN,
         C.MetaAVCaixa,
         C.RunOff,         
         C.NumeroParcela,
         C.DataRecibo,
         C.NumeroRecibo,
         C.DataCompetencia,
		 C.DataQuitacaoParcela,
         C.ValorBase [ValorPremioLiquido],
         C.ValorComissaoPAR [ValorComissao],
         C.ValorRepasse [ValorRepasse],
         C.IDProposta, 
         C.[VendaNova],
         C.IDOperacao
  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos_DataQuitacaoParcela] C
  INNER JOIN Dados.Produtor PRT 
  ON  C.IDProdutor = PRT.ID
WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
  AND C.CodigoComercializado IN ('8105', '3701')  -- TRATAMENTO DO SAF ABAIXO
  AND (PRT.Codigo = '17256' OR C.IDOperacao = 7)   -- Produtor FPC OU AJUSTE MANUAL
  AND C.IDEmpresa = @IDEmpresa
  )  A
  INNER JOIN Dados.CanalVendaPAR CVP
  ON CVP.ID = A.IDCanalVendaPAR
GROUP BY A.IDProduto,
         A.CodigoComercializado,
         A.Produto,
         A.IDRamo,
         A.IDCanalVendaPAR,
         A.IDUnidadeVenda,
         A.NomeUnidade,
         A.IDFilialFaturamento,
         A.IDUnidadeEscritorioNegocio,
         A.IDFilialPARCorretora,
         A.IDRamoPAR,
         A.IDOperacao,
         A.[VendaNova],
         A.ASVEN,
         A.MetaASVEN,
         A.MetaAVCaixa,
         A.RunOff,         
        CASE WHEN CVP.VendaAgencia = 1 THEN 
                                CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) 
                                     ELSE CAST(0 AS BIT) 
                                 END 
              ELSE NULL 
        END,		      
		A.DataRecibo,
		A.NumeroRecibo,
		A.DataQuitacaoParcela,
		A.DataCompetencia
/****************************************************************************************************/		
