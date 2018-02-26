
CREATE  VIEW Dados.vw_RegistroSinistro
AS

SELECT * FROM  dbo.HML_vw_RegistroSinistro

/*
SELECT 
	CT.CPF
	, CT.NomeCliente NC
	, S.NumeroSinistro
	, S.DataAviso
	, S.DataSinistro
	, s.NumeroProtocolo
	, CNT.NumeroContrato
	, CT.NumeroCertificado
	, s.NumeroContratoResidencial
	, PRP.DataInicioVigencia
	, PRP.DataFimVigencia
    , PRD.CodigoComercializado
	, PRD.Descricao
	, C.Codigo [CodigoCobertura]
	, C.Nome [Cobertura]
    , SH.[ValorOperacao]
	, SH.DataMovimentoContabil
	, ISNULL(sh.NomeBeneficiario, S.NomeBeneficiario) NomeBeneficiario
	, SO.Descricao Operacao
	, SC.Descricao [Causa]
	, SS.Descricao [Situacao]
	, En.Bairro
	, En.Endereco
	, En.Cidade
	, En.UF
	, En.CEP

FROM Dados.Contrato CNT
CROSS APPLY (SELECT TOP 1 CPFCNPJ, CC.NomeCliente FROM Dados.ContratoCliente CC WHERE CC.IDContrato = CNT.ID ORDER BY CPFCNPJ DESC) CC
INNER JOIN Dados.Sinistro S
ON CNT.ID = S.IDContrato
INNER JOIN Dados.Certificado CT
ON CT.ID = S.IDCertificado
INNER JOIN DADOS.Proposta PRP
ON PRP.ID = CT.IDProposta
INNER JOIN Dados.Produto PRD
ON PRD.ID = PRP.IDProduto
LEFT JOIN Dados.SinistroHistorico SH
ON SH.IDSinistro = S.ID
LEFT JOIN Dados.SinistroOperacao SO
ON SO.ID = SH.IDSinistroOperacao
LEFT JOIN Dados.SinistroCausa SC
ON SC.ID = S.IDSinistroCausa
LEFT JOIN Dados.SituacaoSinistro SS
ON SS.ID = SH.IDSituacaoSinistro
LEFT JOIN Dados.Cobertura c
ON C.ID = SH.IDCobertura
OUTER APPLY (SELECT TOP 1 * FROM Dados.PropostaEndereco AS PE WHERE LastValue=1 AND PE.IDProposta=PRP.ID) AS En
WHERE PRD.CodigoComercializado in ( '7704',
                                     '7705',
                                     '7707',
                                     '7709',
                                     '7711',
                                     '7712',
                                     '7713',
                                     '7716'
                                   )
*/