
                
/*
	Autor: Egler Vieira
	Data Criação: 30/10/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.vw_Emissoes_OUTROS
	Descrição: Procedimento que realiza a recuperação emissões exeto auto.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW [Marketing].[vw_Emissoes_OUTROS]
AS		
SELECT   AV.IDProposta,
        AV.NumeroContrato [NumeroApolice], 
		--COALESCE(PA.NumeroApoliceAnterior, CNTA.NumeroApoliceAnterior) NumeroApoliceAnterior, 
		--PA.QuantidadeParcelas, 
		AV.NumeroProposta, 
        AV.TipoPessoa, 
		AV.CPFCNPJ, 
		AV.NomeCliente, 
		AV.DataNascimento, 
		AV.Sexo, 
		AV.EstadoCivil, 
        AV.DDDComercial, 
		AV.TelefoneComercial, 
		AV.DDDResidencial, 
		AV.TelefoneResidencial,
        AV.DDDFax, 
		AV.TelefoneFax, 
		AV.Email, 
		AV.Profissao,
        AV.DataProposta, 
		AV.[DataEmissao], 
		AV.[AgenciaVenda], 
		AV.FormaPagamento,
        AV.DataInicioVigencia, 
		AV.DataFimVigencia, 
		AV.Valor, 
		AV.ValorIOF, 
		AV.CodigoProduto, 
		AV.[Produto],
        AV.CodigoComercializado, 
		AV.[ProdutoComercializado]
        --CB.ID [CodigoClasseBonus], 
		--CB.Descricao [ClasseBonus], 
		--CF.Descricao [ClasseFranquia], 
		--TS.Descricao [TipoSeguro],
        --V.Nome [Veiculo], 
		--PA.Placa, 
		--PA.Chassis, 
		/*PA.AnoFabricacao,*/ 
		--PA.AnoModelo, 
        --PA.Capacidade, 
		--PA.Combustivel, 
		--PA.CodigoSeguradora, 
		--SP.*      
FROM Dados.vw_Emissoes_OUTROS AV
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = AV.IDContrato
OUTER APPLY (SELECT NumeroContrato [NumeroApoliceAnterior]
             FROM Dados.Contrato CNTA
             WHERE CNTA.ID = CNT.IDContratoAnterior) CNTA
/*OUTER APPLY      
      (
        SELECT TOP 1 PGTO1.DataArquivo [DataSituacao]
                   , SP.Sigla [SituacaoSIGLA] , SP.Descricao [Situacao]
                   , TM.Codigo [CodigoMotivo], TM.Nome [Motivo]
        FROM Dados.PagamentoEmissao PGTO1 
        INNER JOIN Dados.SituacaoProposta SP
        ON SP.ID = PGTO1.IDSituacaoProposta
        LEFT JOIN Dados.TipoMotivo TM
        ON TM.ID = PGTO1.IDMotivo
        WHERE PGTO1.IDProposta = AV.IDProposta 
          --AND (SP.Sigla IN ('CAN', 'REJ') OR TM.Codigo = '242')
        ORDER BY PGTO1.DataArquivo  DESC
          
       )  SP                
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
ON PA.IDTipoSeguro = TS.ID*/
