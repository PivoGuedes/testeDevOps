


CREATE PROCEDURE [Dados].[proc_RecuperaPremiacaoRepremiacao_Indicadores_bkp] (@Ano smallint, @Mes tinyint)
AS
DECLARE @DataIni DATE = Cast(@Ano as varchar(4)) + '-' + RIGHT('0' + Cast(@Mes as varchar(2)), 2) + '-' + '01'
DECLARE @DataFim DATE = EOMONTH(@DataIni)

SELECT     COUNT(RP.IDFuncionario) Quantidade   
          ,SUM([ValorBruto]) ValorBruto    
		  ,SUM(ValorINSS) ValorINSS    
		  ,SUM(VALORISS) ValorISS    
		  ,SUM(ValorIRF) ValorIR    
		  ,SUM(VALORLIQUIDO) ValorLiquido    
		  ,Autorizado    
		  ,(  SELECT  SUM(ValorBruto)         
		      FROM [Corporativo].[Dados].[PremiacaoIndicadores] P        
			  WHERE P.IDLote = RP.IDLote
			) ValorBrutoAnalitico  
         , LP.Tipo [TipoPremiacao]
		 , IdLote
FROM [Dados].[RePremiacaoIndicadores] RP
INNER JOIN ControleDados.LoteProtheus LP
ON LP.ID = RP.IDLote
--INNER JOIN Dados.Funcionario F
--ON F.ID = RP.IDFuncionario
WHERE DataReferencia BETWEEN @DataIni AND @DataFim 
GROUP BY  LP.Tipo, IdLote , Autorizado
OPTION(OPTIMIZE FOR (@DataIni UNKNOWN, @DataFim UNKNOWN))
