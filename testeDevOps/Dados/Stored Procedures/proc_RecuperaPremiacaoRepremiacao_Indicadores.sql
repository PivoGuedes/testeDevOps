 /******	Última alteração : William Moreira -> 2018/01/08: 
 Foram adiocionados RP.NomeArquivo no GROUP BY e o CASE WHEN no SELECT visando mostrar o ValorBrutoAnalitico por nome de arquivo  ******/

CREATE PROCEDURE [Dados].[proc_RecuperaPremiacaoRepremiacao_Indicadores] (@Ano smallint, @Mes tinyint)
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
		 ,CASE 
			WHEN NomeArquivo LIKE '%ODONTO%' THEN SUM(ValorBruto)
			WHEN NomeArquivo LIKE '%DCPGTIND_SINT%' THEN SUM(ValorBruto)
			ELSE SUM(ValorBruto)
		  END AS ValorBrutoAnalitico
		 -- ,(  SELECT  SUM(ValorBruto)         
		  --    FROM [Corporativo].[Dados].[PremiacaoIndicadores] P        
		--	  WHERE P.IDLote = RP.IDLote
		--	) ValorBrutoAnalitico  
         , LP.Tipo [TipoPremiacao]
		 , IdLote
FROM [Dados].[RePremiacaoIndicadores] RP
INNER JOIN ControleDados.LoteProtheus LP
ON LP.ID = RP.IDLote
--INNER JOIN Dados.Funcionario F
--ON F.ID = RP.IDFuncionario
WHERE DataReferencia BETWEEN @DataIni AND @DataFim 
GROUP BY  LP.Tipo, IdLote , Autorizado, RP.NomeArquivo
OPTION(OPTIMIZE FOR (@DataIni UNKNOWN, @DataFim UNKNOWN))
