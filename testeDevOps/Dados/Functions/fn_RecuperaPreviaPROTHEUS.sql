

/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaPreviaPROTHEUS
	Descrição: Procedimento que realiza a consolidação (uma prévia) dos dados de
	           comissionamento. A prévia representa uma imagem do que está(ou estará)
	           no banco de faturamento para integração com o PROTHEUS.
		
		############
		SEMPRE QUE FOR ALTERADA DEVERÁ REFLETIR AS REGRAS NA FUNÇÃO FECHAMENTOCOMISSAO
		############
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/	
CREATE FUNCTION [Dados].[fn_RecuperaPreviaPROTHEUS](@PontoDeParadaIni DATE, @PontoDeParadaFim DATE, @IDEmpresa SMALLINT, @ExtraRede bit = 0)
RETURNS TABLE
AS
RETURN
--DECLARE @PontoDeParadaIni DATE = '2016-11-14'
--DECLARE @PontoDeParadaFim DATE = '2016-11-14'
--declare @IDEmpresa SMALLINT = 3, @ExtraRede bit = 0
/*CONSULTA CONSOLIDADORA DO FATURAMENTO POR DATA DE RECIBO*/
SELECT
       A.IDEmpresa,
	   A.IDProduto,
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
       A.[COM/SEMASVEN],
       A.MetaASVEN,
       A.MetaAVCaixa,
       A.RunOff,       
       0 [Repasse],
       A.DataRecibo,
       A.NumeroRecibo,
       
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
	   Cast(SUM(A.ValorCorretagem) AS DECIMAL(32,2)) ValorCorretagem,
	   --SUM(A.[ValorPremioLiquido])  [ValorPremioLiquido],
    --   SUM(A.[ValorComissao]) [ValorComissao],
    --   SUM(A.[ValorRepasse])  [ValorRepasse],
       count(A.IDProposta) [QuantidadeContratos],
	   IDSeguradora
FROM
(
  SELECT 
         C.IDEmpresa,
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
         C.ValorBase [ValorPremioLiquido],
         C.ValorComissaoPAR [ValorComissao],
         C.ValorRepasse [ValorRepasse],
		 C.ValorCorretagem,
         C.IDProposta, 
         C.[VendaNova],
         C.IDOperacao,
		 C.IDSeguradora,
		 CASE WHEN C.CanalVendaAgencia = 1 THEN CASE WHEN C.ASVEN = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END ELSE NULL END  [COM/SEMASVEN]

  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos] C
  WHERE C.DataCompetencia BETWEEN @PontoDeParadaIni AND @PontoDeParadaFim
 -- LINHA COMENTADA POR RAZÃO DE ADIÇÃO DE CAMPOS NA TABELA DE COMISSÃO, ONDE OBTEMOS O CALCULO PROPORCIONAL. AND C.CodigoComercializado NOT IN ('7705', '7707')   --RETIRA O PRESTAMISTA QUE É TRATADO NO UNION ABAIXO (1º UNION)
  AND C.IDEmpresa = @IDEmpresa
  AND 1 = CASE WHEN @ExtraRede = 1 AND C.Arquivo = 'COMI EXTRA REDE'  THEN 1
               WHEN @ExtraRede = 0 AND (C.Arquivo != 'COMI EXTRA REDE' OR C.Arquivo IS NULL) THEN 1 
		  ELSE 0 END
AND
   (
-------------#1
    (
       (
       ( (C.CodigoComercializado NOT IN ('8105', '3701')  -- RETIRADO PARA SER TRATADO NO UNION DO SAF ABAIXO (#2)
    AND C.CodigoComercializado NOT IN ('4005', '4007', '4500', '6700', '6701', '7714') --RETIRADO RISCOS ESPECIAIS 
    --AND C.CodigoComercializado NOT IN ('7713') --RETIRADO CAIXA CRESCER-- COMENTADO POR PEDRO NO DIA 13/06/2016 A PEDIDO DE STEFANIA FERNANDES DA CONTROLADORIA.(SOLICITADO POR E-MAIL)
    AND C.CodigoComercializado NOT IN ('0') -- RETIRADO AJUSTE MANUAL
	--        ISNULL(C.CodigoComercializado,'-1') NOT IN ('8105', '3701')  -- RETIRADO PARA SER TRATADO NO UNION DO SAF ABAIXO (#2)
 --   AND ISNULL(C.CodigoComercializado,'-1') NOT IN ('4005', '4007', '4500', '6700', '6701', '7714') --RETIRADO RISCOS ESPECIAIS 
 --   --AND C.CodigoComercializado NOT IN ('7713') --RETIRADO CAIXA CRESCER-- COMENTADO POR PEDRO NO DIA 13/06/2016 A PEDIDO DE STEFANIA FERNANDES DA CONTROLADORIA.(SOLICITADO POR E-MAIL)
 --   AND ISNULL(C.CodigoComercializado,'-1') NOT IN ('0') -- RETIRADO AJUSTE MANUAL
	)or ISNULL(C.CodigoComercializado,'-1') = '-1')



       ) OR DataRecibo < '2013-01-01' OR CodigoComercializado IS NULL
      )
-------------#2 Trata o produtor que deve ser eliminado partialmente
   OR
   (    (C.CodigoComercializado IN ('8105', '3701') or IDProduto in (760,761,763))  -- TRATAMENTO DO SAF ABAIXO
    AND (ISNULL(C.CodigoProdutor,17256) = 17256 OR C.IDOperacao = 7)   -- Produtor FPC OU AJUSTE MANUAL
    AND CASE WHEN C.DataRecibo < '2013-01-01' THEN 0 ELSE 1 END = 1
  )
-------------
)

  )  A
--WHERE NumeroRecibo = '2016110028'
--  INNER JOIN Dados.CanalVendaPAR CVP
--  ON CVP.ID = A.IDCanalVendaPAR
GROUP BY A.IDEmpresa, 
         A.IDProduto,
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
	     A.[COM/SEMASVEN] ,
		A.DataRecibo,
		A.NumeroRecibo,
		A.DataCompetencia,
		IDSeguradora
		
