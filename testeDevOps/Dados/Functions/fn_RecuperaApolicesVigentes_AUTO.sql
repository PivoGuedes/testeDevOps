

/*
	Autor: Egler Vieira
	Data Criação: 28/02/2013

	Descrição: 
	
	
	Última alteração : Inclusao da Renda Individual e Familiar
					   Autor: Gustavo Moreira
					   Data alteração: 24/07/2013 
	
					   Inclusão da matricula do indicador
					   Autor: Gustavo Moreira
					   Data alteração: 21/06/2013 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaApolicesVigentes_AUTO
	Descrição: Procedimento que realiza a recuperação das apólices de auto VIGENTES.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
--CREATE FUNCTION Dados.ApolicesAutoVigentes(@DataInicialDeComecoDeVigencia AS DATE, @DataFimDeComecoDeVigencia AS DATE)
CREATE FUNCTION [Dados].[fn_RecuperaApolicesVigentes_AUTO] (@DataApuracao AS DATE)
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
        ,FU.Matricula [MatriculaIndicador], PRP.ValorPremioTotal
FROM  Dados.Proposta PRP
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
                     AND EN.DataArquivo <= @DataApuracao 
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
    AND PRP.DataFimVigencia >= @DataApuracao--'2014-03-12'      
    AND ISNULL(EN.IDTipoEndosso, 255) NOT IN (2,5) /*QUE NÃO ESTEJA CANCELADO*/
    AND PGTO.DataEfetivacao <= @DataApuracao
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
/*                   
CREATE NONCLUSTERED INDEX idx_NCLPagamento_DataEfetivacao_IDSituacaoProposta ON Dados.Pagamento
(
 DataEfetivacao,
 IDSituacaoProposta,
 IDProposta
)
INCLUDE
(
  Valor, ValorIOF 
)   */
                   
  /*
SELECT *
FROM Dados.fn_RecuperaApolicesVigentes_AUTO ('2012-03-01', '2013-03-31') AAV
where NOT EXISTS (
                     SELECT *
                     FROM dbo.APOLICES_VIGENTES_CS APCS
                     WHERE Cast(APCS.NUMERO_DA_PROPOSTA_DO_CONVENIO AS VARCHAR(20))= aav.NumeroProposta
                   )            
 AAV.NumeroProposta = '080526330125090'  
 */
