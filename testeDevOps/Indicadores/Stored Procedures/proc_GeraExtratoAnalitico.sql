
CREATE PROCEDURE [Indicadores].[proc_GeraExtratoAnalitico] (@DataInicio date, @DataFim Date)
AS

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Indicadores.ExtratoAnalitico') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE Indicadores.ExtratoAnalitico;


CREATE TABLE [Indicadores].[ExtratoAnalitico](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Matricula] [varchar](20) NULL,
	[CPF] [char](14) NULL,
	[Nome] [varchar](100) NULL,
	[LotacaoUF] [varchar](4) NULL,
	[LotacaoCidade] [varchar](60) NULL,
	[LotacaoDataInicio] [date] NULL,
	[Cargo] [varchar](100) NULL,
	[DataAtualizacaoFuncao] [date] NULL,
	[DataInicioFuncao] [date] NULL,
	[IndicadorArea] [varchar](30) NULL,
	[CodigoUnidade] [smallint] NOT NULL,
	[Produto] [varchar](5) NOT NULL,
	[NomeProduto] [varchar](100) NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroParcela] [int] NULL,
	[NumeroApolice] [varchar](20) NULL,
	[NumeroTitulo] [varchar](20) NULL,
	[ValorBrutoAnalitico] [decimal](19, 9) NULL,
	[ValorLiquidoAnalitico] [decimal](19, 6) NULL,
	[IRFAnalitico] [decimal](19, 6) NULL,
	[ISSAnalitico] [decimal](19, 6) NULL,
	[INSSAnalitico] [decimal](19, 6) NULL,
	[Tipo] [varchar](2) NULL,
	[ValorTeto] [decimal](19, 4) NULL,
	Retroativo [bit] NOT NULL default(0)
) ON [Dados]


--DECLARE @DataInicio date = '2015-01-29', @DataFim Date = '2015-01-29'
;
WITH CTE
AS
(
SELECT TOP 100 PERCENT PRI.IDFuncionario, PRI.IDProdutoPremiacao, PRI.IDUnidade
     , PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo, SUM(Cast(PRI.ValorBruto as decimal(24,9))) [ValorBrutoAnalitico]
       , Cast( RI.ValorBruto as decimal(24,9)) [ValorBrutoSintetico]
	   , /*ISNULL(RI.ValorIRF,0) +*/ ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)) ,0) [ValorIRFSintetico]
	   , /*ISNULL(RI.ValorISS,0) +*/ ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) [ValorISSSintetico]
       ,/* ISNULL(RI.ValorINSS,0) +*/ ISNULL(Cast(RI.CalculadoValorINSS  as decimal(24,9)),0) [ValorINSSintetico]
       , Cast(RI.ValorBruto as decimal(24,9)) -  ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0) [ValorLiquidoSintetico]
       , PRI.DataArquivo--, YEAR(PRI.DataArquivo) [AnoCompetentia], MONTH(PRI.DataArquivo) [MesCompetentia]
	   , PRI.IDLote, CASE WHEN EXISTS (SELECT * FROM ControleDados.IndicadoresAjustes I WHERE I.DataAjuste = PRI.DataArquivo) THEN 1 ELSE 0 END Retroativo
FROM Dados.PremiacaoIndicadores PRI
OUTER APPLY (--SUM E GROUP BY APLICADOS EM 29/01/2015 PARA TRATAR PAGAMENTO DE AJUSTE
             SELECT RI.DataReferencia, SUM(Cast(RI.ValorBruto as decimal(24,9))) ValorBruto
			                         , SUM(Cast(RI.CalculadoValorIRRF as decimal(24,9))) CalculadoValorIRRF
									 , SUM(Cast(RI.ValorIRF as decimal(24,9))) ValorIRF
									 , SUM(Cast(RI.ValorINSS as decimal(24,9))) ValorINSS
									 , SUM(Cast(RI.CalculadoValorINSS as decimal(24,9))) CalculadoValorINSS
									 , SUM(Cast(RI.ValorISS as decimal(24,9))) ValorISS
									 , SUM(Cast(RI.CalculadoValorISS as decimal(24,9))) CalculadoValorISS
                     FROM Dados.RepremiacaoIndicadores RI
                     WHERE  PRI.IDFuncionario = RI.IDFuncionario
					  AND (
							 (
							--	YEAR(PRI.DataArquivo)  = YEAR(RI.DataReferencia)
							--  AND MONTH(PRI.DataArquivo) = MONTH(RI.DataReferencia)
								PRI.DataArquivo = RI.DataArquivo
							 )
						     or
						     PRI.IDLote = RI.IDLote
						  )
						 --  AND ISNULL(PRI.IDLote, 0) = ISNULL(RI.IDLote,0)
                     GROUP BY RI.DataReferencia
                     --SUM E GROUP BY APLICADOS EM 29/01/2015 PARA TRATAR PAGAMENTO DE AJUSTE
             ) RI

WHERE 
-- pri.IDLote in (165, 166, 174) and
--     PRI.IDFuncionario = @IDIndicador 
-- and PRI.Gerente = @Gerente
-- AND LT.Tipo = CASE WHEN @Gerente = 1 THEN 'GI' ELSE 'I' END
-- and 
      (
		--      YEAR(PRI.DataArquivo) = @AnoCompetencia 
	    -- and  MONTH(PRI.DataArquivo) = @MesCompetencia 
	    PRI.DataArquivo BETWEEN @DataInicio AND @DataFim
	  --  AND	   
	  --  NOT EXISTS (SELECT * FROM ControleDados.IndicadoresAjustes I WHERE I.DataAjuste = PRI.DataArquivo)
      )
  and  (NOT 0 = ISNULL(RI.CalculadoValorISS,0)
		 OR
		  EXISTS (SELECT * FROM ControleDados.IndicadoresAjustes I WHERE I.DataAjuste = PRI.DataArquivo)
		  ) 
