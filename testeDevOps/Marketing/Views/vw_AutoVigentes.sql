
                
/*
	Autor: Egler Vieira
	Data Criação: 24/05/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.vw_AutoVigentes
	Descrição: Procedimento que realiza a recuperação das apólices de auto VIGENTES.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW Marketing.vw_AutoVigentes
AS
SELECT 
        AV.NumeroContrato [NumeroApolice], COALESCE(PA.NumeroApoliceAnterior, CNTA.NumeroApoliceAnterior) NumeroApoliceAnterior, PA.QuantidadeParcelas, AV.NumeroProposta, 
        AV.TipoPessoa, AV.CPFCNPJ, AV.NomeCliente, AV.DataNascimento, AV.Sexo, AV.EstadoCivil, 
        AV.DDDComercial, AV.TelefoneComercial, AV.DDDResidencial, AV.TelefoneResidencial,
        AV.DDDFax, AV.TelefoneFax, AV.Email, AV.Profissao,
        AV.DataProposta, AV.[DataEmissao], AV.[AgenciaVenda], AV.FormaPagamento,
        AV.DataInicioVigencia, AV.DataFimVigencia, AV.Valor, AV.ValorIOF, AV.CodigoProduto, AV.[Produto],
        AV.CodigoComercializado, AV.[ProdutoComercializado],
        CB.ID [CodigoClasseBonus], CB.Descricao [ClasseBonus], CF.Descricao [ClasseFranquia], TS.Descricao [TipoSeguro],
        V.Nome [Veiculo], PA.Placa, PA.Chassis, /*PA.AnoFabricacao,*/ PA.AnoModelo, 
        PA.Capacidade, PA.Combustivel, PA.CodigoSeguradora, Cast(CASE DATEPART(dw, GETDATE()) 
                     WHEN 1 THEN DATEADD(DD,-3,GETDATE())
                     WHEN 2 THEN DATEADD(DD,-3,GETDATE())
                     WHEN 7 THEN DATEADD(DD,-2,GETDATE())
                     ELSE DATEADD(DD,-1,GETDATE())
                                                            END as Date)[DataReferencia]      
FROM Dados.fn_RecuperaApolicesVigentes_AUTO (
            Cast(CASE DATEPART(dw, GETDATE()) 
                     WHEN 1 THEN DATEADD(DD,-3,GETDATE())
                     WHEN 2 THEN DATEADD(DD,-3,GETDATE())
                     WHEN 7 THEN DATEADD(DD,-2,GETDATE())
                     ELSE DATEADD(DD,-1,GETDATE())
             END as Date)
) AV
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = AV.IDContrato
OUTER APPLY (SELECT NumeroContrato [NumeroApoliceAnterior]
             FROM Dados.Contrato CNTA
             WHERE CNTA.ID = CNT.IDContratoAnterior) CNTA
OUTER APPLY (SELECT TOP 1 * 
             FROM Dados.PropostaAutomovel PA
             WHERE PA.IDProposta = AV.IDProposta
             ORDER BY PA.IDProposta ASC, PA.DataArquivo ASC) PA
LEFT JOIN Dados.Veiculo V
ON PA.IDVeiculo = V.ID
LEFT JOIN Dados.ClasseBonus CB
ON PA.IDClasseBonus = CB.ID 
LEFT JOIN Dados.ClasseFranquia CF
ON PA.IDClasseFranquia = CF.ID
LEFT JOIN Dados.TipoSeguro TS
ON PA.IDTipoSeguro = TS.ID
--ORDER BY AV.[DataEmissao] DESC 



