
CREATE FUNCTION [Mailing].[fn_RecuperaClienteExclusivoProdutos] (@CPF VARCHAR(20))
RETURNS @Produtos TABLE
    (
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	[NumeroContrato] [varchar](20) NULL,
	[Veiculo] [varchar](100) NULL,
	--[CodigoComercializado] [varchar](5) NULL,
	[Produto] [varchar](100) NULL
   ) 
WITH EXECUTE AS 'usrDWLinked'
AS
BEGIN 
    INSERT INTO @Produtos (	[DataInicioVigencia], [DataFimVigencia], [NumeroContrato], [Veiculo], [Produto])
	
	--DECLARE @CPF VARCHAR(20) = '000.388.131-81'
	--SELECT DataInicioVigencia,
	--       DataFimVigencia,
	--	    COALESCE(C.NumeroCertificado, PPC.NumeroCertificado, CNT.NumeroBilhete, CASE WHEN A.Produto = 'Vida' THEN CNT.Proposta ELSE CNT.NumeroContrato END) NumeroContrato,
	--FROM
	--(
	SELECT *
	FROM
	(
	SELECT COALESCE(PRP.DataInicioVigencia, C.DataInicioVigencia, CNT.DataInicioVigencia) DataInicioVigencia,
		   COALESCE(PRP.DataFimVigencia, C.DataFimVigencia, CNT.DataFimVigencia) DataFimVigencia,
		   COALESCE(C.NumeroCertificado, PPC.NumeroCertificado, CNT.NumeroBilhete, CNT.NumeroContrato, PRP.NumeroProposta) NumeroContrato,
		   V.Veiculo, 		   
		   --REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS') [Produto]--, PRD.CodigoComercializado
		   CASE R.ID WHEN    1 THEN  'Auto'
					WHEN	 2 THEN	 'Consórcio'
					WHEN	 4 THEN	 'Financeiro'
					WHEN	 5 THEN	 'Riscos especiais'
					WHEN	 6 THEN	 'Vida'
					WHEN	 7 THEN	 'Previdência'
					WHEN	 8 THEN	 'Capitalização'
					WHEN	20 THEN	 'Outros'
					WHEN	22 THEN	 'Residencial'
					WHEN	61 THEN	 'Saúde'
					ELSE
					    CASE WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%PREV%'   THEN 'Previdência'
						    WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%PGBL%'   THEN 'Previdência'
							WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%VGBL%'   THEN 'Previdência'
						    WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%CAPI%'   THEN 'Capitalização'
							WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%CONSOR%' THEN 'Consórcio'
							WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%RESID%'  THEN 'Residencial'
                            WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE 'RD - BILHETES'  THEN 'Residencial'
							WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%AUTO%'   THEN 'Auto'
							WHEN REPLACE(REPLACE(ISNULL(PG.Descricao,'%SUBSTITUIR%'), 'NÃO IDENTIFICADO', 'OUTROS'), '%SUBSTITUIR%', 'OUTROS')  LIKE '%VIDA%'   THEN 'Vida' 
						ELSE 
						    CASE WHEN PRD.Descricao   LIKE '%PREV%'   THEN 'Previdência' 
							    WHEN PRD.Descricao   LIKE '%PVBL%'   THEN 'Previdência' 
								WHEN PRD.Descricao   LIKE '%VGBL%'   THEN 'Previdência'
								WHEN PRD.Descricao   LIKE '%CAPI%'   THEN 'Capitalização'
								WHEN PRD.Descricao   LIKE '%CONSOR%' THEN 'Consórcio'
								WHEN PRD.Descricao   LIKE '%RESID%'  THEN 'Residencial'
								WHEN PRD.Descricao   LIKE '%AUTO%'   THEN 'Auto'
								WHEN PRD.Descricao   LIKE '%VIDA%'   THEN 'Vida' 
						ELSE
							CASE WHEN CNT.IDRamo IN (22,23,27,29,65) THEN 'Vida'
							     WHEN CNT.IDRamo IN (21) THEN 'Financeiro'
							ELSE
						        COALESCE(R.Nome, PG.Descricao, PRD.Descricao)
							END
						END
					END
			 END Produto
	FROM Dados.Proposta PRP
	INNER JOIN Dados.PropostaCliente PC
	ON PC.IDProposta = PRP.ID
	LEFT JOIN Dados.Certificado C
	ON C.IDProposta = PRP.ID
	LEFT JOIN Dados.Contrato CNT
	ON CNT.ID = PRP.IDContrato
	LEFT JOIN Dados.Produto PRD
	ON PRD.ID = PRP.IDProduto
	LEFT JOIN Dados.ProdutoSIGPF PG
	ON PG.ID = COALESCE(CASE WHEN PRP.IDProdutoSIGPF <= 0 THEN NULL ELSE PRP.IDProdutoSIGPF END, CASE WHEN PRD.IDProdutoSIGPF <= 0 THEN NULL ELSE PRD.IDProdutoSIGPF END)
	OUTER APPLY (SELECT * FROM Dados.fn_RecuperaRamoPAR_Mestre(PRD.IDRamoPAR)) R
	OUTER APPLY (
				 SELECT TOP 1 NumeroCertificado 
				 FROM Dados.PropostaPrevidenciaCertificado PPC
				 WHERE PPC.IDProposta = PRP.ID
				) PPC
	OUTER APPLY (
				 SELECT TOP 1 V.Nome [Veiculo]
				 FROM Dados.PropostaAutomovel PA
				 INNER JOIN Dados.Veiculo V
				 ON V.ID = PA.IDVeiculo
				 WHERE PA.IDProposta = PRP.ID
				 ORDER BY [IDProposta] ASC,
						  [DataArquivo] DESC
				) V
	WHERE PC.CPFCNPJ = @CPF
	AND PRP.IDPropostaM IS NULL
	AND EXISTS (SELECT * FROM Dados.Funcionario F
	            WHERE F.CPF = @CPF)
	AND COALESCE(PRP.DataInicioVigencia, C.DataInicioVigencia, CNT.DataInicioVigencia)  is not null
	) D
	WHERE D.Produto IN ('Auto', 'Vida', 'Residencial', 'Consórcio', 'Previdência') 
	RETURN
END
