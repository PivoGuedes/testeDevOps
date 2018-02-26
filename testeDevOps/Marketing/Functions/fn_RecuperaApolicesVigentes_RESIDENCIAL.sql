
                
/*
	RESIDENCIALr: Egler Vieira
	Data Criação: 29/05/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaApolicesVigentes_RESIDENCIAL
	Descrição: Procedimento que realiza a recuperação das apólices de RESIDENCIAL VIGENTES.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Marketing.fn_RecuperaApolicesVigentes_RESIDENCIAL (@DataApuracao AS DATE)
RETURNS TABLE
AS
RETURN
SELECT 
        AV.NumeroContrato [NumeroApolice], PR.NumeroApoliceAnterior, PR.QuantidadeParcelas, AV.NumeroProposta, 
        AV.TipoPessoa, AV.CPFCNPJ, AV.NomeCliente, AV.DataNascimento, AV.Sexo, AV.RendaIndividual, AV.RendaFamiliar,
        AV.EstadoCivil, AV.DDDComercial, AV.TelefoneComercial, AV.DDDResidencial, AV.TelefoneResidencial,
        AV.DDDFax, AV.TelefoneFax, AV.Email, AV.Profissao,
        AV.DataProposta, AV.[DataEmissao], AV.[AgenciaVenda], AV.FormaPagamento,
        AV.DataInicioVigencia, AV.DataFimVigencia, AV.Valor, AV.ValorIOF, AV.CodigoProduto, AV.[Produto],
        AV.CodigoComercializado, AV.[ProdutoComercializado],
        TM.ID [CodigoTipoMoradia], TM.Descricao [TipoMoradia], TU.ID [CodigoTipoOcupacao], TU.Descricao [TipoOcupacao],
        TS.Descricao [TipoSeguro], PR.ValorPremioTotal, PR.ValorPremioLiquido, PR.ValorPrimeiraParcela, PR.ValorDemaisParcelas,
        PR.DescontoFidelidade, PR.DescontoAgrupCobertura, PR.DescontoExperiencia, PR.DescontoFuncionarioPublico, 
        PR.ValorAdicionalFracionamento, Cast(PR.ValorCustoApolice as decimal(19,2)) ValorCustoApolice,--, PR.CodigoSeguradora
        PC.ValorImportanciaSegurada, PR.IndicadorRenovacaoAutomatica    
FROM Dados.fn_RecuperaApolicesVigentes_RESIDENCIAL (@DataApuracao) AV
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = AV.IDContrato
OUTER APPLY (SELECT TOP 1 * 
             FROM Dados.PropostaResidencial PR
             WHERE PR.IDProposta = AV.IDProposta
             ORDER BY PR.IDProposta ASC, PR.DataArquivo DESC) PR
LEFT JOIN Dados.TipoOcupacao TU
ON PR.IDTipoOcupacao = TU.ID
LEFT JOIN Dados.TipoMoradia TM
ON PR.IDTipoMoradia = TM.ID 
LEFT JOIN Dados.TipoSeguro TS
ON PR.IDTipoSeguro = TS.ID
LEFT JOIN Dados.PropostaCobertura PC
ON PC.IDProposta = AV.IDProposta
and PC.IDTipoCobertura = 1
