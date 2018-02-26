
/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	Última alteração :  Gustavo -> 05/12/2013 - Inclusão do campo DataQuitacaoParcela, e número de parcelas 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaPreviaPROTHEUS_DataQuitacaoParcela_NUMEROPARCELA
	Descrição: Procedimento que realiza a consolidação (uma prévia) dos dados de
	           comissionamento. A prévia representa uma imagem do que está(ou estará)
	           no banco de faturamento para integração com o PROTHEUS.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaPreviaPROTHEUS_DataQuitacaoParcela_NUMEROPARCELA](@PontoDeParadaIni DATE, @PontoDeParadaFim DATE)
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
	   A.NumeroParcela,
	   A.IDProposta,
	   A.IDContrato,
	   A.NumeroEndosso,
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
         C.IDOperacao,
		 C.IDContrato,
		 C.NumeroEndosso
  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos_DataQuitacaoParcela] C

  WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim

  AND C.CodigoComercializado IN ('3101','3102','3104','3105','3107','3114','3120','3133','3136',
								 '3138','3142','3143','3144','3145','3146','3147','3148','3149',
								 '3172','3173','3174','3175','3176','3177','3178','3179','3180','3199','5302','5303','5304') 
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
		A.NumeroParcela,
		A.IDProposta,
	    A.IDContrato,
	    A.NumeroEndosso,
		A.DataCompetencia