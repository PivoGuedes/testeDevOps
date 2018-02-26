




                
/*
	Autor: Gustavo Moreira
	Data Criação: 23/07/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.vw_AutoVigentes_UltimaEmissao
	Descrição: Procedimento que realiza a recuperação das apólices de auto VIGENTES
	com base na data da última emissão de AUTO.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW [Marketing].[vw_AutoVigentes_UltimaEmissao]
as

  

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
        PA.Capacidade, PA.Combustivel, PA.CodigoSeguradora
        
FROM Dados.fn_RecuperaApolicesVigentes_AUTO_UltimaEmissao () AV

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







