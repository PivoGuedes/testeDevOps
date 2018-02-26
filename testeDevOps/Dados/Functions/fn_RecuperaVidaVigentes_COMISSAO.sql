

/*******************************************************************************
  Nome: CORPORATIVO.Dados.fn_RecuperaVidaVigentes_COMISSAO
  Descrição: Função auxiliar para buscar os Clientes de Vida que estão ativos estimados pelo comissionamento
  Data de Criação: 2013/07/08
  Criador: Egler Vieira
  Ultima atialização: 
		
	Parâmetros de entrada:
		@IDUnidade smallint
	Retorno:
		VARCHAR(20): ID do Produto
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.
	
*******************************************************************************/

CREATE FUNCTION Dados.fn_RecuperaVidaVigentes_COMISSAO(@ANOMES VARCHAR(8))
RETURNS TABLE
AS  
--DECLARE @ANOMES VARCHAR(8) = '201302'
--DECLARE @ANOMESDIAMIN DATE
--DECLARE @ANOMESDIAMAX DATE 

--SELECT @ANOMESDIAMIN = @ANOMES + '01'
--SELECT @ANOMESDIAMAX = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@ANOMESDIAMIN)+1,0))
RETURN
WITH CTE
AS
(
  SELECT RP.ID--, RP.Nome, RP.IDRamoMestre, 0 Nivel
  FROM Dados.RamoPAR RP
  WHERE RP.Codigo = '06'
  UNION ALL
  SELECT  RP1.ID--, RP1.Nome, RP1.IDRamoMestre, RP.Nivel + 1 [Nivel]
  FROM  Dados.RamoPAR RP1
  INNER JOIN CTE RP
  ON  RP1.IDRamoMestre = RP.ID    
 ),
ANOMES AS 
(
 SELECT Cast(@ANOMES + '01' AS DATE) [ANOMESDIAMIN], Cast(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@ANOMES + '01')+1,0)) AS DATE) [ANOMESDIAMAX]
) 
SELECT --  CM.IDContrato
       --, CM.IDCertificado
       CNT.NumeroContrato
     , CRT.NumeroCertificado
     , CNT.NumeroBilhete
     , PRP.NumeroProposta
     /*, CM.IDProduto*/
     , PRD.CodigoComercializado
     , PRD.Descricao [NomeProduto]
     , Sum(CM.ValorBase) ValorBase
     , PRP.ValorPremioTotal
     , PRP.Valor
     , CM.NumeroEndosso
     , COALESCE(UV.Codigo, AV.Codigo) [AgenciaVenda]  --, CM.IDUnidadeVenda, PRP.IDAgenciaVenda--, CRT.NomeCliente--, PC.Nome [NomeClienteProposta]
     /*, CRTB.NomeCliente*/, CM.NumeroParcela
     , CM.DataQuitacaoParcela
     , CM.DataCalculo
     , PRP.DataInicioVigencia
     , PRP.DataFimVigencia
     , COALESCE(CH.[CodigoPeriodoPagamento], PRP.[CodigoPeriodoPagamento]) [CodigoPeriodoPagamento]
     , COALESCE(CH.[PeriodoPagamento], PRP.[PeriodoPagamento]) [PeriodoPagamento]
     , CASE  Dados.fn_VendaNova_Fluxo(CM.NumeroParcela, CM.NumeroEndosso, Sum(CM.ValorBase), CM.IDOperacao) WHEN 1 THEN 'Venda Nova' ELSE 'Fluxo' END [VendaNova]
     , CO.Codigo [CodigoOperacao]
     , CO.Descricao [DescricaoOperacao]
--INTO [EXTRACAOVIDA_20130614]