and PRI.IDUnidade is not null
		 -- and IDFuncionario = 66340
--where f.matricula = '00528250'
--WHERE PRI.IDFuncionario = 5678 and YEAR(PRI.DataArquivo) = 2012 and  MONTH(PRI.DataArquivo) = 12
--WHERE YEAR(RI.DataReferencia) >= 2014
GROUP BY  PRI.IDProdutoPremiacao, PRI.IDUnidade
        , YEAR(RI.DataReferencia), MONTH(RI.DataReferencia), PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo
              , RI.ValorBruto
              , ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0) 
              , ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) 
              , ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) 
              , Cast(RI.ValorBruto as decimal(24,9)) -  ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0)
              , PRI.DataArquivo--YEAR(PRI.DataArquivo), MONTH(PRI.DataArquivo)
			  -- , lt.Tipo, lt.id
			  ,PRI.IDLote
			  ,PRI.IDFuncionario
)
	   INSERT INTO Indicadores.ExtratoAnalitico ([Matricula]                   
											    ,[CPF]                           
											    ,[Nome]                          
											    ,[LotacaoUF]                     
											    ,[LotacaoCidade]                 
											    ,[LotacaoDataInicio]             
											    ,[Cargo]                         
											    ,[DataAtualizacaoFuncao]         
											    ,[DataInicioFuncao]              
											    ,[IndicadorArea]                 
											    ,[CodigoUnidade]                 
											    ,[Produto]                       
											    ,[NomeProduto]                   
											    ,[DataArquivo]                   
											    ,[NumeroParcela]                 
											    ,[NumeroApolice]                 
											    ,[NumeroTitulo]                  
											    ,[ValorBrutoAnalitico]           
											    ,[ValorLiquidoAnalitico]         
											    ,[IRFAnalitico]                  
											    ,[ISSAnalitico]                  
											    ,[INSSAnalitico]                 
											    ,[Tipo]                          
											    ,[ValorTeto]
				                                ,[Retroativo]   )  
       SELECT   F.Matricula
              , F.CPF
              , F.Nome
			  , FH.LotacaoUF
			  , FH.LotacaoCidade
			  , FH.LotacaoDataInicio
			  ,  FH.Cargo [Cargo]
			  , FH.DataAtualizacaoCargo DataAtualizacaoFuncao
			  , FH.FuncaoDataInicio [DataInicioFuncao]
			  , IA.Descricao [IndicadorArea]
			  --, FH.
              , U.Codigo [CodigoUnidade]
              , PP.CodigoComercializado [Produto]
              , PP.Descricao [NomeProduto]

              --, [AnoCompetentia]
              --, [MesCompetentia]
              , CTE.DataArquivo
              , NumeroParcela
              , ISNULL(CTE.NumeroApolice,'') NumeroApolice
              , ISNULL(CTE.NumeroTitulo,'') NumeroTitulo
              --##, CTE.[ValorBrutoSintetico]
        --      , (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) relacao_ValorLiquidoSintetico_BrutoSintetico
              , CTE.[ValorBrutoAnalitico]
              , CTE.[ValorBrutoAnalitico] * (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) [ValorLiquidoAnalitico]
              --##,, CTE.[ValorIRFSintetico]   
               , CTE.[ValorBrutoAnalitico] * (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) [IRFAnalitico]
--              , (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) [% IR]
              --##, CTE.[ValorISSSintetico]
              , CTE.[ValorBrutoAnalitico] * (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) [ISSAnalitico]
--              , (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) [% ISS]
              --###, [ValorINSSintetico]
              , CTE.[ValorBrutoAnalitico] * (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) [INSSAnalitico]
--              , (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) [% INSS]
			   , LT.Tipo
			  -- , LT.ID [Lote]
			   , PIT.ValorTeto
			   , CTE.Retroativo
              --###, CTE.[ValorLiquidoSintetico]
	  -- INTO Indicadores.ExtratoAnalitico
       FROM CTE	   
	   	INNER JOIN Dados.Funcionario F
		ON CTE.IDFuncionario = F.ID
	    INNER JOIN Dados.ProdutoPremiacao PP
		ON PP.ID = CTE.IDProdutoPremiacao
		LEFT JOIN Dados.Unidade U
		ON U.ID = CTE.IDUnidade
		LEFT JOIN ControleDados.LoteProtheus LT
		ON CTE.IDLote = LT.ID
		OUTER APPLY (SELECT TOP 1 ValorTeto
	        FROM Dados.PremiacaoIndicadoresTeto PIT
			WHERE PIT.DataInicio <= CTE.DataArquivo
			AND PIT.Tipo = LT.Tipo 
			ORDER BY PIT.DataInicio DESC
			) PIT
		OUTER APPLY (SELECT TOP 1 *
					 FROM Dados.FuncionarioHistorico FH
					 WHERE FH.IDFuncionario = CTE.IDFuncionario
					 AND FH.DataArquivo <= CTE.DataArquivo
					 ORDER BY IDFuncionario, FH.DataArquivo DESC
					) FH
		--LEFT JOIN Dados.Funcao FF
		--ON FH.IDFuncao = FF.ID
		LEFT JOIN Dados.IndicadorArea IA
		ON FH.IDIndicadorArea = IA.ID
OPTION (OPTIMIZE FOR (@DataInicio UNKNOWN, @DataFim UNKNOWN));
