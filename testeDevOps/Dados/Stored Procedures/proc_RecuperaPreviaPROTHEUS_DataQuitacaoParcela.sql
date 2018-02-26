
/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	Última alteração : Egler -> 2013/03/12: Aplicação da função Dados.fn_RecuperaUnidade_PointInTime 
					   Gustavo -> 2013/11/25: Inclusão do Campo DataQuitacaoParcela.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaPreviaPROTHEUS_DataQuitacaoParcela
	Descrição: Procedimento que realiza a consolidação (uma prévia) dos dados de
	           comissionamento, agregando à função [fn_RecuperaPreviaPROTHEUS]
	           os descritivos referentes aos IDs retornados.
	           A prévia representa uma imagem do que está(ou estará)
	           no banco de faturamento para integração com o PROTHEUS.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_RecuperaPreviaPROTHEUS_DataQuitacaoParcela](@PontoDeParadaIni DATE, @PontoDeParadaFim DATE, @IDEmpresa SMALLINT = 3 /*PARCORRETORA*/)
AS
--DECLARE @PontoDeParadaIni DATE = '2013-11-01'
--DECLARE @PontoDeParadaFim DATE = '2013-12-31'

SELECT        
       PP.CodigoComercializado [CodigoComercializado],
       PP.Produto [NomeProduto],
       COALESCE(R2.Codigo, R1.Codigo, R.Codigo) [CodigoRamo1],
       COALESCE(R2.Nome, R1.Nome, R.Nome) [NomeRamo1],
       COALESCE(R1.Codigo, R.Codigo) [CodigoRamo2],
       COALESCE(R1.Nome, R.Nome) [NomeRamo2],
       R.Codigo [CodigobRamo3],
       R.Nome [NomeRamo3],
       PP.IDCanalVendaPAR,
       HRQ.Codigo [CodigoCanalVenda], 
       HRQ.CodigoHierarquico,
       CVP.Nome [CanalVenda],
       FF.Codigo [CodigoFilialFaturamento],
       FF.Nome [NomeFilialFaturamento],
       COALESCE(FP.ID, FP1.ID) [IDFilialPARCorretora],
       COALESCE(FP.Nome, FP1.Nome) [NomeFilialParCorretora],
       
       CASE WHEN PP.VendaNova = 1 THEN 'Venda Nova' WHEN PP.VendaNova = 0 THEN 'Fluxo' ELSE NULL END [VendaNova],
       CASE WHEN PP.[COM/SEMASVEN] = 1 THEN 'Com ASVEN' WHEN PP.[COM/SEMASVEN] = 0 THEN 'Sem ASVEN' ELSE NULL END [COM/SEMASVEN],
       PP.MetaASVEN,
       PP.MetaAVCaixa,
       PP.RunOff,
       CASE WHEN PP.[Repasse] = 1 THEN 'Sim' WHEN PP. [Repasse] = 0 THEN 'Não' ELSE NULL END  [Repasse],
       PP.DataRecibo, 
	   PP.DataQuitacaoParcela,      
       MIN(PP.[DataRefInicial]) [DataRefInicial],
       MAX(PP.[DataRefFinal]) [DataRefFinal],
       U.Codigo [CodigoUnidade], 
       PP.[NomeUnidade],
       EN.Codigo [CodigoEscritorioDeNegocio], 
       EN.Nome [NomeEscritorioDeNegocio],            
       Cast(YEAR(PP.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(PP.DataCompetencia) AS VARCHAR(2)),2) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013: => Dúvida sanada em 11/03/2013 (Uma nova coluna foi criada para ajuste manual do ator)*/
       SUM(PP.[ValorPremioLiquido]) [ValorPremioLiquido],
       SUM(PP.[ValorComissao]) [ValorComissao],
       SUM(PP.[QuantidadeContratos]) [QuantidadeContratos]

/*	   
--Lincoln
/***********************************************/
	   CP.[ValorBase],
	   CP.[ValorCorretagem],
	   CP.[PercentualCorretagem],
	   CP.[ValorComissaoPAR],
	   CP.[DataCompetencia],
	   CP.[DataRecibo],
	   CP.[DataArquivo]
/***********************************************/
*/
	                      
FROM

  /****************************************************************************************************/
  Dados.fn_RecuperaPreviaPROTHEUS_DataQuitacaoParcela(@PontoDeParadaIni, @PontoDeParadaFim, @IDEmpresa) PP
  /****************************************************************************************************/	

