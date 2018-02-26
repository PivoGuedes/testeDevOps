
/*
	Autor: Egler Vieira
	Data Criação: 06/02/2013

	Descrição: 
	
	Última alteração : Egler - 2013-02-08 (Inclusão de data final)
                     Egler - 2013-02-23 (Encapsulamento da informação VendaNova na função - Dados.fn_VendaNova_Fluxo)
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaFaturamentoPorProdutoEFluxo_DataRecibo
	Descrição: Procedimento que realiza uma consulta retornando um
	RELATÓRIO, AGRUPANDO O FATURAMENTO POR PRODUTOs E FLUXO EM UM DIA ESPECÍFICO
		
	Parâmetros de entrada: @DataReciboInicial - Data do recibo
	                       @DataReciboFinal   - Data do recibo
	
					
	Retorno:
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaFaturamentoPorProdutoEFluxo_DataRecibo](@DataReciboInicial Date, @DataReciboFinal Date, @IDEmpresa INT, @ExtraRede BIT = 0)
AS
SELECT  PRD.CodigoComercializado, PRD.Descricao [Produto] --, R.Codigo [CodigoRamo], R.Nome [Ramo]
      , CASE WHEN [VendaNova] = 1 THEN 'Venda Nova' WHEN [VendaNova] = 0 THEN 'Fluxo' ELSE NULL END [VendaNova]
      --, CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN U.ASVEN = 1 THEN 'COM ASVEN' ELSE 'SEM ASVEN' END ELSE '-' END [COM/SEMASVEN]
      --, CVP.Nome [Canal], CVP1.Nome [CanalPai], CVP2.Nome [CanalAvo]        
      , AVG(CA.PercentualCorretagem) [PercentualCorretagem], SUM(CA.ValorBase) [ValorBase], SUM(CA.ValorCorretagem) [ValorCorretagem]   
      , SUM(ValorComissaoPAR) ValorComissaoPAR, SUM(ValorRepasse) ValorRepasse      
       /*, CVP.VendaAgencia,CVP.DigitoIdentificador, CVP.ProdutoIdentificador, CVP.MatriculaVendedorIdentificadora,  CVP.DataInicio*/
       /*  U.Codigo [CodigoUnidade], U.Nome [Unidade]*/
FROM (SELECT C.DataRecibo, C.IDProduto, C.PercentualCorretagem, C.ValorBase, C.ValorCorretagem, C.ValorComissaoPAR, C.ValorRepasse
           , Dados.fn_VendaNova_Fluxo(C.NumeroParcela, C.NumeroEndosso, C.ValorBase, C.IDOperacao) [VendaNova]
      FROM Dados.Comissao C
      WHERE C.DataRecibo BETWEEN @DataReciboInicial AND @DataReciboFinal
        AND C.Arquivo <> 'MANUAL'
		AND C.IDEmpresa = @IDEmpresa-- and c.NumeroRecibo = 20140039
		AND 1 = CASE WHEN @ExtraRede = 1 AND C.Arquivo  = 'COMI EXTRA REDE'  THEN 1
					   WHEN @ExtraRede = 0 AND (C.Arquivo != 'COMI EXTRA REDE' OR C.Arquivo IS NULL) THEN 1 
				ELSE 0 END
		) CA --Dados.vw_ComissaoAnalitico_DadosBasicos CA
INNER JOIN Dados.Produto PRD
ON PRD.ID = CA.IDProduto 
GROUP BY [VendaNova], PRD.CodigoComercializado, PRD.Descricao /*[Produto]*/
      /*
      , CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN U.ASVEN = 1 THEN 'COM ASVEN' ELSE 'SEM ASVEN' END ELSE '-' END /*[COM/SEMASVEN]*/
      , CVP.Nome /*[Canal]*/, CVP1.Nome /*[CanalPai]*/, CVP2.Nome /*[CanalAvo]*/ 
      */
/*************************************************************************************************************************************************/
--EXEC Dados.proc_RecuperaFaturamentoPorProdutoEFluxo_DataRecibo @DataReciboInicial = '2012-12-01', @DataReciboFinal = '2012-12-31'
