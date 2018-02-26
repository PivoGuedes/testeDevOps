
/*
	Autor: Egler Vieira
	Data Criação: 15/09/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Indicadores.proc_PremiacaoPagaAUTO
	Descrição: Procedimento que recupera premiação paga de PRESTAMISTA em um determinado período.
		
	Parâmetros de entrada: @DataInicioEmissao date
	                       @DataFimEmissao dae
	
					(Produtos 7705 e 7725)
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Indicadores].[proc_PremiacaoPagaAUTO] @Lote int, @NumeroApolice VARCHAR(40)
AS

DECLARE @SQLText VARCHAR(8000)
--DECLARE @NumeroApolice VARCHAR(40) = '105300001045'
--DECLARE @Lote int = 29

SET @SQLText = '
				SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, IT.NuApolice, PP.CodigoComercializado, P.ValorBruto, IT.Calculo_Gerente, IT.Calculo_Indicador, P.Gerente, P.NumeroParcela,  IT.NuParcela, P.TipoPagamento, P.DataArquivo, IT.CdLote, IT.DtEmissao, P.NumeroEndosso
				FROM Corporativo.Dados.PremiacaoIndicadores P
				INNER JOIN Corporativo.Dados.ProdutoPremiacao PP 
				ON PP.ID = P.IDProdutoPremiacao
				INNER JOIN Corporativo.Dados.Produto PRD
				ON PRD.CodigoComercializado = PP.CodigoComercializado
				INNER JOIN [CalculoComissao].[INDICADOR].[ITEM_LOTE_PREMIACAO] AS IT
				ON IT.NuApolice  COLLATE Latin1_General_CI_AI  = P.NumeroApolice and IT.NuParcela = P.NumeroParcela
				CROSS APPLY DADOS.fn_RecuperaRamoPAR_Mestre(PRD.IDRamoPAR) RM
				where  
					RM.Nome = ''Auto''' 
					
IF ISNULL(@NumeroApolice,'') <> ''
BEGIN
	SET @SQLText = @SQLText + ' AND NumeroApolice=''' + @NumeroApolice + ''''
END

IF ISNULL(@Lote,'') <> ''
BEGIN
	SET @SQLText = @SQLText + ' AND cdLote=''' + CAST(@Lote AS VARCHAR(4)) + ''''
END

SET @SQLText = @SQLText + ' group by P.IDFuncionario, P.IDUnidade, P.NumeroApolice,
				 PP.CodigoComercializado, P.ValorBruto, P.NumeroParcela, 
				 P.TipoPagamento, P.DataArquivo, P.Gerente, IT.CdLote,  IT.NuApolice,  IT.NuParcela,
				  IT.DtEmissao, IT.Calculo_Gerente, IT.Calculo_Indicador, P.NumeroEndosso
				ORDER BY P.NumeroApolice, P.NumeroParcela
				OPTION(OPTIMIZE FOR UNKNOWN)'
exec (@SQLText)

-- @DataInicioPremiacao date, @DataFimPremiacao date
--as
--SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, PP.CodigoComercializado, P.ValorBruto, P.NumeroParcela, P.TipoPagamento, P.DataArquivo, P.Gerente
--FROM Dados.PremiacaoIndicadores P
--INNER JOIN Dados.ProdutoPremiacao PP
--ON PP.ID = P.IDProdutoPremiacao
--INNER JOIN Dados.Produto PRD
--ON PRD.CodigoComercializado = PP.CodigoComercializado
-- CROSS APPLY DADOS.fn_RecuperaRamoPAR_Mestre(PRD.IDRamoPAR) RM 
--WHERE P.DataArquivo BETWEEN @DataInicioPremiacao AND @DataFimPremiacao
--AND RM.Nome = 'Auto'
--ORDER BY P.NumeroApolice, P.NumeroParcela
--OPTION(OPTIMIZE FOR UNKNOWN)
----exec Indicadores.proc_PremiacaoPagaAUTO '20160801', '20160831'