/*
--Lincoln (tabela produto estava comentada)
/************************************/
  INNER JOIN Dados.Produto PRD 
  ON PRD.ID = PP.IDProduto
/************************************/


--Lincoln (tabela comissão inserida no script)
/***********************************************/
  LEFT JOIN [Dados].[Comissao_Partitioned] CP
  ON PP.IDProduto = CP.IDProduto
/***********************************************/

*/

  INNER JOIN Dados.FilialFaturamento FF
  ON PP.IDFilialFaturamento = FF.ID
  LEFT JOIN Dados.RamoPAR R
  ON PP.IDRamoPAR = R.ID
  LEFT JOIN Dados.RamoPAR R1
  ON R1.ID = R.IDRamoMestre
  LEFT JOIN Dados.RamoPAR R2
  ON R2.ID = R1.IDRamoMestre
  LEFT JOIN Dados.CanalVendaPAR CVP
  ON CVP.ID = PP.IDCanalVendaPAR
  LEFT JOIN Dados.Unidade U
  ON PP.IDUnidadeVenda = U.ID
  /**************************************************************************************/
  /*Busca a última atualização do Escritório de Negócio*/  
  /*Egler Vieira - 2013/03/12*/
  /**************************************************************************************/  
  OUTER APPLY Dados.fn_RecuperaUnidade_PointInTime(PP.IDUnidadeEscritorioNegocio, PP.DataCompetencia) EN
  /**************************************************************************************/    
  LEFT JOIN Dados.vw_RetornaHierarquiaCanaisAtivos HRQ1
  ON HRQ1.ID = PP.IDCanalVendaPAR
  LEFT JOIN Dados.vw_RetornaHierarquiaCanaisAtivos HRQ
  ON HRQ.CodigoHierarquico = LEFT(HRQ1.CodigoHierarquico, 4)
  LEFT JOIN Dados.FilialPARCorretora FP
  ON FP.ID = EN.IDFilialPARCorretora
  LEFT JOIN Dados.FilialPARCorretora FP1
  ON FP1.ID = PP.IDFilialPARCorretora

GROUP BY PP.CodigoComercializado,
         PP.Produto,  
	
/*	 
--Lincoln
/******************************************/	 
		 CP.[ValorBase],
		 CP.[ValorCorretagem],
		 CP.[PercentualCorretagem],
		 CP.[ValorComissaoPAR],
		 CP.[DataCompetencia],
		 CP.[DataRecibo],
		 CP.[DataArquivo],
/******************************************/	 
*/	         		 
		 R2.Codigo,
         R2.Nome,
         R1.Codigo,
         R1.Nome,
         R.Codigo,
         R.Nome,
         PP.IDCanalVendaPAR,
         HRQ.Codigo,
         HRQ.CodigoHierarquico,
         CVP.Nome,
         FF.Codigo,
         FF.Nome,
         COALESCE(FP.ID, FP1.ID),
         COALESCE(FP.Nome, FP1.Nome),
         U.Codigo,
         PP.NomeUnidade,
         EN.Codigo,
         EN.Nome,
         CASE WHEN PP.VendaNova = 1 THEN 'Venda Nova' WHEN PP.VendaNova = 0 THEN 'Fluxo' ELSE NULL END,
         CASE WHEN PP.[COM/SEMASVEN] = 1 THEN 'Com ASVEN' WHEN PP.[COM/SEMASVEN] = 0 THEN 'Sem ASVEN' ELSE NULL END,
         PP.MetaASVEN,
         PP.MetaAVCaixa,
         PP.RunOff,
         CASE WHEN PP.[Repasse] = 1 THEN 'Sim' WHEN PP. [Repasse] = 0 THEN 'Não' ELSE NULL END,
         PP.DataRecibo, 
		 PP.DataQuitacaoParcela,      
         --PP.[DataRefInicial],
         --PP.[DataRefFinal],
         Cast(YEAR(PP.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(PP.DataCompetencia) AS VARCHAR(2)),2)  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013: => Dúvida sanada em 11/03/2013 (Uma nova coluna foi criada para ajuste manual do ator)*/
		 
		 		 
--ORDER BY CodigoComercializado, [Bloco], CanalVenda, [FilialFaturamento], [VendaNova], [COM/SEMASVEN], [Repasse]
	
--EXEC Dados.proc_RecuperaPreviaPROTHEUS '2013-05-15', '2013-05-15'
