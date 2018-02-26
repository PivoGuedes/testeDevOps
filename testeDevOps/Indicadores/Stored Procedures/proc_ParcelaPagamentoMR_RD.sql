

/*
	Autor: Egler Vieira
	Data Criação: 15/09/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Indicadores.proc_ParcelaPagamentoMR_RD
	Descrição: Procedimento que recupera parcelas de MR e RD emitidos em um determinado período.
		
	Parâmetros de entrada: @DataInicioEmissao date
	                       @DataFimEmissao dae
	
					
	Retorno:


*******************************************************************************/

CREATE PROCEDURE [Indicadores].[proc_ParcelaPagamentoMR_RD] @DataInicioEmissao date, @DataFimEmissao date
AS

WITH CTE
AS
(
SELECT CNT.ID IDContrato, PRP.IDFuncionario, /*EN.ID,*/  PRD.ID[CODIGOPRODUTO], CNT.NumeroContrato,  EN.NumeroEndosso, PRD.CodigoComercializado, PRD.Descricao[Produto], 
                         PR.NumeroParcela,  PR.ValorPremioLiquido, SP.Descricao[SituacaoParcela], PO.Descricao[Operacao], PR.DataArquivo, U.Codigo[Agencia], RM.Nome Ramo, 
                         PRP.[DataProposta], PR.IDSituacaoParcela, CNT.DataEmissao
/*, PR.IDParcelaOperacao, PR.IDSituacaoParcela*/
FROM Dados.Contrato CNT INNER JOIN
                         DADOS.Endosso EN ON CNT.ID = EN.IDContrato
					 INNER JOIN
                         Dados.Parcela PR ON PR.IDEndosso = EN.ID 
						 INNER JOIN
                         Dados.Produto PRD ON PRD.ID = EN.IDProduto 
						 CROSS APPLY DADOS.fn_RecuperaRamoPAR_Mestre(PRD.IDRamoPAR) RM 
						 INNER JOIN
                         Dados.Proposta PRP ON PRP.ID = CASE WHEN EN.IDProposta = - 1 OR EN.IDProposta IS NULL THEN CNT.IDProposta ELSE EN.IDProposta END INNER JOIN
                           Dados.SituacaoParcela SP ON SP.ID = PR.IDSituacaoParcela 
						 LEFT JOIN
                         Dados.ParcelaOperacao PO ON PO.ID = PR.IDParcelaOperacao 
						 LEFT JOIN
                         Dados.Unidade U ON U.ID = PRP.IDAgenciaVenda
WHERE PRD.IDRamoPar IN (21, 51, 53, 54, 80, 81, 82) /*RM.Nome = 'Patrimonial' AND PRD.Descricao LIKE 'Residencial%' */ 
      --                 AND   ((IDSituacaoParcela = 1 OR
      --                   (IDSituacaoParcela = 2 AND PR.NumeroParcela IN (0, 1))) 

					 --OR 
					 --((IDSituacaoParcela = 5 OR
      --                   (IDSituacaoParcela = 6 AND PR.NumeroParcela IN (0, 1))) 
					 --)
					 --)
AND EN.NumeroEndosso = 0
AND CNT.DataEmissao between @DataInicioEmissao and @DataFimEmissao
--AND cnt.numerocontrato =  '1201403036218'
--AND PR.TipoDado <> 'PRD.FENAE.PARCELA'
--AND SP.Descricao = 'Paga'
AND PO.Descricao = 'Emissão'
AND CNT.IDSeguradora = 1
)
,
CTEA
AS
(
	SELECT CNT.ID IDContrato, PRPNContrato.IDFuncionario, PRPNContrato.DataProposta, PRPNContrato.NumeroProposta, PRPNContrato.IDPropostaM
	FROM Dados.Contrato CNT
	--CROSS APPLY (
	--			SELECT ID, NumeroProposta, IDPropostaM
	--			FROM Dados.Proposta PRP 
	--			WHERE PRP.ID = CNT.IDProposta
	--			) PRP
	CROSS APPLY (SELECT ID, IDFuncionario, DataProposta, NumeroProposta, IDPropostaM
				 FROM Dados.Proposta PRP
				 WHERE PRP.NumeroProposta = RIGHT('000000000000000' + CNT.NumeroContrato,15)
				 AND PRP.IDSeguradora = 1
				) PRPNContrato
	WHERE EXISTS (SELECT *
				  FROM CTE
				  WHERE CNT.ID = CTE.IDContrato
				 )
)
SELECT CTE.IDContrato, COALESCE(CTE.IDFuncionario, CTEA.IDFuncionario, - 1) IDFuncionario, F.Matricula, /*EN.ID,*/  CTE.[CODIGOPRODUTO], CTE.NumeroContrato, CTE.NumeroEndosso, CTE.CodigoComercializado, CTE.[Produto], 
                         CTE.NumeroParcela,  CTE.ValorPremioLiquido, CTE.[SituacaoParcela], CTE.[Operacao], CTE.DataArquivo, CTE.[Agencia], CTE.Ramo, 
                         COALESCE(CTE.[DataProposta], CTEA.DataProposta) DataProposta, CTE.IDSituacaoParcela, CTE.DataEmissao --, F.Matricula, F.CPF, F.UltimoCargo
FROM CTE
LEFT JOIN CTEA
ON CTEA.IDContrato = CTE.IDContrato
LEFT JOIN Dados.Funcionario F ON F.ID = COALESCE(CTE.IDFuncionario, CTEA.IDFuncionario, - 1) 
ORDER BY CTE.NumeroContrato, CTE.NumeroParcela
OPTION (OPTIMIZE FOR UNKNOWN)