FROM 
Dados.Comissao CM
INNER JOIN Dados.Produto PRD
ON PRD.ID = CM.IDProduto
LEFT JOIN Dados.CanalVendaPAR CV
ON CV.ID = CM.IDCanalVendaPAR
LEFT JOIN Dados.Certificado CRT
ON CRT.ID = CM.IDCertificado
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = CM.IDContrato
LEFT JOIN Dados.Certificado CRTB
ON CRTB.NumeroCertificado = CNT.NumeroBilhete
/*OUTER APPLY  Dados.PropostaCliente PC
ON PC.IDProposta = PRP.ID
LEFT JOIN Dados.ContratoCliente CC
ON CC.IDContrato = CNT.ID*/
LEFT JOIN Dados.Unidade UV
ON UV.ID = CM.IDUnidadeVenda
INNER JOIN Dados.ComissaoOperacao CO
ON CO.ID = CM.IDOperacao
OUTER APPLY (SELECT TOP 1 *
             FROM
             (
			 SELECT TOP 1 Codigo [CodigoPeriodoPagamento], Descricao [PeriodoPagamento], DataArquivo
             FROM Dados.CertificadoHistorico CH
             INNER JOIN Dados.PeriodoPagamento PP
             ON PP.ID = CH.IDPeriodoPagamento
             WHERE CH.IDCertificado = CM.IDCertificado   
             AND CH.DataArquivo <= CM.DataQuitacaoParcela
             ORDER BY IDCertificado, DataArquivo DESC --ABS(DATEDIFF(dd,DataArquivo, CM.DataQuitacaoParcela)) ASC
             UNION ALL
             SELECT TOP 1 Codigo [CodigoPeriodoPagamento], Descricao [PeriodoPagamento], DataArquivo
             FROM Dados.CertificadoHistorico CH
             INNER JOIN Dados.PeriodoPagamento PP
             ON PP.ID = CH.IDPeriodoPagamento
             WHERE CH.IDCertificado = CM.IDCertificado   
             AND CH.DataArquivo >= CM.DataQuitacaoParcela
             ORDER BY IDCertificado, DataArquivo ASC
             ) A
             ORDER BY A.DataArquivo ASC
             ) CH  /*RECUPERA A ÚLTIMA PERIODICIDADE DE PAGAMENTO DO CERTIFICADO*/
OUTER APPLY (SELECT TOP 1 Codigo [CodigoPeriodoPagamento]
                        , Descricao [PeriodoPagamento]
                        , PRP.NumeroProposta
                        , PRP.ValorPremioTotal
                        , PRP.Valor
                        , PRP.IDAgenciaVenda
                        , PRP.DataInicioVigencia
                        , PRP.DataFimVigencia
             FROM Dados.Proposta PRP
             INNER JOIN Dados.PeriodoPagamento PP
             ON PP.ID = PRP.IDPeriodicidadePagamento
             WHERE CM.IDProposta = PRP.ID
             ORDER BY IDCertificado, DataArquivo DESC
             ) PRP  /*RECUPERA A ÚLTIMA PERIODICIDADE DE PAGAMENTO DA PROPOSTA*/
LEFT JOIN Dados.Unidade AV
ON AV.ID = PRP.IDAgenciaVenda 
FULL OUTER JOIN ANOMES
ON 1 = 1            
WHERE 
       CM.DataCompetencia BETWEEN ANOMES.ANOMESDIAMIN AND ANOMES.ANOMESDIAMAX
   AND CM.IDOperacao <> 8 
   AND PRD.IDRamoPAR IN (SELECT CTE.ID
                         FROM CTE
                        )   
                 
GROUP BY /*CM.IDContrato, CM.IDCertificado
	 ,*/ CNT.NumeroContrato, CRT.NumeroCertificado, CNT.NumeroBilhete, PRP.NumeroProposta
     , PRP.ValorPremioTotal, PRP.Valor, UV.Codigo, AV.Codigo, CV.Nome--, PC.Nome,
     --, CM.IDUnidadeVenda, PRP.IDAgenciaVenda--, CRT.NomeCliente, CRTB.NomeCliente
     , CM.NumeroParcela, CM.DataQuitacaoParcela, CM.DataCalculo
     , PRP.DataInicioVigencia, PRP.DataFimVigencia                                   
     , CM.NumeroEndosso, CM.IDOperacao, CM.IDProduto, PRD.CodigoComercializado 
     , PRD.Descricao, COALESCE(CH.[CodigoPeriodoPagamento], PRP.[CodigoPeriodoPagamento])
     , COALESCE(CH.[PeriodoPagamento], PRP.[PeriodoPagamento])
     , CO.Codigo
     , CO.Descricao

--SELECT * FROM Dados.fn_RecuperaVidaVigentes_COMISSAO('201302') A
