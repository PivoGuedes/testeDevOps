CREATE VIEW Marketing.vw_VidaFinanceiro_12_13
as
SELECT --TOP 10000 
        EV.NumeroContrato, EV.NumeroBilhete, EV.NumeroCertificado, EV.NumeroProposta, EV.CodigoComercializado, EV.NomeProduto--EV.Descricao [NomeProduto]
      , COALESCE(EV.AgenciaVenda, EV.UnidadeVenda) AgenciaVenda, EV.ValorBase [PremioLiquido]
      , EV.NumeroParcela, EV.DataQuitacaoParcela, EV.DataCalculo
      , EV.CanalVenda, CO.Codigo [CodigoOperacao], CO.Descricao [DescricaoOperacao]
      , CASE  Dados.fn_VendaNova_Fluxo(EV.NumeroParcela, EV.NumeroEndosso, EV.ValorBase, EV.IDOperacao) WHEN 1 THEN 'Venda Nova' ELSE 'Fluxo' END [VendaNova]  
FROM [EXTRACAOVIDA_20130614] EV
INNER JOIN Dados.ComissaoOperacao CO
ON CO.ID = EV.IDOperacao
/*INNER JOIN Dados.Produto PRD
ON PRD.ID = EV.IDProduto*/