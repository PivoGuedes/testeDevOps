
                
/*
	Autor: Egler Vieira
	Data Criação: 10/07/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_VidaVigentes
	Descrição: Procedimento que realiza a recuperação dos VIGENTES de vida.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 

CREATE FUNCTION [Marketing].[fn_VidaVigentes] (@DataApuracao as date)
RETURNS TABLE
AS
RETURN/*
SELECT DISTINCT 
      CNT.NumeroContrato, CNT.NumeroBilhete, CH.CodigoSubEstipulante, C.ID [IDCertificado], PRP.ID [IDProposta], C.NumeroCertificado
    , COALESCE(C.CPF, PC.CPFCNPJ, CC.CPFCNPJ) [CPF]
	  , COALESCE(C.DataNascimento, PC.DataNascimento) DataNascimento	  
	  , COALESCE(C.NomeCliente, CASE WHEN PC.Nome <> 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' THEN  PC.Nome ELSE CC.NomeCliente END) NomeCliente
	  
	    , PRP.RendaFamiliar, PRP.RendaIndividual, SX.Descricao [Sexo], EC.Descricao [EstadoCivil]
      , C.NumeroSICOB, PP.Codigo [CodigoPeriodicidadePagamento], PP.Descricao [PeriodicidadePagamento]
      /*, CH.CodigoSubEstipulante, CH.NumeroProposta [NumeroPropostaInterna]*/, CH.DataInicioVigencia, CH.DataFimVigencia, CH.DataCancelamento
      , CH.QuantidadeParcelas, /*CH.ValorPremioTotal, CH.ValorPremioLiquido,*/ COALESCE(CH.ValorPremioTotal, CH.ValorPremioLiquido, PRP.Valor) [ValorPremioTotal] , PRP.DataProposta [DataPropostaVenda]
      , SP.Descricao [SituacaoProposta], CH.DataArquivo [DataSituacao]

       , PAS.CodigoComercializado   
       , PRD.Descricao
       
       --, CCH.[Cobertura]
       --, CCH.ImportanciaSegurada
       
       , PC.DDDComercial
       , PC.TelefoneComercial
       
       , PC.DDDFax
       , PC.TelefoneFax
       , PC.DDDResidencial
       , PC.TelefoneResidencial
       , PC.Email       
FROM Dados.Certificado C 
INNER JOIN Dados.Proposta PRP
ON PRP.NumeroProposta = C.NumeroCertificado
INNER JOIN Dados.ProdutoSIGPF PRDS
ON PRDS.ID = PRP.IDProdutoSIGPF
LEFT JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.ID
LEFT JOIN Dados.Sexo SX
ON SX.ID = PC.IDSexo
LEFT JOIN Dados.EstadoCivil EC
ON EC.ID = PC.IDEstadoCivil
OUTER APPLY (
             SELECT TOP 1 *
             FROM Dados.CertificadoHistorico CH 
             WHERE CH.IDCertificado = C.ID 
             ORDER BY CH.[IDCertificado] ASC,
	                    CH.[NumeroProposta] ASC,
	                    CH.[DataArquivo] DESC
            ) CH         
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = C.IDContrato
LEFT JOIN Dados.ContratoCliente CC
ON CC.IDContrato = C.IDContrato
LEFT JOIN Dados.PeriodoPagamento PP
ON CH.IDPeriodoPagamento = PP.ID
LEFT JOIN Dados.SituacaoProposta SP
ON PRP.IDSituacaoProposta = SP.ID
LEFT JOIN Dados.ProdutoComercializado_ApoliceSubgrupo PAS
ON PAS.NumeroContrato = CNT.NumeroContrato
AND PAS.CodigoSubGrupo = CH.CodigoSubEstipulante
AND 
    (
     ISNULL(PP.Codigo,-1) IN (ISNULL(PAS.Periodicidade1,-1), ISNULL(PAS.Periodicicade2,-1), ISNULL(PAS.Periodicicade3,-1))
    OR
     1 = (CASE WHEN PAS.Periodicidade1 IS NULL THEN 1 ELSE 0 END)
    )
LEFT JOIN Dados.Produto PRD
ON PRD.CodigoComercializado = PAS.CodigoComercializado
WHERE PRDS.CodigoProduto in ('07','09','11','13','16','46','48','93')
AND  CH.DataFimVigencia > @Data
*/

