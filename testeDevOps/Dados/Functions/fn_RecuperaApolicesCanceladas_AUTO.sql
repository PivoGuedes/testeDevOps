

/*
	Autor: Egler Vieira
	Data Criação: 03/06/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaApolicesCanceladas_AUTO
	Descrição: Procedimento que realiza a recuperação das apólices de auto CANCELADAS/REJEITADAS.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
--CREATE FUNCTION Dados.ApolicesAutoVigentes(@DataInicialDeComecoDeVigencia AS DATE, @DataFimDeComecoDeVigencia AS DATE)
CREATE FUNCTION Dados.fn_RecuperaApolicesCanceladas_AUTO (@DataInicio AS DATE, @DataFim AS DATE)
RETURNS TABLE
AS
RETURN
--DECLARE @DataInicio AS DATE = '20130101'
--DECLARE @DataFim AS DATE = '20130131'
SELECT TOP 100 PERCENT
        CNT.ID [IDContrato], CNT.NumeroContrato, PRP.ID [IDProposta], PRP.NumeroProposta, --SE.Descricao [SituacaoEndosso],
        PC.CPFCNPJ, PC.Nome [NomeCliente], S.Descricao [Sexo], PC.TipoPessoa, EC.Descricao [EstadoCivil], 
        PC.DDDComercial, PC.TelefoneComercial, PC.DDDResidencial, PC.TelefoneResidencial, SP.Descricao [SituacaoProposta],/*PGTO.IDMotivo, PGTO.IDMotivoSituacao,*/ TM.Nome [Motivo], --TM2.Nome [MotivoSituacao],
        PC.DDDFax, PC.TelefoneFax, PC.Email, PC.Profissao, PC.DataNascimento, 
        U.Codigo [AgenciaVenda], FP.Descricao [FormaPagamento],
        PRP.DataProposta, PRP.DataInicioVigencia, PRP.DataFimVigencia,
        PGTO.Valor, PGTO.ValorIOF, PGTO.DataArquivo [DataCancelamento], --, PGTO.Arquivo,  
        PSIG.CodigoProduto, PSIG.Descricao [Produto], [IDProdutoComercializado], PRD.CodigoComercializado, PRD.Descricao [ProdutoComercializado]
FROM  Dados.Proposta PRP
      CROSS APPLY (SELECT TOP 1 PGTO.[IDProposta], PGTO.Valor, PGTO.ValorIOF, PGTO.DataArquivo, PGTO.IDSituacaoProposta, PGTO.IDMotivo
                   FROM Dados.PagamentoEmissao PGTO 
                   WHERE PGTO.IDProposta = PRP.ID 
                     AND (PGTO.IDSituacaoProposta NOT in (1, 21, 22, 23) OR PGTO.IDSituacaoProposta IS NULL)  /*EMT, ENV, MAN, VNC e com situação NULL*/
                     AND PGTO.DataArquivo  BETWEEN @DataInicio AND @DataFim
                     AND PGTO.IDMotivo IN (73, 43, 32, 29)
                   ORDER BY 	[IDProposta] ASC, [DataArquivo] ASC, [ID] ASC) PGTO  /*BUSCA A EMISSÃO ORIGINAL*/
      INNER JOIN Dados.ProdutoSIGPF PSIG
      ON PRP.IDProdutoSIGPF = PSIG.ID
      LEFT JOIN Dados.SituacaoProposta SP
      ON SP.ID = PGTO.IDSituacaoProposta 
      LEFT JOIN Dados.TipoMotivo TM
      ON TM.ID = PGTO.IDMotivo
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
                     AND EN.DataArquivo BETWEEN @DataInicio AND @DataFim 
                     AND ISNULL(EN.IDTipoEndosso, 255) IN (1,2,3,5) /*QUE ESTEJA CANCELADO*/
                   ORDER BY    IDContrato ASC, DataArquivo DESC, ID DESC) EN    /*Último Endosso*/
      LEFT JOIN Dados.TipoEndosso TE
      ON EN.IDTipoEndosso = TE.ID
      LEFT JOIN Dados.Produto PRD
      ON PRD.ID = EN.[IDProdutoComercializado]
      -- LEFT JOIN Dados.SituacaoEndosso SE
      --ON SE.ID = EN.IDSituacaoEndosso                   
WHERE   /*PGTO.IDSituacaoProposta = 1
    AND*/ PSIG.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '49')

    --AND PRP.DataInicioVigencia >= '2012-02-28' AND PRP.DataInicioVigencia <= '2013-03-12'
    ---AND PRP.DataFimVigencia >= @DataApuracao--'2014-03-12'      
    /*AND PGTO.DataEfetivacao <= @DataApuracao
    AND ( EXISTS (
                  SELECT * 
                  FROM Dados.Pagamento PGTO1 
                  LEFT JOIN Dados.SituacaoProposta SP
                  ON SP.ID = PGTO1.IDSituacaoProposta
                  LEFT JOIN Dados.TipoMotivo TM1
                  ON TM1.ID = PGTO1.IDMotivo
                  WHERE PGTO1.IDProposta = PGTO.IDProposta 
                    AND (SP.Sigla IN ('CAN', 'REJ') OR TM.Codigo = '242')
                    AND PGTO1.DataArquivo AND PGTO.DataArquivo  BETWEEN @DataInicio AND @DataFim                      
                 )  
         OR  */
         
         --)
