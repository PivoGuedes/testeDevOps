
                
/*
	Autor: Egler Vieira
	Data Criação: 03/06/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaApolicesCanceladas_AUTO
	Descrição: Procedimento que realiza a recuperação das apólices de auto CANCELADAS.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Marketing.fn_RecuperaApolicesCanceladas_AUTO (@DataInicio AS DATE, @DataFim AS DATE)
RETURNS TABLE
AS
RETURN
SELECT 
        AV.NumeroContrato [NumeroApolice], PA.NumeroApoliceAnterior, PA.QuantidadeParcelas, AV.NumeroProposta, 
        AV.TipoPessoa, AV.CPFCNPJ, AV.NomeCliente, AV.DataNascimento, AV.Sexo, AV.EstadoCivil, 
        AV.DDDComercial, AV.TelefoneComercial, AV.DDDResidencial, AV.TelefoneResidencial,
        AV.DDDFax, AV.TelefoneFax, AV.Email, AV.Profissao, AV.SituacaoProposta, AV.[Motivo], AV.[MotivoSituacao],
        AV.DataProposta, AV.[DataCancelamento], AV.[AgenciaVenda], AV.FormaPagamento,
        AV.DataInicioVigencia, AV.DataFimVigencia, AV.Valor, AV.ValorIOF, AV.CodigoProduto, AV.[Produto],
        AV.CodigoComercializado, AV.[ProdutoComercializado],
        CB.ID [CodigoClasseBonus], CB.Descricao [ClasseBonus], CF.Descricao [ClasseFranquia], TS.Descricao [TipoSeguro],
        V.Nome [Veiculo], PA.Placa, PA.Chassis, /*PA.AnoFabricacao,*/ PA.AnoModelo, 
        PA.Capacidade, PA.Combustivel, PA.CodigoSeguradora
    
FROM Dados.fn_RecuperaApolicesCanceladas_AUTO (@DataInicio, @DataFim) AV
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = AV.IDContrato
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