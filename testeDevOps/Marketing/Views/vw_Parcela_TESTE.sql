CREATE VIEW Marketing.vw_Parcela_TESTE
as

SELECT  PRP.ID, PRP.NumeroProposta, PRP.DataProposta, PRP.DataInicioVigencia, PRP.DataFimVigencia
      , PRP.ValorPremioTotal, /*PRP.Valor [ValorParcela_Proposta],*/ PRP.ValorComissaoSICOB, MP.DiaVencimento, PA.QuantidadeParcelas
      , PGTOA.[DataEmissaoArquivo], PGTO.NumeroParcela, PGTO.DataVencimentoParcela, PGTO.DataArquivo [DataPagamentoArquivo]
      , PGTO.Valor [ValorPago]
FROM Dados.Proposta PRP
CROSS APPLY (SELECT TOP 1 DiaVencimento
             FROM Dados.MeioPagamento MP
             WHERE MP.DiaVencimento <> 0
               AND MP.IDProposta = PRP.ID
             ORDER BY DataArquivo DESC
             ) MP
CROSS APPLY (SELECT DISTINCT QuantidadeParcelas
             FROM Dados.PropostaAutomovel PA
             INNER JOIN Dados.Veiculo V 
             ON V.ID = PA.IDVeiculo
             AND V.Codigo <> 0
             WHERE PA.IDProposta = PRP.ID
             ) PA
OUTER APPLY (SELECT TOP 1 DataEfetivacao [DataEmissao], DataArquivo [DataEmissaoArquivo]
                FROM Dados.Pagamento PGTO
                WHERE PGTO.IDProposta = PRP.ID
                AND RIGHT(PGTO.TipoDado, 8) = 'TIPO - 2'
                AND IDMotivo = 1 
                AND NumeroParcela = 1
                AND IDSituacaoProposta IN (1,21, 22)
                ORDER BY DataArquivo ASC 

             ) PGTOA              
OUTER APPLY (SELECT DATEADD(DD, DiaVencimento - 1, DATEADD(MM, PGTO.NumeroParcela - 1, Cast((Cast(DATEPART(YYYY, PGTOA.[DataEmissao]) AS VARCHAR(4)) + '-' + Cast(DATEPART(MM, PGTOA.[DataEmissao]) AS VARCHAR(2)) + '-' + '01') AS DATE)))  [DataVencimentoParcela], PGTO.IDMotivo, PGTO.IDSituacaoProposta, PGTO.IDMotivoSituacao, PGTO.Valor, PGTO.NumeroParcela, PGTO.DataEfetivacao, PGTO.DataArquivo 
             FROM Dados.Pagamento PGTO
             WHERE PGTO.IDProposta = PRP.ID
             AND RIGHT(PGTO.TipoDado, 8) = 'TIPO - 8'
             AND PGTO.IDMotivo = 66 /*Filtra para obter apenas demais parcelas*/
             ) PGTO     