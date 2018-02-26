

CREATE VIEW Marketing.vw_VidaFinanceiro_COMPERIODICIDADE
as
SELECT  
        EV.NumeroContrato, EV.NumeroBilhete, EV.NumeroCertificado, EV.NumeroProposta, EV.CodigoComercializado, EV.NomeProduto--EV.Descricao [NomeProduto]
      , COALESCE(EV.AgenciaVenda, EV.UnidadeVenda) AgenciaVenda, EV.ValorBase [PremioLiquido], EV.ValorComissao
      , EV.NumeroParcela, EV.DataQuitacaoParcela, EV.DataCalculo
      , COALESCE(CH.[CodigoPeriodoPagamento], PRP.[CodigoPeriodoPagamento]) [CodigoPeriodoPaGamento]
      , COALESCE(CH.[PeriodoPagamento], PRP.[PeriodoPagamento]) [PeriodoPagamento]
      , EV.CanalVenda, CO.Codigo [CodigoOperacao], CO.Descricao [DescricaoOperacao]
      , CASE  Dados.fn_VendaNova_Fluxo(EV.NumeroParcela, EV.NumeroEndosso, EV.ValorBase, EV.IDOperacao) WHEN 1 THEN 'Venda Nova' ELSE 'Fluxo' END [VendaNova]
--INTO EXTRACAOVIDA_20130614_COMPERIODICIDADE]
FROM [Extracao].[EXTRACAOVIDA] EV
INNER JOIN Dados.ComissaoOperacao CO
ON CO.ID = EV.IDOperacao
OUTER APPLY (SELECT TOP 1 Codigo [CodigoPeriodoPaGamento], Descricao [PeriodoPagamento]
             FROM Dados.CertificadoHistorico CH
             INNER JOIN Dados.PeriodoPagamento PP
             ON PP.ID = CH.IDPeriodoPagamento
             WHERE CH.IDCertificado = EV.IDCertificado             
             ORDER BY IDCertificado, ABS(DATEDIFF(dd,DataArquivo, EV.DataQuitacaoParcela)) ASC
             ) CH
OUTER APPLY (SELECT TOP 1 Codigo [CodigoPeriodoPagamento], Descricao [PeriodoPagamento]
             FROM Dados.Proposta PRP
             INNER JOIN Dados.PeriodoPagamento PP
             ON PP.ID = PRP.IDPeriodicidadePagamento
             WHERE PRP.NumeroProposta = EV.NumeroProposta
--             ORDER BY IDCertificado, DataArquivo DESC
             ) PRP             
/*INNER JOIN Dados.Produto PRD
ON PRD.ID = EV.IDProduto*/
