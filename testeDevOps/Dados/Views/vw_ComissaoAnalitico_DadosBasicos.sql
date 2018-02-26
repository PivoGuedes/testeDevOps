
/*
	Autor: Egler Vieira
	Data Criação: ?/?/2013

	Descrição: 
	
	Última alteração : Egler -  2013/03/12 -> Aplicação da função: Dados.fn_RecuperaUnidade_PointInTime
                     Egler -  2013/03/18 -> Aplicação da função: Dados.fn_RecuperaProduto_PointInTime
*/
/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_Unidade]
	Descrição: View que rastreia os dados basicos de comissão


  		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_ComissaoAnalitico_DadosBasicos]
--WITH SCHEMABINDING
AS 
SELECT  
 C.IDEmpresa,
 C.IDProduto,
 C.IDRamo,
 C.NumeroProposta,
 PH.CodigoComercializado,
 PH.Descricao [Produto],
 PH.MetaASVEN,
 PH.MetaAVCaixa,
 PH.RunOff,
 PH.IDRamoPAR,
 C.IDCanalVendaPAR, --(SELECT Dados.fn_CalculaCanalVendaPAR (PRP.NumeroProposta , PRD.CodigoComercializado,  NULL)) IDCanalVendaPAR,
 C.IDFilialFaturamento, 
 C.IDUnidadeVenda,
 UH.IDFilialPARCorretora,
 UH.ASVEN,
 UH.[DataReferenciaUnidade],
 UH.IDUnidadeEscritorioNegocio,
 UH.Nome [NomeUnidade],
 C.NumeroParcela,
 C.NumeroEndosso,
 C.NumeroRecibo,
 C.DataRecibo,
 C.DataCompetencia,
 C.PercentualCorretagem,
 C.ValorBase [ValorBase],
 C.ValorCorretagem [ValorCorretagem],
 C.ValorComissaoPAR [ValorComissaoPAR],
 C.ValorRepasse [ValorRepasse],
 C.IDProposta,  
 C.IDContrato,
 C.IDOperacao,
 C.DataCalculo,
 C.DataQuitacaoParcela,
 C.Arquivo,
 C.[CanalVendaAgencia],
  C.IDProdutor,
 C.CodigoProdutor,
  /*
 CASE WHEN NumeroParcela = 1 AND NumeroEndosso = 0 AND ValorBase > 0.000000 THEN CAST(1 AS BIT)        --WHEN C.NumeroEndosso < 2000 AND NumeroParcela = 0 THEN 'Fluxo' 
    WHEN NumeroParcela = 1 AND C.NumeroEndosso > 2000 AND ValorBase > 0.000000 THEN CAST(1 AS BIT)
    WHEN NumeroParcela = 0 AND NumeroEndosso IN (0,1) AND ValorBase > 0.000000 THEN CAST(1 AS BIT)
    
    WHEN NumeroParcela = 1 AND NumeroEndosso = 0 AND ValorBase < 0.000000 THEN CAST(0 AS BIT)       --WHEN C.NumeroEndosso < 2000 AND NumeroParcela = 0 THEN 'Fluxo' 
    WHEN NumeroParcela = 1 AND C.NumeroEndosso > 2000 AND ValorBase < 0.000000 THEN CAST(0 AS BIT)
    WHEN NumeroParcela = 0 AND NumeroEndosso IN (0,1) AND ValorBase < 0.000000 THEN CAST(0 AS BIT)
    
    WHEN NumeroParcela = 0 AND C.NumeroEndosso > 2000 THEN CAST(0 AS BIT)            
    WHEN (C.NumeroEndosso >= 1 AND C.NumeroEndosso < 2000 )  THEN CAST(0 AS BIT)
    WHEN C.IDOperacao = 8 THEN CAST(0 AS BIT)
    WHEN NumeroParcela > 1 THEN CAST(0 AS BIT)
    END*/
  Dados.fn_VendaNova_Fluxo(C.NumeroParcela, C.NumeroEndosso, C.ValorBase, C.IDOperacao) [VendaNova],
  c.IDSeguradora
  
 FROM Dados.Comissao C --WITH(NOEXPAND)
  OUTER APPLY Dados.fn_RecuperaUnidade_PointInTime(C.IDUnidadeVenda, C.DataCompetencia) UH 
  /*FOI CRIADO UMA FUNÇÃO GENERALIZADORA PARA BUSCAR OS DADOS DE UMA UNIDADE COM BASE EM UMA DATA (ÚLTIMA ATUALIZAÇÃO ATÉ A DATA DE REFERÊNCIA)*/
  /*Código abaixo comentado e substituído pela função em: 2013/03/12: Egler*/
  /* OUTER APPLY (SELECT TOP 1 UH.IDFilialPARCorretora,UH.ASVEN, UH.IDUnidadeEscritorioNegocio, UH.DataArquivo [DataReferenciaUnidade]
               FROM Dados.vw_UnidadeGeral UH
               WHERE UH.IDUnidade = C.IDUnidadeVenda
                 AND UH.DataArquivo <= C.DataCompetencia
               ORDER BY UH.IDUnidade ASC, UH.DataArquivo DESC, UH.ID DESC) UH  
   */
  OUTER APPLY Dados.fn_RecuperaProduto_PointInTime(C.IDProduto, C.DataCompetencia) PH
WHERE C.DataCompetencia > '0001-01-01'  


