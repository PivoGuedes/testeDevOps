

/*
	Autor: Egler Vieira
	Data Criação: 18/06/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.vw_Emissoes_AUTO
	Descrição: Procedimento que realiza a recuperação das emissões (iniciais) de apólices de auto .
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW Dados.vw_Emissoes_AUTO
AS
SELECT TOP 100 PERCENT
        CNT.ID [IDContrato], CNT.NumeroContrato, PRP.ID [IDProposta], PRP.NumeroProposta, --SE.Descricao [SituacaoEndosso],
        PC.CPFCNPJ, PC.Nome [NomeCliente], S.Descricao [Sexo], PC.TipoPessoa, EC.Descricao [EstadoCivil], 
        PC.DDDComercial, PC.TelefoneComercial, PC.DDDResidencial, PC.TelefoneResidencial,
        PC.DDDFax, PC.TelefoneFax, PC.Email, PC.Profissao, PC.DataNascimento, 
        U.Codigo [AgenciaVenda], FP.Descricao [FormaPagamento],
        PRP.DataProposta, PGTO.DataEfetivacao [DataEmissao],
        COALESCE(PRP.DataInicioVigencia, PGTO.DataInicioVigencia) DataInicioVigencia, COALESCE(PRP.DataFimVigencia, PGTO.DataFimVigencia) DataFimVigencia,
        PGTO.Valor, PGTO.ValorIOF, --PGTO.DataArquivo, PGTO.Arquivo,  
        PSIG.CodigoProduto, PSIG.Descricao [Produto], [IDProdutoComercializado], PRD.CodigoComercializado, PRD.Descricao [ProdutoComercializado]
FROM  Dados.Proposta PRP
      INNER JOIN Dados.ProdutoSIGPF PSIG
      ON PRP.IDProdutoSIGPF = PSIG.ID
      OUTER APPLY (SELECT TOP 1 PGTO.[IDProposta], PGTO.Valor, PGTO.ValorIOF, PGTO.DataEfetivacao, DataInicioVigencia, DataFimVigencia
                   FROM Dados.PagamentoEmissao PGTO 
                   WHERE PGTO.IDProposta = PRP.ID 
                     AND PGTO.IDSituacaoProposta in (1, 2, 21, 22)  /*EMT, END, ENV e MAN*/
                   ORDER BY 	[IDProposta] ASC, [DataArquivo] ASC, [ID] ASC) PGTO  /*BUSCA A EMISSÃO ORIGINAL*/
      LEFT JOIN Dados.PropostaCliente PC
      ON PC.IDProposta = PRP.ID
      LEFT JOIN Dados.EstadoCivil EC
      ON EC.ID = PC.IDEstadoCivil
      LEFT JOIN Dados.Sexo S
      ON S.ID = PC.IDSexo
      OUTER APPLY (SELECT TOP 1 *
                   FROM Dados.MeioPagamento MP
                   WHERE MP.IDProposta = PRP.ID
                   ORDER BY IDProposta ASC,
                            DataArquivo ASC) MP
      LEFT JOIN Dados.FormaPagamento FP
      ON FP.ID = MP.IDFormaPagamento                            
      LEFT JOIN Dados.Unidade U
      ON U.ID = PRP.IDAgenciaVenda
      LEFT JOIN Dados.Contrato CNT
      ON CNT.ID = PRP.IDContrato
      OUTER APPLY (SELECT TOP 1 IDTipoEndosso, IDSituacaoEndosso, IDProduto [IDProdutoComercializado] 
                   FROM Dados.Endosso EN
                   WHERE EN.IDContrato = CNT.ID
                   ORDER BY    IDContrato ASC, DataArquivo ASC) EN    /*Último Endosso*/
      LEFT JOIN Dados.TipoEndosso TE
      ON EN.IDTipoEndosso = TE.ID
      LEFT JOIN Dados.Produto PRD
      ON PRD.ID = EN.[IDProdutoComercializado]
     /* LEFT JOIN Dados.SituacaoEndosso SE
      ON SE.ID = EN.IDSituacaoEndosso */                  
WHERE   /*PGTO.IDSituacaoProposta = 1
    AND*/ PSIG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')
    --AND PRP.DataFimVigencia >= @DataApuracao--'2014-03-12'      
    --AND ISNULL(EN.IDTipoEndosso, 255) NOT IN (2,5) /*QUE NÃO ESTEJA CANCELADO*/
    --AND PGTO.DataEfetivacao <= @DataApuracao
    --AND NOT EXISTS (
    --                SELECT * 
    --                FROM Dados.Pagamento PGTO1 
    --                LEFT JOIN Dados.SituacaoProposta SP
    --                ON SP.ID = PGTO1.IDSituacaoProposta
    --                LEFT JOIN Dados.TipoMotivo TM
    --                ON TM.ID = PGTO1.IDMotivo
    --                WHERE PGTO1.IDProposta = PGTO.IDProposta 
    --                  AND (SP.Sigla IN ('CAN', 'REJ') OR TM.Codigo = '242')
    --                  AND PGTO1.DataArquivo <= @DataApuracao                      
    --               )  

 
