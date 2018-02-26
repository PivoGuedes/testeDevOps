CREATE VIEW Marketing.EndossosAuto
AS
SELECT 
        CNT.ID [IDContrato], CNT.NumeroContrato, PRP.ID [IDProposta], PRP.NumeroProposta, --SE.Descricao [SituacaoEndosso],
        PRP.DataProposta, PGTO.DataEfetivacao [DataEmissao], PC.Nome [NomeCliente], pc.CPFCNPJ [CPFCNPJ], PGTO.DataInicioVigencia, PGTO.DataFimVigencia,
        PGTO.Valor, PGTO.ValorIOF,  PGTO.[CodigoMotivo], PGTO.[NomeMotivo], --PGTO.DataArquivo, PGTO.Arquivo,  
        PGTO.[CodigoMotivo1], PGTO.[NomeMotivo1], PGTO.SituacaoProposta,
        PSIG.CodigoProduto, PSIG.Descricao [Produto]--, PGTO.IDSituacaoProposta
FROM  Dados.Proposta PRP
      CROSS APPLY (SELECT TOP 100 PERCENT 
                         PGTO.[IDProposta], PGTO.Valor, PGTO.ValorIOF, PGTO.DataEfetivacao DataEfetivacao
                       , PGTO.DataInicioVigencia, PGTO.DataFimVigencia, TM.Codigo [CodigoMotivo], TM.Nome [NomeMotivo], PGTO1.[CodigoMotivo1], PGTO1.[NomeMotivo1]
                       , SP.Sigla [SituacaoProposta]--, PGTO1.IDSituacaoProposta
                   FROM       Dados.Pagamento PGTO 
                    LEFT JOIN Dados.TipoMotivo TM
                    ON TM.ID = PGTO.IDMotivo
                    OUTER APPLY (SELECT TOP 1 PGTO1.*, TM1.Codigo [CodigoMotivo1], TM1.Nome [NomeMotivo1]
                                 FROM Dados.Pagamento PGTO1
                                 LEFT JOIN Dados.TipoMotivo TM1
                                    ON PGTO1.IDMotivo = TM1.ID

                                 WHERE PGTO1.IDProposta = PGTO.IDProposta 
                                   AND PGTO1.DataArquivo >= PGTO.DataArquivo
                                   AND PGTO1.ID <> PGTO.ID 
                                    AND PGTO1.IDMotivo <> 66
                                 ORDER BY PGTO1.[IDProposta] ASC, PGTO1.[DataArquivo] ASC, PGTO1.[ID] DESC) PGTO1 
                     LEFT JOIN Dados.SituacaoProposta SP
                     ON SP.ID = COALESCE(PGTO1.IDSituacaoProposta, PGTO.IDSituacaoProposta) 
                   WHERE PGTO.IDProposta = PRP.ID 
                     AND PGTO.IDSituacaoProposta in (2) 
                        
                      /*ENDOSSO*/
                   ORDER BY PGTO.[IDProposta] ASC, PGTO.[DataArquivo] ASC, PGTO.[ID] ASC) PGTO  /*BUSCA A EMISSÃO ORIGINAL*/
      INNER JOIN Dados.ProdutoSIGPF PSIG
      ON PRP.IDProdutoSIGPF = PSIG.ID

      LEFT JOIN Dados.Contrato CNT
      ON CNT.ID = PRP.IDContrato
      
      LEFT JOIN Dados.PropostaCliente PC
      ON PC.IDProposta = PRP.ID
                 
WHERE    PSIG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')
--AND PRP.ID IN (7838667, 8409261, 7665099)


--SELECT * FROM Marketing.EndossosAuto