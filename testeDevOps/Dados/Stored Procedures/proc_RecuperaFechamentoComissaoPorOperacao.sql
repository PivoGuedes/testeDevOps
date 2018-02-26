
/*
	Autor: Egler Vieira
	Data Criação: 18/03/2013

	Descrição: 
	
	Última alteração : 29/08/2014 - Egler - Propagação da alteração do ID Empresa  (Estava apllicado apenas a prévia Protheus)
	                 : 14/05/2014 - Windson
					 : 20/02/2014 - Egler - Correção e OPTIMIZE FOR UNKNOWN
	Alterado por: 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaFechamentoComissaoPorOperacao
	Descrição: Procedimento que realiza uma consulta retornando um
	RELATÓRIO, AGRUPANDO O FECHAMENTO DE COMISSÃO (COMISSÃO ABERTA DE UM DIA ESPECIFICO) 
	                      POR OPERAÇÃO E RECIBO
	
		
	Parâmetros de entrada: @DataCompetencia - Data da competência

	
					
	Retorno:
	
*********************************** ********************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaFechamentoComissaoPorOperacao] @DataCompetencia DATE, @IDEmpresa INT, @ExtraRede BIT = 0
AS


SELECT EF.Autorizado, A.DataRecibo, A.DataCompetencia, A.NumeroRecibo, A.Descricao, A.ValorCorretagem, A.ValorComissaoPAR, A.ValorComissaoPARProtheus, A.IDEmpresa , NULL AS IDOperacao, NULL AS LancamentoProvisao --Incluído a pedido do Renan para corrigir o BOX.
FROM
(
SELECT  C.DataRecibo, C.DataCompetencia, C.NumeroRecibo, CO.Descricao, C.ValorCorretagem, C.ValorComissaoPAR, CProtheus.ValorComissaoPARProtheus, C.IDEmpresa 
FROM 
(SELECT C.DataRecibo, C.DataCompetencia, C.NumeroRecibo, C.IDOperacao, SUM(ValorCorretagem) ValorCorretagem, SUM(C.ValorComissaoPAR) ValorComissaoPAR, C.IDEmpresa 
FROM [Dados].Comissao C  --WITH (NOEXPAND)
WHERE C.DataCompetencia = @DataCompetencia 
AND C.IDEmpresa = @IDEmpresa-- and c.NumeroRecibo = 20140039
AND    1 = CASE WHEN @ExtraRede = 1 AND C.Arquivo  = 'COMI EXTRA REDE'  THEN 1
               WHEN @ExtraRede = 0 AND (C.Arquivo != 'COMI EXTRA REDE' OR C.Arquivo IS NULL) THEN 1 
		  ELSE 0 END
GROUP BY C.IDOperacao, C.DataCompetencia, C.DataRecibo, C.NumeroRecibo, C.IDEmpresa
) C
FULL JOIN
( /*SELECT A.NumeroRecibo, A.IDOperacao, SUM(ValorComissaoPARProtheus) ValorComissaoPARProtheus
  FROM
  (                                      */
  SELECT CC.DataRecibo, CC.DataCompetencia, CC.NumeroRecibo, CC.IDOperacao, Cast(SUM(CC.ValorComissao) as Decimal(38,2))  ValorComissaoPARProtheus, CC.IDEmpresa
  FROM [Dados].fn_RecuperaPreviaPROTHEUS(@DataCompetencia,@DataCompetencia,@IDEmpresa,@ExtraRede) CC
  GROUP BY CC.IDOperacao, CC.DataRecibo, CC.DataCompetencia, CC.NumeroRecibo, CC.IDEmpresa--, CC.IDProduto, IDRamo, IDCanalVendaPAR, IDCanalVendaPAR, IDFilialFaturamento, IDFilialPARCorretora, VendaNova, Repasse, DataRecibo, IDUnidadeVenda, DataCompetencia
  /*) A
  GROUP BY A.NumeroRecibo, A.IDOperacao*/
) CProtheus
ON CProtheus.IDOperacao = C.IDOperacao
AND CProtheus.NumeroRecibo = C.NumeroRecibo
AND CProtheus.DataRecibo = C.DataRecibo
AND CProtheus.IDEmpresa = C.IDEmpresa
INNER JOIN Dados.ComissaoOperacao CO
ON  CO.ID  = COALESCE(C.IDOperacao, CProtheus.IDOperacao) 
) A
LEFT JOIN  ControleDados.ExportacaoFaturamento EF 
           ON EF.DataCompetencia = A.DataCompetencia
          AND EF.DataRecibo = A.DataRecibo
          AND EF.NumeroRecibo = A.NumeroRecibo
		  AND EF.IDEmpresa = A.IDEmpresa

ORDER BY A.DataCompetencia, A.NumeroRecibo, /*A.IDOperacao,*/ A.Descricao
OPTION (MAXDOP 6,OPTIMIZE FOR (@DataCompetencia UNKNOWN, @IDEmpresa UNKNOWN))


----EXEC Dados.proc_RecuperaFechamentoComissaoPorOperacao '2014-02-19' 

--EXEC Dados.proc_RecuperaFechamentoComissaoPorOperacao '2014-09-17' , 3

----EXEC Dados.proc_RecuperaFechamentoComissaoPorOperacao '2014-10-31', 3, 1