SELECT DISTINCT 
      CNT.NumeroContrato, C.ID [IDCertificado], PRP.ID [IDProposta], C.NumeroCertificado
      , COALESCE(C.CPF, PC.CPFCNPJ/*, CC.CPFCNPJ*/) [CPF]
	  , COALESCE(C.DataNascimento, PC.DataNascimento) DataNascimento	  
	  , CASE WHEN C.NomeCliente = 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' OR C.NomeCliente IS NULL THEN
							PC.Nome 	                                  
		  ELSE C.NomeCliente END NomeCliente
	  
	, PRP.RendaFamiliar, PRP.RendaIndividual, S.[Descricao] Sexo, EC.Descricao [EstadoCivil]
	, PP.Codigo [CodigoPeriodicidadePagamento], PP.Descricao [PeriodicidadePagamento]
	, CH.CodigoSubEstipulante, /*CH.NumeroProposta [NumeroPropostaInterna],*/ CH.DataInicioVigencia, CH.DataFimVigencia, CH.DataCancelamento
	, CH.QuantidadeParcelas, /*CH.ValorPremioTotal, CH.ValorPremioLiquido,*/ COALESCE(CH.ValorPremioTotal, CH.ValorPremioLiquido, PRP.Valor) [ValorPremioTotal] , PRP.DataProposta [DataPropostaVenda]
	, SP.Descricao [SituacaoProposta], CH.DataArquivo [DataSituacao]
 
   --, PAS.CodigoComercializado   
   --, PRD.Descricao
   
   , PC.DDDComercial
   , PC.TelefoneComercial
   
   , PC.DDDFax
   , PC.TelefoneFax
   , PC.DDDResidencial
   , PC.TelefoneResidencial
   , PC.Email 
   , PE.Endereco      
   , PE.Bairro
   , PE.Cidade
   , PE.UF
   , PE.CEP
   , PRDS.CodigoProduto
   , PRDS.Descricao
FROM Dados.Certificado C 
INNER JOIN Dados.Contrato CNT
ON CNT.ID = C.IDContrato
CROSS APPLY (
		     /*SELECT MIN(CH.DataInicioVigencia) DataInicioVigencia, MAX(CH.DataFimVigencia) DataFimVigencia, MAX(CH.DataCancelamento) DataCancelamento, MAX(QuantidadeParcelas) QuantidadeParcelas
             FROM
             (*/
             SELECT TOP 1 *
             FROM Dados.CertificadoHistorico CH 
             WHERE CH.IDCertificado = C.ID 
             ORDER BY CH.[IDCertificado] ASC,
	                    CH.[DataArquivo] DESC,
						--[DataInicioVigencia] ASC,
						[DataFimVigencia] DESC
						--[NumeroProposta] DESC	                    
            ) CH 
LEFT JOIN Dados.Proposta PRP
ON PRP.ID = C.IDProposta
OUTER APPLY (SELECT TOP 1
                     PE.Endereco      
				   , PE.Bairro
				   , PE.Cidade
				   , PE.UF
				   , PE.CEP
			 FROM Dados.PropostaEndereco PE
			 WHERE PE.IDProposta = PRP.ID
			 ORDER BY PE.[IDProposta] ASC,
					  PE.[IDTipoEndereco] ASC,
					  PE.[DataArquivo] DESC
             ) PE
LEFT JOIN Dados.ProdutoSIGPF PRDS
ON PRDS.ID = PRP.IDProdutoSIGPF
LEFT JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.ID
LEFT JOIN Dados.EstadoCivil EC
ON EC.ID = PC.IDEstadoCivil
LEFT JOIN Dados.Sexo S
ON S.ID = PC.IDSexo
LEFT JOIN Dados.ContratoCliente CC
ON CC.IDContrato = C.IDContrato
LEFT JOIN Dados.PeriodoPagamento PP
ON CH.IDPeriodoPagamento = PP.ID
LEFT JOIN Dados.SituacaoProposta SP
ON PRP.IDSituacaoProposta = SP.ID/*
LEFT JOIN Dados.ProdutoComercializado_ApoliceSubgrupo PAS
ON PAS.NumeroContrato = CNT.NumeroContrato
AND PAS.CodigoSubGrupo = CH.CodigoSubEstipulante
AND 
    (
     ISNULL(PP.Codigo,-1) IN (ISNULL(PAS.Periodicidade1,-1), ISNULL(PAS.Periodicicade2,-1), ISNULL(PAS.Periodicicade3,-1))
    OR
     1 = (CASE WHEN PAS.Periodicidade1 IS NULL THEN 1 ELSE 0 END)
    )
LEFT JOIN Dados.Produto PRD
ON PRD.CodigoComercializado = PAS.CodigoComercializado*/
WHERE /*PRDS.CodigoProduto in ('07','09','11','13','16','46','48','93')
AND*/  (CH.DataFimVigencia >= @DataApuracao /* OR CH.DataFimVigencia IS NULL*/) AND (CH.DataCancelamento <= @DataApuracao OR CH.DataCancelamento IS NULL )
    --AND CNT.NumeroContrato IN ('109300000559','93010000890')

    AND NOT EXISTS (
                    SELECT * 
                    FROM Dados.Pagamento PGTO 
                    LEFT JOIN Dados.SituacaoProposta SP
                    ON SP.ID = PGTO.IDSituacaoProposta
                    LEFT JOIN Dados.TipoMotivo TM
                    ON TM.ID = PGTO.IDMotivo
                    WHERE PGTO.IDProposta = PRP.ID
                      AND (SP.Sigla IN ('CAN', 'REJ') OR TM.Codigo = '242')
                      AND PGTO.DataArquivo <= @DataApuracao                      
                   )  
--AND NumeroCertificado IN ( '010084770009757', '010084770009730', '010084770009749')                   
--AND PRP.NumeroProposta = '010702770001098'
--AND CNT.NumeroContrato = '109300000559'
--ORDER BY C.NumeroCertificado    



