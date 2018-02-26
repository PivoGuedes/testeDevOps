/*
	Autor: Egler Vieira
	Data Criação: 15/09/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Indicadores.proc_PremiacaoPagaPRESTAMISTA
	Descrição: Procedimento que recupera premiação paga de PRESTAMISTA em um determinado período.
		
	Parâmetros de entrada: @DataInicioEmissao date
	                       @DataFimEmissao dae
	
					(Produtos 7705 e 7725)
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Indicadores].[proc_PremiacaoPagaPRESTAMISTA] @Lote int, @NumeroApolice VARCHAR(40)
as


DECLARE @SQLText VARCHAR(8000)
--DECLARE @NumeroApolice VARCHAR(40)=''
--DECLARE @Lote int=NULL

SET @SQLText = '
				SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, IT.NuApolice, PP.CodigoComercializado, P.ValorBruto, IT.Calculo_Gerente, IT.Calculo_Indicador, P.Gerente, P.NumeroParcela,  IT.NuParcela, P.TipoPagamento, P.DataArquivo, IT.CdLote, IT.DtEmissao
				FROM Corporativo.Dados.PremiacaoIndicadores P
				INNER JOIN Corporativo.Dados.ProdutoPremiacao PP 
				ON PP.ID = P.IDProdutoPremiacao
				INNER JOIN Corporativo.Dados.Produto PRD
				ON PRD.CodigoComercializado = PP.CodigoComercializado
				INNER JOIN [CalculoComissao].[INDICADOR].[ITEM_LOTE_PREMIACAO] AS IT
				ON IT.NuApolice  COLLATE Latin1_General_CI_AI  = P.NumeroTitulo and IT.NuParcela = P.NumeroParcela
				where  
					PP.CodigoComercializado IN (''7705'',''7725'') '				
					
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
				  IT.DtEmissao, IT.Calculo_Gerente, IT.Calculo_Indicador
				ORDER BY P.NumeroApolice, P.NumeroParcela
				OPTION(RECOMPILE)'
--PRINT @SQLText
exec (@SQLText)


-- @DataInicioPremiacao date, @DataFimPremiacao date
--as
--SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, P.NumeroTitulo, PP.CodigoComercializado, P.ValorBruto, P.TipoPagamento, P.DataArquivo, P.Gerente
--FROM Dados.PremiacaoIndicadores P
--INNER JOIN Dados.ProdutoPremiacao PP
--ON PP.ID = P.IDProdutoPremiacao
--WHERE P.DataArquivo BETWEEN @DataInicioPremiacao AND @DataFimPremiacao
-- AND PP.CodigoComercializado IN ('7705','7725')
--OPTION(OPTIMIZE FOR UNKNOWN)

----exec Indicadores.proc_PremiacaoPagaPRESTAMISTA '20160801', '20160831'
