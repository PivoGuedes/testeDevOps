/*
	Autor: Gustavo Moreira
	Data Criação: 29/07/2013

	Descrição: Retorna vigentes AUTO consultando a partir da data de última emissão.
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaApolicesVigentes_AUTO_UltimaEmissao
	Descrição: Procedimento que realiza a recuperação das apólices de auto VIGENTES.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Dados.fn_RecuperaApolicesVigentes_AUTO_UltimaEmissao()
RETURNS TABLE
AS
RETURN

SELECT TOP 100 PERCENT
        CNT.ID [IDContrato], CNT.NumeroContrato, PRP.ID [IDProposta], PRP.NumeroProposta, --SE.Descricao [SituacaoEndosso],
        PC.CPFCNPJ, PC.Nome [NomeCliente], S.Descricao [Sexo], PC.TipoPessoa, EC.Descricao [EstadoCivil], 
        PC.DDDComercial, PC.TelefoneComercial, PC.DDDResidencial, PC.TelefoneResidencial,
        PC.DDDFax, PC.TelefoneFax, PC.Email, PC.Profissao, PRP.RendaIndividual, PRP.RendaFamiliar, PC.DataNascimento, 
        U.Codigo [AgenciaVenda], FP.Descricao [FormaPagamento],
        PRP.DataProposta, PGTO.DataEfetivacao [DataEmissao], PRP.DataInicioVigencia, PRP.DataFimVigencia,
        PGTO.Valor, PGTO.ValorIOF, --PGTO.DataArquivo, PGTO.Arquivo,  
        PSIG.CodigoProduto, PSIG.Descricao [Produto], [IDProdutoComercializado], PRD.CodigoComercializado, PRD.Descricao [ProdutoComercializado]
        ,FU.Matricula [MatriculaIndicador]
FROM  Dados.Proposta PRP
	  OUTER APPLY (SELECT  MAX(PGTO1.DataEfetivacao) [DATAULTIMAEMISSAO]
		FROM Dados.PagamentoEmissao PGTO1 
		inner JOIN Dados.Proposta PRP1 
		ON PRP1.ID = PGTO1.IDProposta 
		inner JOIN Dados.ProdutoSIGPF PSIG1 
		ON PSIG1.ID = PRP1.IDProdutoSIGPF 
		WHERE  PSIG1.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37',
									  '38', '39', '42', '43', '44', '45', '49')
									  AND PGTO1.IDSituacaoProposta in (1, 21, 22)  /*EMT, ENV e MAN*/ 
									  ) DUT

      CROSS APPLY (SELECT TOP 1 PGTO.[IDProposta], PGTO.Valor, PGTO.ValorIOF, PGTO.DataEfetivacao 
	               FROM Dados.PagamentoEmissao PGTO 
                   WHERE PGTO.IDProposta = PRP.ID 
                     AND PGTO.IDSituacaoProposta in (1, 21, 22)  /*EMT, ENV e MAN*/
                   ORDER BY 	[IDProposta] ASC, [DataArquivo] ASC, [ID] ASC) PGTO  /*BUSCA A EMISSÃO ORIGINAL*/
      INNER JOIN Dados.ProdutoSIGPF PSIG
      ON PRP.IDProdutoSIGPF = PSIG.ID
      LEFT JOIN Dados.Funcionario FU
      ON FU.ID = PRP.IDFuncionario
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
                            DataArquivo DESC) MP
      LEFT JOIN Dados.FormaPagamento FP
      ON FP.ID = MP.IDFormaPagamento                            
      LEFT JOIN Dados.Unidade U
      ON U.ID = PRP.IDAgenciaVenda
      LEFT JOIN Dados.Contrato CNT
      ON CNT.ID = PRP.IDContrato
      OUTER APPLY (SELECT TOP 1 IDTipoEndosso, IDSituacaoEndosso, IDProduto [IDProdutoComercializado] 
                   FROM Dados.Endosso EN
                   WHERE EN.IDContrato = CNT.ID
                     AND EN.DataArquivo <= DUT.[DATAULTIMAEMISSAO] 
                   ORDER BY    IDContrato ASC, DataArquivo DESC, ID DESC) EN    /*Último Endosso*/
      LEFT JOIN Dados.TipoEndosso TE
      ON EN.IDTipoEndosso = TE.ID
      LEFT JOIN Dados.Produto PRD
      ON PRD.ID = EN.[IDProdutoComercializado]
     /* LEFT JOIN Dados.SituacaoEndosso SE
      ON SE.ID = EN.IDSituacaoEndosso */                  
WHERE   /*PGTO.IDSituacaoProposta = 1
    AND*/ PSIG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')
    --AND PRP.DataInicioVigencia >= '2012-02-28' AND PRP.DataInicioVigencia <= '2013-03-12'
    AND PRP.DataFimVigencia >= DUT.[DATAULTIMAEMISSAO] --'2014-03-12'      
    AND ISNULL(EN.IDTipoEndosso, 255) NOT IN (2,5) /*QUE NÃO ESTEJA CANCELADO*/
    AND PGTO.DataEfetivacao <= DUT.[DATAULTIMAEMISSAO] 
    AND NOT EXISTS (
                    SELECT *  /*TODO - MUDAR PARA O TIPO 1 E TIPO 8*/
                    FROM Dados.PagamentoEmissao PGTO1 
                    LEFT JOIN Dados.SituacaoProposta SP
                    ON SP.ID = PGTO1.IDSituacaoProposta

                    WHERE PGTO1.IDProposta = PGTO.IDProposta 
                      AND (SP.Sigla IN ('CAN', 'REJ'))	                 
                   )
    AND NOT EXISTS (
                    SELECT *  /*TODO - MUDAR PARA O TIPO 1 E TIPO 8*/
                    FROM Dados.Pagamento PGTO1 
                    LEFT JOIN Dados.TipoMotivo TM
                    ON TM.ID = PGTO1.IDMotivo
                    WHERE PGTO1.IDProposta = PGTO.IDProposta 
                      AND (TM.Codigo = '242')
                  
                   )  				